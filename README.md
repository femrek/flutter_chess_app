# Local Chess
An usual chess game.

This application allows playing on a device or two device in the same local network.

[Download application for android](https://play.google.com/store/apps/details?id=dev.faruke.chess.localchess)

## Features
- Play with a friend on the same device
- Play with a friend on two devices in the same local network
- Scan the network for available games, or connect to a specific IP address

## Used Technologies
- Framework: Flutter
- Chess calculation: chess.dart (modified chess.js port)
- Network: dart:io (dart core library)
- Network information: network_info_plus
- Local storage: Hive-Isar
- State management: Bloc
- Dependency injection: GetIt
- Logging: logger
- Testing: flutter_test

Check the `pubspec.yaml` files for the dependencies used in the project and modules.

## Chess Piece Images
The chess piece images used in the project are available in the following link.
[Download pieces in svg format](https://opengameart.org/content/chess-pieces-in-svg-format)

## Thanks
The architecture of the project is inspired by the [VB10/architecture_template_v2](https://github.com/VB10/architecture_template_v2)
