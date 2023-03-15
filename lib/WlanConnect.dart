import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'Configure.dart';
import 'package:flutter/services.dart';

class ConnectWlan extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ConnectWlan> {
  List<WifiNetwork> _wifiList = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    getWifiList();
  }

  Future<void> getWifiList() async {
    List<WifiNetwork> wifiList;
    try {
      wifiList = await WiFiForIoTPlugin.loadWifiList();
    } on Exception catch (e) {
      print(e.toString());
      wifiList = [];
    }

    if (!mounted) return;

    setState(() {
      _wifiList = wifiList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: const Alignment(0, 0,
        ),
        children: <Widget> [
          Positioned(
            top: currentHeight - currentHeight / 4,
            left: currentWidth / 2 - currentWidth / 6,
            width: currentWidth / 3,
            height: currentHeight / 19,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: Text('Refresh'),
              onPressed: () async {
                getWifiList();
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(top: currentHeight / 2.8),
              separatorBuilder: (context, index) => Divider(),
              itemCount: _wifiList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_wifiList[index].ssid.toString()),
                trailing:
                Text('${_wifiList[index].level} ${_wifiList[index].frequency}'),
                onTap: () async {
                  // connect to wifi network
                  bool result = await WiFiForIoTPlugin.connect(_wifiList[index].ssid.toString());
                  print(result ? 'connected' : 'connection failed');
                },
              ),
            ),
          ),
          Positioned(
            top: currentHeight - currentHeight / 8,
            left: currentWidth / 2 - currentWidth / 6,
            width: currentWidth / 3,
            height: currentHeight / 19,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Configure()));
              },
              child: Text(
                'Connect',
                style: TextStyle(
                  shadows: [],
                  color: const Color(
                    0xFFFFFFFF,
                  ),
                  backgroundColor: const Color(
                    0,
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            width: currentWidth,
            height: currentHeight / 3,
            child: Image(
              image: const AssetImage(
                'assets/ProteusBack.png',
              ),
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      backgroundColor: const Color(
        0xFF42BEA5,
      ),
    );
  }
}