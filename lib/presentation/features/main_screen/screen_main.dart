import 'package:flutter/material.dart';

class ScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/local_game');
              },
              child: Text('local game'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/local_net_game');
              },
              child: Text('create local network game'),
            ),
          ],
        ),
      ),
    );
  }

}