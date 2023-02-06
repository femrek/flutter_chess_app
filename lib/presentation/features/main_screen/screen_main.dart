import 'package:flutter/material.dart';
import 'package:localchess/data/storage_manager.dart';
import 'package:localchess/routes.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _portTextController = TextEditingController();

  Future setFieldsValues() async {
    _hostTextController.text = await StorageManager().lastConnectedHost;
    _portTextController.text = (await StorageManager().lastConnectedPort)?.toString() ?? '';
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
            _joinGameCard(context)
          ],
        ),
      ),
    );
  }

  Widget _mainScreenButton(BuildContext context, String content, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration( 
          color: Theme.of(context).primaryColor,
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