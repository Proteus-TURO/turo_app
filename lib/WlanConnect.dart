import 'package:appui/Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'Configure.dart';

/// Example app for wifi_scan plugin.
class ConnectWlan extends StatefulWidget {
  /// Default constructor for [MyApp] widget.
  const ConnectWlan({Key? key}) : super(key: key);

  @override
  State<ConnectWlan> createState() => _MyAppState();
}

class _MyAppState extends State<ConnectWlan> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

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

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return MaterialApp(
      home: Scaffold(
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
                  if (kDebugMode) {
                    print("To be continued");
                  }
                }
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: currentHeight / 3,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        width: currentWidth,
                        height: currentHeight / 3,
                        child: const Image(
                          image: AssetImage(
                            'assets/ProteusBack.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      icon: const Icon(Icons.account_tree_sharp),
                      label: const Text('CONNECT'),
                      onPressed: () async => Navigator.push(context, MaterialPageRoute(builder: (context) => const JoystickView())),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('LOAD'),
                      onPressed: () async => _getScannedResults(context),
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: Center(
                    child: accessPoints.isEmpty
                        ? const Text("NO SCANNED RESULTS")
                        : ListView.builder(
                        itemCount: accessPoints.length,
                        itemBuilder: (context, i) =>
                            _AccessPointTile(accessPoint: accessPoints[i])),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color(
          0xFF42BEA5,
        ),
      ),
    );
  }
}

/// Show tile for AccessPoint.
///
/// Can see details when tapped.
class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value.toString()))
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(accessPoint.capabilities),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfo("BSSDI", accessPoint.bssid),
              _buildInfo("Capability", accessPoint.capabilities),
              _buildInfo("frequency", "${accessPoint.frequency}MHz"),
              _buildInfo("level", accessPoint.level),
              _buildInfo("standard", accessPoint.standard),
              _buildInfo(
                  "centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
              _buildInfo(
                  "centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
              _buildInfo("channelWidth", accessPoint.channelWidth),
              _buildInfo("isPasspoint", accessPoint.isPasspoint),
              _buildInfo(
                  "operatorFriendlyName", accessPoint.operatorFriendlyName),
              _buildInfo("venueName", accessPoint.venueName),
              _buildInfo("is80211mcResponder", accessPoint.is80211mcResponder),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}