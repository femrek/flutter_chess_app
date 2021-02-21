import 'package:flutter/material.dart';
import 'package:mychess/data/storage_manager.dart';
import 'package:mychess/presentation/features/local_net_guest/guest_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/presentation/features/local_net_guest/guest_event.dart';

import 'guest_chess_table.dart';

class ScreenLocalNetGuest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenlocalNetGuestState();
}

class _ScreenlocalNetGuestState extends State<ScreenLocalNetGuest> {

  TextEditingController _hostTextController = TextEditingController();
  TextEditingController _portTextController = TextEditingController();

  Future setFieldsValues() async {
    _hostTextController.text = await StorageManager().lastConnectedHost;
    _portTextController.text = (await StorageManager().lastConnectedPort).toString();
  }

  @override
  void initState() {
    setFieldsValues();
    super.initState();
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _portTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GuestChessTable(size: width),
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
                print('unvalid port number');
                return 0;
              });
              print('port input is $port');
              StorageManager().setLastConnectedHost(host);
              StorageManager().setLastConnectedPort(port);
              context.read<GuestBloc>().add(GuestConnectEvent(
                host: host,
                port: port,
              ));
            },
            child: Text('connect'),
          ),
          RaisedButton(
            onPressed: () {
              context.read<GuestBloc>().add(GuestDisconnectEvent());
            },
            child: Text('disconnent'),
          ),
        ],
      ),
    );
  }

}