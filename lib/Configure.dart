import 'package:flutter/material.dart';
import 'Controller.dart';
import 'package:flutter/services.dart';

class Configure extends StatefulWidget {
  const Configure({Key? key}) : super(key: key);

  @override
  _ConfigureState createState() => _ConfigureState();
}

class _ConfigureState extends State<Configure> {
  // Deklarieren Sie die Variablen als String?
  String? _streetColor;
  String? _lineColor;
  String? _busStopLineColor;

  @override
  void initState() {
  super.initState();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  // Initialisieren Sie die Variablen mit einem Standardwert oder null
  _streetColor = null;
  _lineColor = null;
  _busStopLineColor = null;
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Color(0xAF24BEA5),
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
      body: Stack(
        fit: StackFit.expand,
        alignment: const Alignment(0, 0,
        ),
        children: [
          Positioned(
            top: currentHeight - currentHeight / 1.55,
            width: currentWidth / 1.2,
            child: const Text(
              'Choose the line colors', // Der Text zum Anzeigen
              style: TextStyle(fontSize: 24), // Die Ausrichtung des Textes
              textAlign: TextAlign.center, // Die Ausrichtung des Textes
            ),
          ),
          Positioned(
            top: currentHeight - currentHeight / 3.5,
            left: currentWidth / 2 - currentWidth / 6,
            width: currentWidth / 3,
            height: currentHeight / 19,
            child: ElevatedButton(
              onPressed: _streetColor == null || _lineColor == null || _busStopLineColor == null ? null : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JoystickExampleApp()));
                  },
              child:
              Text(
                'Save',
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
          ),
          Positioned(
            top: currentHeight - currentHeight / 1.7,
            left: currentWidth / 2 - currentWidth / 3,
            child: DropdownButton<String>(
              value: _streetColor, // Der aktuell ausgewählte Wert
              items: <String>['Black', 'White', 'Green', 'Blue', 'Yellow', 'Red'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _streetColor = newValue; // Aktualisieren Sie den Wert bei Änderung
                });
              },
              hint: Text('Street'), // Der passive Text zum Anzeigen
            ),
          ),
          Positioned(
            top: currentHeight - currentHeight / 2,
            left: currentWidth / 2 - currentWidth / 3,
            child: DropdownButton<String>(
              value: _lineColor, // Der aktuell ausgewählte Wert
              items: <String>['Black', 'White', 'Green', 'Blue', 'Yellow', 'Red'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _lineColor = newValue; // Aktualisieren Sie den Wert bei Änderung
                });
              },
              hint: Text('Driving line'), // Der passive Text zum Anzeigen
            ),
          ),
          Positioned(
            top: currentHeight - currentHeight / 2.5,
            left: currentWidth / 2 - currentWidth / 3,
            child :DropdownButton<String>(
              value :_busStopLineColor,// Der aktuell ausgewählte Wert
              items :<String>['Black', 'White', 'Green', 'Blue', 'Yellow', 'Red'].map((String value) {
                return DropdownMenuItem<String>(
                  value :value ,
                  child :Text(value),
                );
              }).toList(),
              onChanged :(String? newValue) {
                setState(() {
                  _busStopLineColor = newValue; // Aktualisieren Sie den Wert bei Änderung
                });
              },
              hint :Text('Bus stop line'), // Der passive Text zum Anzeigen
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
