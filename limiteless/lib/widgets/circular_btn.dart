import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class CircularBtn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CircularBtn();
  CircularBtn({Key key, this.state}) : super(key: key);
  String state;
}

class _CircularBtn extends State<CircularBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        child: RaisedButton(
          color: Colors.orange,
          shape: RoundedRectangleBorder(
              // set the value to a very big number like 100, 1000...
              borderRadius: BorderRadius.circular(100)),
          child: Text('Safe Place'),
          onPressed: _changePlace,
        ));
  }

  _changePlace() {
    
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        print('Please turn on bluetooth');
      } else if (state == BluetoothState.on) {
        flutterBlue.startScan(timeout: Duration(seconds: 4));

        var subscription = flutterBlue.scanResults.listen((results) {
          for (ScanResult r in results) {
            int distance = 10 ^ ((-69 - r.rssi)/20).toInt();
            print('${r.device.name} found! rssi: ${r.rssi} distance: ${distance}');
          }
        });
        flutterBlue.stopScan();
      }
    });
    
  }
}
