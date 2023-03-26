import 'dart:convert';
import 'dart:io';

void main() {
  final test = 8080;
  final data = {
    'ip': '10.10.30.59',
    'bridgePort': test,
    'name': 'TURO',
  };

  final file = File('assets/data.json');
  file.writeAsStringSync(json.encode(data));

  final jsonString = file.readAsStringSync();
  final result = json.decode(jsonString);

  /*
  print(result['ip']);
  print(result['bridgePort']);
  print(result['name']);
   */

  read();
}



void read() {
  final file = File('assets/data.json');
  final jsonString = file.readAsStringSync();

  final result = json.decode(jsonString);

  print(result['ip']);
  print(result['bridgePort']);
  print(result['name']);
}