import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turo_core/turo_core.dart';
import 'Controller.dart';

Future<void> selectCar(BuildContext context, HeloTuroData car) async {
  var pref = await SharedPreferences.getInstance();
  await pref.setString("ip", car.ip);
  await pref.setString("name", car.name);
  await pref.setInt("bridgePort", car.bridgePort);
  await pref.setInt("videoStreamPort", car.videStreamPort);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const JoystickView()));
}

class UDPWindow extends StatelessWidget {
  const UDPWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Turo',
      home: UDP(title: 'Turo'),
    );
  }
}

class UDP extends StatefulWidget {
  const UDP({super.key, required this.title});
  final String title;

  @override
  State<UDP> createState() => _UDPState();
}

class _UDPState extends State<UDP> {
  @override
  void initState() {
    super.initState();
    // Set the portrait mode here
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    super.dispose();
    // Release the portrait mode here
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xAF24BEA5),
      ),
      backgroundColor: const Color(0xFF24BEA5),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: currentWidth,
              height: currentHeight / 3,
              child: const Image(
                image: AssetImage(
                  'assets/ProteusBack.png',
                ),
              ),
            ),
            const Expanded(
              child: HeloTuroReceiver(selectCar),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoystickView()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                minimumSize: MaterialStateProperty.all(
                    Size(currentWidth / 2, currentHeight / 17)),
              ),
              child: const Text('Start driving'),
            ),
            Padding(padding: EdgeInsets.only(bottom: currentHeight / 30))
          ],
        ),
      ),
    );
  }
}
