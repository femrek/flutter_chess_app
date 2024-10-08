import 'dart:io';

import 'package:localchess/product/network/core/i_socket_configuration.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';

/// The onData event listener for the socket host.
typedef SocketHostOnDataListener = void Function({
  required SenderInformation senderInformation,
  required NetworkModel data,
});

/// The event listener for new connection on the socket host. The
/// [senderInformation] is the information of the connected client.
typedef SocketHostOnClientConnectListener = void Function(
    SenderInformation senderInformation);

/// The event listener for a client disconnection on the socket host.
/// The [senderInformation] is the information of the disconnected client.
typedef SocketHostOnClientDisconnectListener = void Function(
    SenderInformation senderInformation);

/// The interface for managing socket operations on the host side.
abstract interface class ISocketHostManager {
  /// The server socket instance.
  ServerSocket get server;

  /// The list of connected devices data.
  List<SenderInformation> get clientsInformation;

  /// The configuration of the socket.
  ISocketConfiguration get configuration;

  /// The list of functions to call when data is received.
  List<SocketHostOnDataListener> get onDataListeners;

  /// The function to call when a new client is connected.
  SocketHostOnClientConnectListener? get onClientConnectListener;

  /// The function to call when a client is disconnected.
  SocketHostOnClientDisconnectListener? get onClientDisconnectListener;

  /// Returns true if the server is still running. Return false if the server
  /// stopped.
  bool get isAlive;

  /// Adds the [listener] to [onDataListeners]. [listener] is triggered when
  /// the socket get a data.
  void addListener(SocketHostOnDataListener listener);

  /// Removes the [listener] from [onDataListeners]. [listener] is no longer
  /// triggered when the socket get a data.
  void removeListener(SocketHostOnDataListener listener);

  /// Stops the server.
  Future<void> stopServer();

  /// Sends data to a client with the given client device id. The data of this
  /// device should be added to the data before sending. Returns if the socket
  /// with [clientInformation] could find.
  bool send({
    required SenderInformation clientInformation,
    required NetworkModel data,
  });

  /// Sends data to all connected clients.
  void sendAll(NetworkModel data, {List<SenderInformation> exclude = const []});

  /// Kicks the client with the given [clientInformation] from the server.
  void kick(SenderInformation clientInformation);
}
