import 'dart:io';

import 'package:core/core.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/model/disconnect_network_model.dart';
import 'package:localchess/product/network/model/introduce_network_model.dart';

/// The implementation of the [ISocketClientManager] interface.
class SocketClientManager implements ISocketClientManager {
  SocketClientManager._internal({
    required Socket socket,
    this.onConnectedListener,
    this.onKickedListener,
    List<SocketClientOnDataListener>? onDataListeners,
  }) : _socket = socket {
    if (onDataListeners != null) _onDataListeners.addAll(onDataListeners);
  }

  /// Connects to the server. Returns a [Future] of [SocketClientManager].
  /// Use this method to create a new instance of [SocketClientManager] by
  /// connecting to the server.
  static Future<SocketClientManager> connect({
    required AddressOnNetwork address,
    SocketClientOnConnectedListener? onConnectedListener,
    SocketClientOnKickedListener? onKickedListener,
    List<SocketClientOnDataListener>? onDataListeners,
  }) async {
    // create the instance
    final socket = await Socket.connect(address.address, address.port);
    final i = SocketClientManager._internal(
      socket: socket,
      onDataListeners: onDataListeners,
      onKickedListener: onKickedListener,
      onConnectedListener: onConnectedListener,
    );

    // initialize
    await _init(i);

    return i;
  }

  static Future<void> _init(SocketClientManager i) async {
    i._onData.listen((data) {
      // trigger the introduce listener to establish the connection.
      if (data is IntroduceNetworkModel) {
        _onConnectionIntroduceListener(
          manager: i,
          data: data,
        );
        return;
      }

      // trigger connection done listener when the connection is closed by the
      // client
      if (data is DisconnectNetworkModel) {
        _onKickedListener(
          manager: i,
          data: data,
        );
        return;
      }

      for (final listener in i.onDataListeners) {
        listener(data);
      }
    });

    i._introduce(i.socket);
  }

  // private instance fields
  bool _connected = false;
  late final Socket _socket;
  SenderInformation? _serverInfo;
  final List<SocketClientOnDataListener> _onDataListeners = [];

  @override
  Socket get socket => _socket;

  @override
  bool get isConnected => _connected;

  @override
  ISocketConfiguration get configuration => G.socketConfiguration;

  @override
  List<SocketClientOnDataListener> get onDataListeners => _onDataListeners;

  @override
  SocketClientOnConnectedListener? onConnectedListener;

  @override
  SocketClientOnKickedListener? onKickedListener;

  @override
  SenderInformation? get remoteInfo => _serverInfo;

  @override
  void addListener(SocketClientOnDataListener listener) {
    _onDataListeners.add(listener);
  }

  @override
  void removeListener(SocketClientOnDataListener listener) {
    _onDataListeners.remove(listener);
  }

  @override
  void send({required NetworkModel data}) {
    final dataString = configuration.jsonStringFromModel(data);
    G.logger.t('Sending data: $dataString');
    _socket.write('$dataString${configuration.delimiter}');
    G.logger.t('Data sent');
  }

  @override
  void disconnect() {
    G.logger.t('Disconnecting from server');
    send(data: const DisconnectNetworkModel());
    _socket.destroy();
    _connected = false;
    G.logger.t('Disconnected from server');
  }

  /// The onData event listener for the socket client. Used expand, because
  /// the data can be received in multiple pieces at once.
  Stream<NetworkModel> get _onData => socket.expand((event) {
        final data = String.fromCharCodes(event);
        final splitData = data.split(configuration.delimiter)..removeLast();
        G.logger.d('Received data: $data split ${splitData.length} piece');
        return splitData.map((e) => configuration.modelFromJsonString(e));
      });

  void _introduce(Socket socket) {
    G.logger.t('_introduce: Introducing to server');
    send(data: const IntroduceNetworkModel());
    G.logger.t('_introduce: Introduce message sent');
  }

  static void _onConnectionIntroduceListener({
    required SocketClientManager manager,
    required IntroduceNetworkModel data,
  }) {
    G.logger.t('_onConnectionIntroduceListener: Introduce data received: '
        '$data');

    manager
      // save the server information
      .._serverInfo = data.senderInformation

      // set the connection status
      .._connected = true

      // trigger the onConnectClientListener
      ..onConnectedListener?.call(
        data.senderInformation,
      );

    G.logger.t('_onConnectionIntroduceListener: end: Client connected: '
        '${data.senderInformation}');
  }

  static void _onKickedListener({
    required SocketClientManager manager,
    required DisconnectNetworkModel data,
  }) {
    G.logger.t('onKickedListener: Kicked by server: $data');

    manager.onKickedListener?.call();

    manager.socket.destroy();
  }
}
