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
  // MethodChannel for communication with the native side
  final _batteryChannel = MethodChannel('battery');
  double? batteryPercentage; // Variable to hold the battery percentage

  @override
  void initState() {
    super.initState();
    // Method call handler for receiving battery percentage from native code
    _batteryChannel.setMethodCallHandler((call) async {
      if (call.method == "batteryPercentage") {
        // When a battery percentage is received, update the UI
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
              width: 300, // Set your desired width
              height: 200, // Set your desired height
              child: UiKitView(
                viewType:
                    'BatteryView', // The viewType should correspond to the one used in the native code
              ),
            ),
            if (batteryPercentage != null) ...[
              // Display the battery percentage when it's available
              SizedBox(height: 20), // For spacing
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
