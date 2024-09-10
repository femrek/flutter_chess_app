import 'dart:io';

import 'package:core/src/network/i_socket_configuration.dart';
import 'package:core/src/network/network_model.dart';
import 'package:core/src/network/sender_information.dart';

/// The onData event listener for the socket client.
typedef SocketClientOnDataListener = void Function(NetworkModel data);

/// The onConnected event listener to trigger when the information data is
/// received from the host.
typedef SocketClientOnConnectedListener = void Function(
    SenderInformation hostInfo);

/// Interface for managing operations on a client side socket.
abstract interface class ISocketClientManager {
  /// The socket instance
  Socket get socket;

  /// The host of the socket
  bool get isConnected;

  /// The configuration of the socket
  ISocketConfiguration get configuration;

  /// The list of functions to call when data is received
  List<SocketClientOnDataListener> get onDataListeners;

  /// The function to call when the connection is established
  SocketClientOnConnectedListener? get onConnectedListener;

  /// The information of the remote server
  SenderInformation? get remoteInfo;

  /// Adds the [listener] to [onDataListeners]. [listener] is triggered when
  /// the socket get a data.
  void addListener(SocketClientOnDataListener listener);

  /// Removes the [listener] from [onDataListeners]. [listener] is no longer
  /// triggered when the socket get a data.
  void removeListener(SocketClientOnDataListener listener);

  /// Disconnects from the socket server.
  void disconnect();

  /// Sends data to the socket server. device information should be added to the
  /// data before sending.
  void send({required NetworkModel data});
}
