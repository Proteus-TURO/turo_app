import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TURO Controller',
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TURO Controller'),
        leading: Icon(Icons.menu),
      ),
      backgroundColor: Colors.black26,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Image.asset(
              'assets/ProteusLogo.png',
              width: 170,
              height: 170,
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectWlan()));
              },
              child: Text('Verbinden'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF42BEA5)),
                minimumSize: MaterialStateProperty.all(Size(200, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectWlan extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class Configure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: const Alignment(0, 0,
        ),
        children: [
          Positioned(
            top: 600.5,
            left: 150.5,
            width: 109,
            height: 43,
            child: ElevatedButton(
              onPressed: () {
                context;
                    (context) {
                  return ConnectWlan();
                };
              },
              child:
              Text(
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
            width: 415,
            height: 290,
            child: Image(
              image: const AssetImage(
                'assets/ProteusBack.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 300,
            left: 30,
            width: 350,
            height: 200,
            child: TextField(
            controller : TextEditingController(),
            onSubmitted : (value) {
              print('The text is $value');
            },
              decoration: InputDecoration(
                hintText: 'Street color', // The passive text to show
              ),
          ),
          ),
          Positioned(
            top: 400,
            left: 30,
            width: 350,
            height: 200,
            child: TextField(
              controller : TextEditingController(),
              onSubmitted : (value) {
                print('The text is $value');
              },
              decoration: InputDecoration(
                hintText: 'Line color', // The passive text to show
              ),
            ),
          ),
          Positioned(
            top: 500,
            left: 30,
            width: 350,
            height: 200,
            child: TextField(
              controller : TextEditingController(),
              onSubmitted : (value) {
                print('The text is $value');
              },
              decoration: InputDecoration(
                hintText: 'Bus stop line color', // The passive text to show
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(
        0xFF42BEA5,
      ),
    );
  }
}


class _MyAppState extends State<ConnectWlan> {

  List<WifiNetwork> _wifiList = [];

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: const Alignment(0, 0,
        ),
        children: <Widget> [
          ElevatedButton(
            child: Text('Get List of Wifi'),
            onPressed: () async {
              getWifiList();
            },
          ),
          Expanded(
            child: ListView.separated(
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
            top: 600.5,
            left: 150.5,
            width: 109,
            height: 43,
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
            width: 415,
            height: 290,
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




/*
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wifi IoT plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text('Get List of Wifi'),
                onPressed: () async {
                  getWifiList();
                },
              ),
              Expanded(
                child: ListView.separated(
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
            ],
          ),
        ),
      ),
    );
  }
* */