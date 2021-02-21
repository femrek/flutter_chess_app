import 'package:flutter/material.dart';
import 'package:mychess/data/storage_manager.dart';

class ScreenMain extends StatelessWidget {

  TextEditingController _hostTextController = TextEditingController();
  TextEditingController _portTextController = TextEditingController();

  Future setFieldsValues() async {
    _hostTextController.text = await StorageManager().lastConnectedHost;
    _portTextController.text = (await StorageManager().lastConnectedPort).toString();
  }

  @override
  Widget build(BuildContext context) {
    setFieldsValues();
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
            Column(
              children: [
                TextField(
                  controller: _hostTextController,
                ),
                TextField(
                  controller: _portTextController,
                  keyboardType: TextInputType.number,
                ),
                RaisedButton(
                  onPressed: () {
                    final String host = _hostTextController.text;
                    final int port = int.parse(_portTextController.text, onError: (String error) {
                      print('unvalid port number: $error');
                      return 0;
                    });
                    print('port input is $port');
                    StorageManager().setLastConnectedHost(host);
                    StorageManager().setLastConnectedPort(port);
                    Navigator.pushNamed(context, '/local_net_guest', arguments: [host, port]);
                  },
                  child: Text('join local network game'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}