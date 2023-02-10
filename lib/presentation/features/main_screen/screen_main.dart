import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/game_search_information.dart';
import 'package:localchess/data/storage_manager.dart';
import 'package:localchess/presentation/features/main_screen/game_scan_cubit.dart';
import 'package:localchess/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _portTextController = TextEditingController();

  Future setFieldsValues() async {
    _hostTextController.text = await StorageManager().lastConnectedHost ?? '';
    _portTextController.text = (await StorageManager().lastConnectedPort).toString();
  }

  @override
  void initState() {
    super.initState();
    setFieldsValues();
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _mainScreenButton(context, 'Play two player', () {
              Navigator.pushNamed(context, screenLocalGame);
            },),
            _divider(context),
            _mainScreenButton(context, 'Create local network game', () {
              Navigator.pushNamed(context, screenHostGame);
            }),
            _divider(context),
            _joinGameCard(context),
            _divider(context),
            Expanded(child: _gameScanList(context)),
          ],
        ),
      ),
    );
  }

  Widget _gameScanList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
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
                  Container(
                    child: _mainScreenButton(
                      context,
                      state.searching ? 'searching' : 'Scan Games',
                      () {
                        context.read<GameScanCubit>().startScan();
                      },
                      !state.searching,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        state.searching
                          ? 'games searching on network'
                          : state.games.isEmpty
                            ? 'any game could not found on network'
                            : 'games on your network'
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: !state.searching ? ListView.builder(
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
        margin: const EdgeInsets.all(12),
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

  Widget _mainScreenButton(BuildContext context, String content, Function onPressed, [bool enabled = true]) {
    return GestureDetector(
      onTap: () {
        if (enabled) onPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration( 
          color: enabled ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 2,
      width: MediaQuery.of(context).size.width - 24,
      color: Theme.of(context).primaryColorLight,
    );
  }

  Widget _joinGameCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
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
          _mainScreenButton(context, 'Join local network game', () {
            final String host = _hostTextController.text;
            final int port = int.tryParse(_portTextController.text) ?? 0;
            print('port input is $port');
            StorageManager().setLastConnectedHost(host);
            StorageManager().setLastConnectedPort(port);
            Navigator.pushNamed(context, screenGuestGame, arguments: [host, port]);
          }),
        ],
      ),
    );
  }
}