import 'package:flutter/material.dart';
import 'package:localchess/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHESS'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 1) {
                launchUrl(
                  Uri.parse('https://www.freeprivacypolicy.com/live/74fcc445-b75d-4551-8cf1-62d7dcc74120'),
                  mode: LaunchMode.inAppWebView,
                );
              }
              else {
                throw 'undefined menu button';
              }
            },
            itemBuilder: (_) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(
                  child: Text('privacy policy'),
                  value: 1,
                ),
              ];
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12,),
            _localGameCard(context),
            const SizedBox(height: 12,),
            _networkGameCard(context),
            const SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  Widget _networkGameCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 12,),
            Text(
              'Play with two device on the same network',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12,),
            _divider(context),
            const SizedBox(height: 12,),
            Text(
              'Create a game in a phone',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, screenHostGame);
              },
              child: Text(
                'Create a Game',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8,),
            _divider(context),
            const SizedBox(height: 12,),
            Text(
              'Join the game by the other device',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, screenJoinGame);
              },
              child: Text(
                'Join a Local Game',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }

  Widget _localGameCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 12,),
            Text(
              'Play chess with only this device',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12,),
            _divider(context),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, screenLocalGame);
              },
              child: Text(
                'Play Two Player',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width - 24,
      color: Theme.of(context).disabledColor,
    );
  }
}