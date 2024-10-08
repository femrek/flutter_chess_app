import 'dart:async';
import 'dart:io';

import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/i_socket_configuration.dart';
import 'package:localchess/product/network/core/i_socket_host_manager.dart';
import 'package:localchess/product/network/core/model/address_on_network.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/network/model/disconnect_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';

/// The implementation of the [ISocketHostManager] interface.
///
/// [SocketHostOnDataListener] can not be triggered when
/// [IntroduceNetworkModel] data.
class SocketHostManager implements ISocketHostManager {
  SocketHostManager._internal({
    required ServerSocket serverSocket,
    this.onClientConnectListener,
    this.onClientDisconnectListener,
    List<SocketHostOnDataListener>? onDataListeners,
  }) : _serverSocket = serverSocket {
    if (onDataListeners != null) _onDataListeners.addAll(onDataListeners);
  }

  /// Creates a new [SocketHostManager] instance. Starts the server on
  /// [address] and returns the [SocketHostManager] object.
  /// [onDataListeners] can not [IntroduceNetworkModel] data.
  static Future<SocketHostManager> hostGame({
    required AddressOnNetwork address,
    SocketHostOnClientConnectListener? onClientConnectListener,
    SocketHostOnClientDisconnectListener? onClientDisconnectListener,
    List<SocketHostOnDataListener>? onDataListeners,
    bool runRandomPortIfBusy = false,
  }) async {
    try {
      // create the instance
      final serverSocket = await ServerSocket.bind(
        address.address,
        address.port,
      );
      final i = SocketHostManager._internal(
        serverSocket: serverSocket,
        onDataListeners: onDataListeners,
        onClientConnectListener: onClientConnectListener,
        onClientDisconnectListener: onClientDisconnectListener,
      );

      // initialize
      await _init(
        instance: i,
      );

      return i;
    } on SocketException {
      if (!runRandomPortIfBusy) rethrow;
      G.logger.w('Port is busy, trying random port');
      return hostGame(
        address: AddressOnNetwork(address: address.address, port: 0),
      );
    }
  }

  static Future<void> _init({
    required SocketHostManager instance,
  }) async {
    runZonedGuarded(() {
      instance._serverSocket.listen((socket) async {
        final remoteAddress = '${socket.remoteAddress}:${socket.remotePort}';
        G.logger.d('Client connected: $remoteAddress');

        // trigger the listeners when data is received
        instance._onData(socket).listen((event) {
          // trigger the introduce listener to establish the connection.
          if (event is IntroduceNetworkModel) {
            _onConnectionIntroduceListener(
              manager: instance,
              socket: socket,
              data: event,
            );
            return;
          }

          // trigger connection done listener when the connection is closed by
          // the client
          if (event is DisconnectNetworkModel) {
            _onConnectionDoneListener(
              manager: instance,
              socket: socket,
              remoteAddress: remoteAddress,
            );
            return;
          }

          for (final listener in instance.onDataListeners) {
            listener(
              senderInformation: event.senderInformation,
              data: event,
            );
          }
        });

        // add the socket to the waiting clients until it introduces itself
        instance._waitingClients.add(socket);

        // add the introduce listener then send introduce data to the client
        instance._introduce(
          socket: socket,
        );
      });
    }, (error, stackTrace) {
      if (error is SocketException) {
        G.logger.w('SocketException in serverSocket.listen');
      } else {
        // ignore: only_throw_errors
        throw error;
      }
    });
  }

  // private instance fields
  final ServerSocket _serverSocket;
  final List<Socket> _waitingClients = [];
  final Map<SenderInformation, Socket> _clients = {};
  final List<SocketHostOnDataListener> _onDataListeners = [];
  bool _isAlive = true;

  @override
  bool get isAlive => _isAlive;

  @override
  ServerSocket get server => _serverSocket;

  @override
  ISocketConfiguration get configuration => G.socketConfiguration;

  @override
  List<SenderInformation> get clientsInformation => _clients.keys.toList();

  @override
  List<SocketHostOnDataListener> get onDataListeners => _onDataListeners;

  @override
  final SocketHostOnClientConnectListener? onClientConnectListener;

  @override
  final SocketHostOnClientDisconnectListener? onClientDisconnectListener;

  @override
  void addListener(SocketHostOnDataListener listener) {
    _onDataListeners.add(listener);
  }

  @override
  void removeListener(SocketHostOnDataListener listener) {
    _onDataListeners.remove(listener);
  }

  @override
  bool send({
    required SenderInformation clientInformation,
    required NetworkModel data,
  }) {
    G.logger.t('Sending data to client: $clientInformation');
    final client = _clients[clientInformation];

    if (client == null) {
      G.logger.e('Client not found with device id: $clientInformation');
      return false;
    }

    _send(client, data);
    G.logger.t('Data sent to client: $clientInformation');
    return true;
  }

  @override
  void sendAll(
    NetworkModel data, {
    List<SenderInformation> exclude = const [],
  }) {
    G.logger.t('Sending data to all clients');
    for (final entry in _clients.entries) {
      final socket = entry.value;
      final client = entry.key;
      if (exclude.contains(client)) continue;
      _send(socket, data);
    }
    G.logger.t('Data sent to all clients');
  }

  @override
  void kick(SenderInformation senderInformation) {
    final client = _clients[senderInformation];
    if (client == null) {
      G.logger.e('Client not found with device id: $senderInformation');
      return;
    }

    _send(client, const DisconnectNetworkModel());
    client.destroy();
    _clients.remove(senderInformation);
  }

  void _send(Socket client, NetworkModel data) {
    final dataString = configuration.jsonStringFromModel(data);
    G.logger.d('Host: Data to send: $dataString');

    client.write('$dataString${configuration.delimiter}');
  }

  @override
  Future<void> stopServer() async {
    G.logger.t('stopServer start');

    for (final socket in _waitingClients) {
      socket.destroy();
    }
    for (final socket in _clients.values) {
      _send(socket, const DisconnectNetworkModel());
      socket.destroy();
    }

    await _serverSocket.close();

    _isAlive = false;

    G.logger.t('stopServer end');
  }

  Stream<NetworkModel> _onData(Socket socket) => socket.expand((event) {
        final data = String.fromCharCodes(event);
        final splitData = data.split(configuration.delimiter)..removeLast();
        G.logger
            .d('Host: Received data: $data split ${splitData.length} piece');
        return splitData.map((e) => configuration.modelFromJsonString(e));
      });

  void _introduce({
    required Socket socket,
  }) {
    _send(socket, const IntroduceNetworkModel());
  }

  static void _onConnectionIntroduceListener({
    required SocketHostManager manager,
    required Socket socket,
    required IntroduceNetworkModel data,
  }) {
    G.logger.t('_onConnectionIntroduceListener: Introduce data received: '
        '${data.senderInformation}');

    if (manager._clients[data.senderInformation] != null) {
      G.logger.w('Client already connected: ${data.senderInformation}');
      manager.kick(data.senderInformation);
    }

    // add the client to the clients
    manager._clients[data.senderInformation] = socket;

    // remove the client from the waiting clients
    manager._waitingClients.remove(socket);

    // trigger the onConnectClientListener
    manager.onClientConnectListener?.call(data.senderInformation);

    G.logger.t('_onConnectionIntroduceListener: end: Client connected: '
        '${data.senderInformation}, '
        '_clients result: ${manager._clients.keys}');
  }

  static void _onConnectionDoneListener({
    required SocketHostManager manager,
    required Socket socket,
    required String remoteAddress,
  }) {
    G.logger.t('_onConnectionDoneListener: start: $remoteAddress');

    // remove the client from the clients
    final removes = manager._clients.entries.where((e) => e.value == socket);
    final removedSenderInfo = removes.firstOrNull?.key;
    final removed = manager._clients.remove(removedSenderInfo);

    G.logger.d('Client removed: $removedSenderInfo => $removed');

    // remove the client socket if it is waiting
    final wasWaiting = manager._waitingClients.remove(socket);

    assert(removedSenderInfo != null || wasWaiting, 'Client not found');
    assert(
      !(removedSenderInfo != null && wasWaiting),
      'Client found in both lists',
    );

    G.logger.t('_onConnectionDoneListener: end: $remoteAddress, '
        'wasWaiting: $wasWaiting, '
        '_clients result: ${manager._clients.keys}');

    // trigger the onDisconnectClientListener
    if (removedSenderInfo != null) {
      manager.onClientDisconnectListener?.call(removedSenderInfo);
    }
  }
}
