import 'package:flutter/material.dart';
import 'package:mychess/presentation/features/local_net_guest/guest_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/presentation/features/local_net_guest/guest_event.dart';

import 'guest_chess_table.dart';

class ScreenLocalNetGuest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenlocalNetGuestState();
}

class _ScreenlocalNetGuestState extends State<ScreenLocalNetGuest> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final List arg = ModalRoute.of(context).settings.arguments;
    context.read<GuestBloc>().add(GuestConnectEvent(
      host: arg[0],
      port: arg[1],
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GuestChessTable(size: width),
          RaisedButton(
            onPressed: () {
              context.read<GuestBloc>().add(GuestDisconnectEvent());
              Navigator.pop(context);
            },
            child: Text('disconnent'),
          ),
          RaisedButton(
            onPressed: () {
              context.read<GuestBloc>().add(GuestRefreshEvent());
            },
            child: Text('load'),
          ),
        ],
      ),
    );
  }

}