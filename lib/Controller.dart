import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:appui/Configure.dart';
import 'package:appui/AutoDriving.dart';

void main() {
  runApp(const JoystickExampleApp());
}

const ballSize = 20.0;
const step = 10.0;

class JoystickExampleApp extends StatelessWidget {
  const JoystickExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Force Landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return MaterialApp(
      home: Scaffold(
        body: const TwoJoystickAreaExample(),
      ),
    );
  }
}


class TwoJoystickAreaExample extends StatefulWidget {
  const TwoJoystickAreaExample({Key? key}) : super(key: key);

  @override
  _TwoJoystickAreaExampleState createState() => _TwoJoystickAreaExampleState();
}

class _TwoJoystickAreaExampleState extends State<TwoJoystickAreaExample> {
  String? _streetColor = null;
  String? _lineColor = null;
  String? _busStopLineColor = null;
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xAF24BEA5),
        title: const Text(''),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Settings'), value: 1),
              PopupMenuItem(child: Text('Automatic driving'), value: 2),
              PopupMenuItem(child: Text('Convoy'), value: 3),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Configure()));
              } else if (value == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AutoDriving()));
              } else {
                print("To be continued");
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Row( // use a Row widget to divide the screen into two parts
          children: [
            Expanded( // use an Expanded widget to fill the available space
              child: JoystickArea(
                mode: JoystickMode.all, // set the mode to vertical so that the joystick can only move up and down
                initialJoystickAlignment: const Alignment(-0.8, 0.4), // set the initial alignment of the joystick to the bottom left corner
                listener: (details) {
                  setState(() {
                    // adjust the y value according to the left joystick
                    _x = max(0, min(_x + step * details.x * cos(pi / 4), MediaQuery.of(context).size.width));
                  });
                },
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            Expanded( // use another Expanded widget to fill the remaining space
              child: JoystickArea( // use another JoystickArea widget for the right part of the screen
                mode: JoystickMode.horizontal, // set the mode to horizontal so that the joystick can only move left and right
                initialJoystickAlignment: const Alignment(0.8, 0.4), // set the initial alignment of the joystick to the bottom right corner
                listener: (details) {
                  setState(() {
                    // adjust the x value according to the right joystick
                    _y = max(0, min(_y + step * details.y * sin(pi / 4), MediaQuery.of(context).size.height));
                  });
                },
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {Key? key, required this.mode, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: FittedBox(
          child: DropdownButton(
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                  child: Text('All Directions'), value: JoystickMode.all),
              DropdownMenuItem(
                  child: Text('Vertical And Horizontal'),
                  value: JoystickMode.horizontalAndVertical),
              DropdownMenuItem(
                  child: Text('Horizontal'), value: JoystickMode.horizontal),
              DropdownMenuItem(
                  child: Text('Vertical'), value: JoystickMode.vertical),
            ],
          ),
        ),
      ),
    );
  }
}

