// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/impl/socket_client_manager.dart';
import 'package:localchess/product/network/model/game_save_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';

import '../test_config/test_init.dart';

void main() async {
  // init with test cache implementation.
  await TestInit.initWithTestCacheImpl();

  // save a sample game save data.
  G.appCache.gameSaveOperator.save(_gameSaveCacheModel);

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
        (_, __) {},
      );

      // define the manager to be tested.
      late final SocketClientManager manager;

      var requestCount = 1;

      // define the onData listener
      void onData(NetworkModel data) {
        if (data is IntroduceNetworkModel) {}
        if (data is GameSaveNetworkModel) {
          expect(data.gameSaveCacheModel, isNotNull);
          expect(data.gameSaveCacheModel.id, _gameSaveCacheModel.id);
          expect(
            data.gameSaveCacheModel.gameSave.name,
            _gameSaveCacheModel.gameSave.name,
          );
          expectCheck_gameSaveReceived = true;
        }

        // if all requests are received, close the server.
        if (--requestCount == 0) manager.disconnect();
      }

      void onConnected(
        SenderInformation serverInformation,

        // game name is not used in this test because of the dummy host.
        String? gameName,
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
      final sampleData = await G.appCache.gameSaveOperator.get('test_game');
      expect(sampleData, isNotNull);
      manager.send(
        data: GameSaveNetworkModel(
          gameSaveCacheModel: sampleData!,
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

final _gameSaveCacheModel = GameSaveCacheModel(
  id: 'test_game',
  gameSave: const GameSave(
    name: 'Test Game',
    history: [],
    defaultPosition: '<sample fen>',
    isGameOver: false,
  ),
);
