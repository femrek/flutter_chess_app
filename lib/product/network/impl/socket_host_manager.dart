import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:localchess/product/dependency_injection/get.dart';
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
  static Future<SocketHostManager> create({
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
      await _init(i);

      return i;
    } on SocketException {
      if (!runRandomPortIfBusy) rethrow;
      G.logger.w('Port is busy, trying random port');
      return create(
        address: AddressOnNetwork(address: address.address, port: 0),
      );
    }
  }

  static Future<void> _init(SocketHostManager i) async {
    i._serverSocket.listen((socket) async {
      final remoteAddress = '${socket.remoteAddress}:${socket.remotePort}';
      G.logger.d('Client connected: $remoteAddress');

      // trigger the listeners when data is received
      i._onData(socket).listen((event) {
        if (event is IntroduceNetworkModel) {
          // trigger the introduce listener to establish the connection.
          _onConnectionIntroduceListener(
            manager: i,
            socket: socket,
            data: event,
          );
          return;
        }
        for (final listener in i.onDataListeners) {
          listener(
            clientDeviceId: event.senderInformation.deviceId,
            data: event,
          );
        }
      });

      // trigger the listeners when the connection is closed by the client
      unawaited(socket.done.then((_) {
        _onConnectionDoneListener(
          manager: i,
          socket: socket,
          remoteAddress: remoteAddress,
        );
      }));

      // add the socket to the waiting clients until it introduces itself
      i._waitingClients.add(socket);

      // add the introduce listener then send introduce data to the client
      i._introduce(socket);
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

  void _introduce(Socket socket) {
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
