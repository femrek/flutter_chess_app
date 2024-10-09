// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/address_on_network.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/network/impl/socket_host_manager.dart';
import 'package:localchess/product/network/model/game_save_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';

import '../test_config/test_init.dart';

void main() async {
  // init with test storage implementation.
  await TestInit.initWithTestStorageImpl();

  // save a sample game save data.
  G.appStorage.gameSaveOperator.save(_gameSaveStorageModel);

  group('SocketHostManager run server, receive and send data', () {
    test('SocketHostManager run server, receive and send data', () async {
      var expectCheck_gameSaveReceived = false;
      var expectCheck_introduceDataReceived = false;

      late final SocketHostManager manager;
      SenderInformation? firstClientInformation;

      // define onData listener and create the server
      {
        var requestCount = 1;

        // define the onData listener
        void onData({
          required SenderInformation senderInformation,
          required NetworkModel data,
        }) {
          G.logger.d('Server: Received data: $data');

          if (data is IntroduceNetworkModel) {
            fail('IntroduceNetworkModel data should not trigger onData');
          }
          if (data is GameSaveNetworkModel) {
            expect(data.gameSaveStorageModel, isNotNull);
            expect(data.gameSaveStorageModel.id, _gameSaveStorageModel.id);
            expect(
              data.gameSaveStorageModel.gameSave.name,
              _gameSaveStorageModel.gameSave.name,
            );
            expectCheck_gameSaveReceived = true;
          }

          // if all requests are received, close the server.
          if (--requestCount == 0) manager.stopServer();
        }

        // define the onClientConnect listener
        void onClientConnect(SenderInformation clientInformation) {
          G.logger.d('Server: Client connected: $clientInformation');

          // check if more than one client is connected
          if (firstClientInformation != null) {
            fail('Only one client should connect');
          }

          // check if the client information is correct
          expect(
            clientInformation,
            const IntroduceNetworkModel().senderInformation,
          );
          expectCheck_introduceDataReceived = true;

          // save the client information
          firstClientInformation = clientInformation;
        }

        manager = await SocketHostManager.hostGame(
          address: _serverAddress,
          onDataListeners: [onData],
          onClientConnectListener: onClientConnect,
        );
      }

      // expect the server to be created in the given address.
      expect(manager.server.port, _serverAddress.port);
      expect(manager.server.address, _serverAddress.address);

      // create a client to connect to the server
      final client = await Socket.connect(
        _serverAddress.address,
        _serverAddress.port,
      );

      // send introduce data
      {
        const introduceData = IntroduceNetworkModel();
        final introduceDataJson = jsonEncode(introduceData.toJson());
        client.write('$introduceDataJson${manager.configuration.delimiter}');
      }

      // send game save data
      {
        final gameSaveData = GameSaveNetworkModel(
          gameSaveStorageModel: _gameSaveStorageModel,
        );
        final gameSaveDataJson = jsonEncode(gameSaveData.toJson());
        client.write('$gameSaveDataJson${manager.configuration.delimiter}');
      }

      // check if the introduce data from host is correct
      {
        final dataRaw = await client.first;
        final dataString = String.fromCharCodes(dataRaw);
        final dataJson =
            dataString.split(manager.configuration.delimiter).first;
        final data = manager.configuration.modelFromJsonString(dataJson);

        expect(data, isA<IntroduceNetworkModel>());
        expect((data as IntroduceNetworkModel).senderInformation, isNotNull);
      }

      // wait until the server is stopped.
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100), () {});
        return manager.isAlive;
      });

      // close the client
      await client.close();

      // check if the all expectations are met.
      expect(expectCheck_gameSaveReceived, isTrue);
      expect(expectCheck_introduceDataReceived, isTrue);
    });
  });
}

final _serverAddress = AddressOnNetwork(
  address: InternetAddress.loopbackIPv4,
  port: 8081,
);

final _gameSaveStorageModel = GameSaveStorageModel(
  id: 'test_game',
  gameSave: const GameSave(
    name: 'Test Game',
    history: [],
    defaultPosition: '<sample fen>',
    isGameOver: false,
  ),
);
