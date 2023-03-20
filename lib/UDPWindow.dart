import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Controller.dart';
import 'test.dart';

class UDPWindow extends StatefulWidget {
  @override
  _UDPWindowState createState() => _UDPWindowState();
}

class _UDPWindowState extends State<UDPWindow> {

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
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: currentHeight / 4),
            Image.asset(
              'assets/ProteusLogo.png',
              width: currentWidth / 2,
              height: currentHeight / 4,
            ),
            SizedBox(height: currentHeight / 5),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JoystickExampleApp()));
              },
              child: Text('Start driving'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF42BEA5)),
                minimumSize: MaterialStateProperty.all(Size(currentWidth / 2, currentHeight / 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}