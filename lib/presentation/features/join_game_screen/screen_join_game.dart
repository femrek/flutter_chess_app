import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/game_search_information.dart';
import 'package:localchess/data/storage_manager.dart';
import 'package:localchess/routes.dart';

import 'game_scan_cubit.dart';

class ScreenJoinGame extends StatelessWidget {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _portTextController = TextEditingController();

  ScreenJoinGame({
    Key? key,
  }) : super(key: key) {
    setFieldsValues();
  }

  Future setFieldsValues() async {
    _hostTextController.text = await StorageManager().lastConnectedHost ?? '';
    _portTextController.text = (await StorageManager().lastConnectedPort).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Game'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _joinGameCard(context),
          ),
          const SizedBox(height: 12,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _gameScanList(context),
            ),
          ),
          const SizedBox(height: 12,),
        ],
      ),
    );
  }

  Widget _gameScanList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<GameScanCubit, GameScanState>(
        builder: (_, state) {
          return Column(
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      onPressed: state.searchStatus != SearchStatus.searching ? () {
                        context.read<GameScanCubit>().startScan();
                      } : null,
                      child: Text(
                        state.searchStatus == SearchStatus.searching
                            ? 'Scanning' : 'Scan',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onPrimary
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                          state.searchStatus == SearchStatus.searching
                              ? 'Games searching on network'
                              : state.searchStatus == SearchStatus.init
                              ? 'Press Scan Games for search games on your network'
                              : state.games.isEmpty
                              ? 'Any game could not found on network'
                              : 'Games on your network'
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: state.searchStatus != SearchStatus.searching ? ListView.builder(
                    itemBuilder: (_, index) {
                      return _gameOnTheNetworkElement(context, state.games[index]);
                    },
                    itemCount: state.games.length,
                  ) : CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _gameOnTheNetworkElement(BuildContext context, GameSearchInformation data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, screenGuestGame, arguments: [
          data.addressAndPort.address,
          data.addressAndPort.port,
        ]);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: data.ableToConnect
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          data.name,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        ),
      ),
    );
  }

  Widget _joinGameCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _hostTextController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'IP address',
                    labelText: 'IP address',
                    prefixIcon: Icon(Icons.support),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(999), right: Radius.zero),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4,),
              const Text(':'),
              const SizedBox(width: 4,),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _portTextController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'port number',
                    labelText: 'port number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(999), left: Radius.zero),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12,),
          ElevatedButton(
            onPressed: () {
              final String host = _hostTextController.text;
              final int port = int.tryParse(_portTextController.text) ?? 0;
              print('port input is $port');
              StorageManager().setLastConnectedHost(host);
              StorageManager().setLastConnectedPort(port);
              Navigator.pushNamed(context, screenGuestGame, arguments: [host, port]);
            },
            child: Text(
              'Join',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12,),
        ],
      ),
    );
  }
}