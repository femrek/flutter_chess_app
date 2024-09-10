import 'package:core/src/network/network_model.dart';

/// Interface for managing the configuration of a socket. Keeps the types of
/// network models and provides a method to get a network model from a type id.
abstract interface class ISocketConfiguration {
  /// The list of network models. Create a list of empty network models and
  /// add the network models to the list.
  List<NetworkModel> get models;

  /// Gets the registered network model from a type id. checks if the type id is
  /// in the list of network models and returns the sample network model.
  NetworkModel sampleModelById(Object typeId);

  /// Converts the json string to a network model. The json string should have
  /// a typeId field to identify the network model.
  NetworkModel modelFromJsonString(String jsonString);

  /// Converts the network model to a json string.
  String jsonStringFromModel(NetworkModel model);

  /// The pattern to divide the data.
  String get delimiter;
}
