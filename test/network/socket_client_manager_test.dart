// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/model/address_on_network.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/network/impl/socket_client_manager.dart';
import 'package:localchess/product/network/model/game_save_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';

import '../test_config/test_init.dart';

void main() async {
  // init with test storage implementation.
  await TestInit.initWithTestStorageImpl();

  // save a sample game save data.
  G.appStorage.gameSaveOperator.save(_gameSaveStorageModel);

  // create a test server.
  ServerSocket? testServer;

  setUp(() async {
    // expect localhost or its v4 address. The port is 8080.
    expect(_serverAddress.address.address, anyOf(['localhost', '127.0.0.1']));
    expect(_serverAddress.port, 8080);

    // run the test server
    testServer = await ServerSocket.bind(
      _serverAddress.address,
      _serverAddress.port,
    );
  });

  tearDown(() async {
    // close the test server
    await testServer?.close();
    testServer = null;
  });

  group('SocketClientManager connect server, send and receive data', () {
    test('SocketClientManager connect server, send and receive data', () async {
      var expectCheck_gameSaveReceived = false;
      var expectCheck_introduceDataReceived = false;

      expect(testServer, isNotNull);

      // listen to the server. send the received data back to the client.
      runZonedGuarded(
        () {
          testServer!.listen((socket) {
            socket.listen((data) async {
              final receivedData = String.fromCharCodes(data);
              G.logger.d('Server: Received data: $receivedData');
              socket.write(receivedData);
            });
          });
        },
        (e, __) {
          G.logger.e('Server error: $e');
        },
      );

      // define the manager to be tested.
      late final SocketClientManager manager;

      var requestCount = 1;

      // define the onData listener
      void onData(NetworkModel data) {
        if (data is IntroduceNetworkModel) {}
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
        if (--requestCount == 0) manager.disconnect();
      }

      void onConnected(
        SenderInformation serverInformation,
      ) {
        expect(
          serverInformation,
          const IntroduceNetworkModel().senderInformation,
        );
        expectCheck_introduceDataReceived = true;
      }

      // start client connection
      manager = await SocketClientManager.connect(
        address: _serverAddress,
        onDataListeners: [onData],
        onConnectedListener: onConnected,
      );

      // send data to the server.
      final sampleData = G.appStorage.gameSaveOperator.get('test_game');
      expect(sampleData, isNotNull);
      manager.send(
        data: GameSaveNetworkModel(
          gameSaveStorageModel: sampleData!,
        ),
      );

      // wait until the socket is disconnected.
      await manager.socket.done;

      // check the expectations.
      expect(expectCheck_gameSaveReceived, true);
      expect(expectCheck_introduceDataReceived, true);
    });
  });
}

final _serverAddress = AddressOnNetwork(
  address: InternetAddress.loopbackIPv4,
  port: 8080,
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
