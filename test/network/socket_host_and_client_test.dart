// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/impl/socket_client_manager.dart';
import 'package:localchess/product/network/impl/socket_host_manager.dart';
import 'package:localchess/product/network/model/game_save_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';
import 'package:logger/logger.dart';

import '../test_config/test_init.dart';

void main() async {
  await TestInit.initWithTestCacheImpl();

  Logger.level = Level.debug;

  late final GameSaveCacheModel gameSaveCacheModel_serverToClient;
  late final GameSaveCacheModel gameSaveCacheModel_clientToServer;

  {
    final gameSaveCacheModel_serverToClient_raw = GameSaveCacheModel(
      id: 'test_game',
      gameSave: const GameSave(
        name: 'Test Game',
        history: [],
        defaultPosition: '<sample fen>',
        isGameOver: false,
      ),
    );

    final gameSaveCacheModel_clientToServer_raw = GameSaveCacheModel(
      id: 'test_game',
      gameSave: const GameSave(
        name: 'Test Game',
        history: [
          BoardStatusAndLastMove(
            fen: '<fen 2>',
            lastMoveFrom: 'a2',
            lastMoveTo: 'a4',
          ),
        ],
        defaultPosition: '<sample fen>',
        isGameOver: false,
      ),
    );

    await G.appCache.gameSaveOperator
        .save(gameSaveCacheModel_serverToClient_raw);
    gameSaveCacheModel_serverToClient = gameSaveCacheModel_serverToClient_raw;

    await G.appCache.gameSaveOperator
        .save(gameSaveCacheModel_clientToServer_raw);
    gameSaveCacheModel_clientToServer = gameSaveCacheModel_clientToServer_raw;
  }

  group('SocketHostManager and SocketClientManager', () {
    test('test if send and receive data. work well together', () async {
      var expectCheck_gameSaveReceived_server = false;
      var expectCheck_introduceDataReceived_server = false;
      var expectCheck_clientDisconnect_server = false;

      var expectCheck_gameSaveReceived_client = false;
      var expectCheck_introduceDataReceived_client = false;

      late final SocketHostManager serverManager;
      late final SocketClientManager clientManager;

      // setup server
      {
        var requestCount = 1;

        // define the onData listener
        void onData({
          required SenderInformation senderInformation,
          required NetworkModel data,
        }) {
          G.logger.d('Server: Received data: $data');

          if (data is GameSaveNetworkModel) {
            expect(data.gameSaveCacheModel, isNotNull);
            expect(data.gameSaveCacheModel.id,
                gameSaveCacheModel_clientToServer.id);
            expect(
              data.gameSaveCacheModel.gameSave.name,
              gameSaveCacheModel_clientToServer.gameSave.name,
            );
            expectCheck_gameSaveReceived_server = true;
          }

          // if all requests are received, close the server.
          if (--requestCount == 0) {
            G.logger.i('All requests received. Stopping the server.');
            serverManager.stopServer();
          }
        }

        void onClientConnect(SenderInformation clientInformation) {
          G.logger.d('Server: Client connected: $clientInformation');
          expect(
            clientInformation,
            const IntroduceNetworkModel().senderInformation,
          );
          expectCheck_introduceDataReceived_server = true;
        }

        void onClientDisconnect(SenderInformation clientInformation) {
          G.logger.d('Server: Client disconnected: $clientInformation');
          expect(
            clientInformation,
            const IntroduceNetworkModel().senderInformation,
          );
          expectCheck_clientDisconnect_server = true;
        }

        serverManager = await SocketHostManager.hostGame(
          address: _serverAddress,
          onDataListeners: [onData],
          onClientConnectListener: onClientConnect,
          onClientDisconnectListener: onClientDisconnect,
        );
      }

      // setup client
      {
        var requestCount = 1;

        // define the onData listener
        void onData(NetworkModel data) {
          if (data is GameSaveNetworkModel) {
            expect(data.gameSaveCacheModel, isNotNull);
            expect(data.gameSaveCacheModel.id,
                gameSaveCacheModel_serverToClient.id);
            expect(
              data.gameSaveCacheModel.gameSave.name,
              gameSaveCacheModel_serverToClient.gameSave.name,
            );
            expectCheck_gameSaveReceived_client = true;
          }

          if (--requestCount == 0) {
            G.logger.i('All requests received. Disconnecting the client.');
            clientManager.disconnect();
          }
        }

        void onConnected(
          SenderInformation serverInformation,
        ) {
          expect(
            serverInformation,
            const IntroduceNetworkModel().senderInformation,
          );
          expectCheck_introduceDataReceived_client = true;
        }

        clientManager = await SocketClientManager.connect(
          address: _serverAddress,
          onDataListeners: [onData],
          onConnectedListener: onConnected,
        );
      }

      // wait until the server establishes the connection
      {
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100), () {});
          return serverManager.clientsInformation.isEmpty;
        });
      }

      // send game data from server to client
      {
        // check and get the client info
        final clientsInfo = serverManager.clientsInformation;
        expect(clientsInfo.length, 1);
        final clientInfo = clientsInfo.first;

        // send
        final gameSaveData = GameSaveNetworkModel(
          gameSaveCacheModel: gameSaveCacheModel_serverToClient,
        );
        serverManager.send(
          clientInformation: clientInfo,
          data: gameSaveData,
        );
      }

      // send game data from client to server
      {
        final gameSaveData = GameSaveNetworkModel(
          gameSaveCacheModel: gameSaveCacheModel_clientToServer,
        );
        clientManager.send(data: gameSaveData);
      }

      // wait until the server and the client is stopped
      {
        await clientManager.socket.done;
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100), () {});
          return serverManager.isAlive;
        });
      }

      // check the expectations
      expect(expectCheck_gameSaveReceived_server, true);
      expect(expectCheck_introduceDataReceived_server, true);
      expect(expectCheck_clientDisconnect_server, true);

      expect(expectCheck_gameSaveReceived_client, true);
      expect(expectCheck_introduceDataReceived_client, true);
    });
  });
}

final _serverAddress = AddressOnNetwork(
  address: InternetAddress.loopbackIPv4,
  port: 8082,
);
