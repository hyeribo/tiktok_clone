import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListWheelScrollView(
        // useMagnifier: true, // magnifier 옵션을 사용 여부
        // magnification: 1.5, // 1.5배 확대
        // diameterRatio: 1, // 곡률
        itemExtent: 200,
        children: [
          for (var x in [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                color: Colors.teal,
                alignment: Alignment.center,
                child: const Text(
                  "Pick me",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
