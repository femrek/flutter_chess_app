# Local Chess
A usual chess game.

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
- Localization: easy_localization
- Logging: logger
- Testing: flutter_test

Check the `pubspec.yaml` files for the dependencies used in the project and modules.

## Localized Languages
- English
- Turkish

## Chess Piece Images
The chess piece images used in the project are available in the following link.
[Download pieces in svg format](https://opengameart.org/content/chess-pieces-in-svg-format)
## Screenshots
<details open>
  <summary> Home </summary> <br>
  <img alt="" src="https://github.com/user-attachments/assets/716a1ee8-fcd0-4d31-90a6-5783e643d23e" width="240" height="520" /> 
</details>
<details open>
  <summary> Local Game </summary> <br>
  <img alt="" src="https://github.com/user-attachments/assets/3b39fa14-7425-47bc-8f2e-1ebc94ac052a" width="240" height="520" />
  <img alt="" src="https://github.com/user-attachments/assets/6f5b6381-9d71-4974-bd05-756eb9125d9e" width="240" height="520" />
</details>
<details>
  <summary> Host Game </summary> <br>
  <img alt="" src="https://github.com/user-attachments/assets/2b3bd31e-7f49-47b6-948b-d84a24dde3f2" width="240" height="520" />
  <img alt="" src="https://github.com/user-attachments/assets/8f270bbb-d82c-4bb2-b2f4-6c4e996baf02" width="240" height="520" />
</details>
<details>
  <summary> Guest Game </summary> <br>
  <img alt="" src="https://github.com/user-attachments/assets/f67d00cf-343e-4071-b6d3-f76c9a0a45f2" width="240" height="520" />
  <img alt="" src="https://github.com/user-attachments/assets/b87dd5a2-5f97-4f84-8d8c-484b3c3e96e0" width="240" height="520" />
</details>

## Thanks
The architecture of the project is inspired by the [VB10/architecture_template_v2](https://github.com/VB10/architecture_template_v2)
