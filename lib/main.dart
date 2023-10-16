import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BatteryScreen(),
    );
  }
}

class BatteryScreen extends StatefulWidget {
  @override
  _BatteryScreenState createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final _batteryChannel = MethodChannel('battery');
  double? batteryPercentage; 

  @override
  void initState() {
    super.initState();
    _batteryChannel.setMethodCallHandler((call) async {
      if (call.method == "batteryPercentage") {
        setState(() {
          batteryPercentage = call.arguments as double;
        });
      }
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300, 
              height: 200, 
              child: UiKitView(
                viewType:
                    'BatteryView', 
              ),
            ),
            if (batteryPercentage != null) ...[
              SizedBox(height: 20), 
              Text(
                "Battery Percentage: $batteryPercentage%",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
