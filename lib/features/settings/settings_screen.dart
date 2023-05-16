import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: const [
          CupertinoActivityIndicator(
            radius: 40,
          ), // iOS 모양 로딩
          CircularProgressIndicator(), // Android 모양 로딩
          CircularProgressIndicator
              .adaptive(), // 유저가 어떤 플랫폼에 있는지 확인하고 플랫폼에 따라 다른걸 보여줌
        ],
      ),
    );
  }
}
