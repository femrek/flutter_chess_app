import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'guest_bloc.dart';
import 'guest_event.dart';
import 'guest_board.dart';

class ScreenGuestGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenGuestGameState();
}

class _ScreenGuestGameState extends State<ScreenGuestGame> {

  GuestBloc guestBloc;

  @override
  void initState() {
    guestBloc = context.read<GuestBloc>();
    super.initState();
  }

  @override
  void dispose() {
    guestBloc.add(GuestDisconnectEvent());
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
          GuestBoard(size: width),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('disconnect'),
          ),
          RaisedButton(
            onPressed: () {
              context.read<GuestBloc>().add(GuestRefreshEvent());
            },
            child: Text('reload from host'),
          ),
        ],
      ),
    );
  }

}