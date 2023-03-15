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
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Color(0xFF24BEA5),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Settings'), value: 1),
              PopupMenuItem(child: Text('Normal driving'), value: 2),
              PopupMenuItem(child: Text('Convoy'), value: 3),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Configure()));
              } else if (value == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JoystickExampleApp()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectWlan()));
              },
              child: Text('S T O P'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}