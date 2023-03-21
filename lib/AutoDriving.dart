import 'package:appui/Controller.dart';
import 'package:flutter/material.dart';
import 'WlanConnect.dart';
import 'package:flutter/services.dart';
import 'package:appui/Configure.dart';

class AutoDriving extends StatefulWidget {
  @override
  _AutoDrivingState createState() => _AutoDrivingState();
}

class _AutoDrivingState extends State<AutoDriving> {

  @override
  void initState() {
    super.initState();
    // Set the portrait mode here
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    // Release the portrait mode here
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    // Force Protrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(''),
        backgroundColor: const Color(0xAF24BEA5),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('Settings')),
              const PopupMenuItem(value: 2, child: Text('Normal driving')),
              const PopupMenuItem(value: 3, child: Text('Wlan')),
              const PopupMenuItem(value: 4, child: Text('Convoy')),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Configure()));
              } else if (value == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const JoystickView()));
              } else if (value == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectWlan()));
              } else {
                print("To be continued");
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: currentHeight / 5),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectWlan()));
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                fixedSize: Size(currentWidth / 2, currentWidth / 2),
                textStyle: const TextStyle(fontSize: 30),
              ),
              child: const Text('S T O P'),
            ),
          ],
        ),
      ),
    );
  }
}