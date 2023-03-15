import 'package:flutter/material.dart';
import 'WlanConnect.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectWlan()));
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