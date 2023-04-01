import 'dart:ffi';

import 'package:appui/WlanConnect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appui/Configure.dart';
import 'package:appui/AutoDriving.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turo_core/turo_core.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(const JoystickView());
}

const ballSize = 20.0;
const step = 10.0;

Future<Map<String, dynamic>> bridge() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  return json.decode(jsonString);
}

class JoystickView extends StatelessWidget {
  const JoystickView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: TwoJoystick(),
      ),
    );
  }
}

class TwoJoystick extends StatefulWidget {
  const TwoJoystick({Key? key}) : super(key: key);

  @override
  _TwoJoystickState createState() => _TwoJoystickState();
}

class _TwoJoystickState extends State<TwoJoystick> {
  @override
  void initState() {
    super.initState();
    // Force Landscape mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    super.dispose();
    // Release Landscape mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  double _x = 100;
  double _y = 100;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final result = bridge();
    //Map<String, dynamic> data = await loadAsset();
    //final ros = RosBridge(result['ip'], result['bridgePort']);
    //final ros = RosBridge('10.10.30.59', 8080);

    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xAF24BEA5),
          title: const Text(''),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 1, child: Text('Settings')),
                const PopupMenuItem(value: 2, child: Text('Automatic driving')),
                const PopupMenuItem(value: 3, child: Text('Wlan')),
                const PopupMenuItem(value: 4, child: Text('Convoy')),
              ],
              onSelected: (value) {
                if (value == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Configure()));
                } else if (value == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AutoDriving()));
                } else if (value == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConnectWlan()));
                } else {
                  print("To be continued");
                }
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? ip = snapshot.data?.getString("ip");
              int? bridgePort = snapshot.data?.getInt("bridgePort");
              int? videoStreamPort = snapshot.data?.getInt("videoStreamPort");

              if (ip == null || bridgePort == null || videoStreamPort == null) {
                return const CircularProgressIndicator();
              }

              return SafeArea(
                child: Row(
                  // use a Row widget to divide the screen into two parts
                  children: [
                    Expanded(
                      // use an Expanded widget to fill the available space
                      child: JoystickArea(
                        mode: JoystickMode
                            .all, // set the mode to all so that the joystick can move in every direction
                        initialJoystickAlignment: const Alignment(-0.8,
                            0.4), // set the initial alignment of the joystick to the bottom left corner
                        listener: (details) {
                          setState(() {
                            // adjust the y value according to the left joystick

                            _y = max(
                                0,
                                min(_y + step * details.y * sin(pi / 4),
                                    MediaQuery.of(context).size.height));
                            if (details.y < 0 &&
                                    details.y <= -0.75 &&
                                    details.x >= -0.75 ||
                                details.y < 0 &&
                                    details.y <= -0.75 &&
                                    details.x <= 0.75) {
                              /// move forward
                              /// TODO: Send the car a message, to move forward
                              //ros.setVelocity(-details.y, 0, 0);
                              print('-----------------------${-details.y}');
                            } else if (details.x < 0 &&
                                    details.y <= 0 &&
                                    details.x >= -0.75 ||
                                details.y < 0 &&
                                    details.y <= -0.75 &&
                                    details.x <= 0.75) {
                              /// move left
                              /// TODO: Send the car a message, to move left
                              //ros.setVelocity(0, -details.x, 0);
                              print('+++++++++++++++++++++++${-details.x}');
                            } else if (details.y > 0 &&
                                details.x >= -0.75 &&
                                details.x < 0) {
                              /// move back
                              /// TODO: Send the car a message, to move back
                              //ros.setVelocity(-details.y, 0, 0);
                              print('//////////////////////${-details.y}');
                            } else if (details.x > 0) {
                              /// move right
                              /// TODO: Send the car a message, to move right
                              //ros.setVelocity(0, -details.x, 0);
                              print('§§§§§§§§§§§§§§§§§§§§§§§${-details.x}');
                            }
                            print(
                                'Left Joystick: y: ${details.y}, x: ${details.x}');
                          });
                        },
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    VideoStream(ip, videoStreamPort, 'video_feed',
                        '/camera/color/image_raw',
                        width: currentWidth / 2.2),
                    Expanded(
                      // use another Expanded widget to fill the remaining space
                      child: JoystickArea(
                        // use another JoystickArea widget for the right part of the screen
                        mode: JoystickMode
                            .horizontal, // set the mode to horizontal so that the joystick can only move left and right
                        initialJoystickAlignment: const Alignment(0.8,
                            0.4), // set the initial alignment of the joystick to the bottom right corner
                        listener: (details) {
                          setState(() {
                            // adjust the x value according to the right joystick

                            _x = max(
                                0,
                                min(_x + step * details.x * cos(pi / 4),
                                    MediaQuery.of(context).size.width));
                            if (_x < 0) {
                              /// turn left
                              /// TODO: Send the car a message, to turn left
                            } else if (_x > 0) {
                              /// turn right
                              /// TODO: Send the car a message, to turn right
                            }
                            print('Right Joystick ${details.x}');
                          });
                        },
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const CircularProgressIndicator();
          },
        ));
  }
}
