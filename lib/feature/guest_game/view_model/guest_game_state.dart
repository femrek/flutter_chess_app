// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';

class GuestGameState {
  const GuestGameState();
}

class GuestGameLoadedState extends GuestGameState {
  const GuestGameLoadedState({
    required this.serverInformation,
    required this.gameName,
  });

  final SenderInformation serverInformation;
  final String gameName;
}
