import 'package:core/src/network/sender_information.dart';

/// Interface for network models. Provides a method to convert a network model
/// to a json map and a method to convert a json map to a network model.
abstract interface class NetworkModel {
  /// The sender information of the device that sent the data.
  SenderInformation get senderInformation;

  /// Identifier for the data type. Recommended to use the name of the class.
  Object get typeId;

  /// Converts the object to a json map.
  Map<String, dynamic> toJson();

  /// Converts a json map to a network model. Calls from the sample models
  /// defined in the ISocketConfiguration implementation.
  NetworkModel fromJson(Map<String, dynamic> json);
}
