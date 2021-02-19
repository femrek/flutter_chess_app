import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mychess/presentation/features/local_net_guest/guest_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/presentation/features/local_net_guest/guest_event.dart';

class ScreenLocalNetGuest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenlocalNetGuestState();
}

class _ScreenlocalNetGuestState extends State<ScreenLocalNetGuest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHESS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {
              context.read<GuestBloc>().add(GuestConnectEvent());
            },
            child: Text('connect'),
          ),
          RaisedButton(
            onPressed: () {

            },
            child: Text('disconnent'),
          ),
        ],
      ),
    );
  }

}