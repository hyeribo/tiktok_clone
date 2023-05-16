import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            // showAboutDialog: 이미 존재하는 함수.
            // VIEW LICENSES를 클릭하면 현재 사용중인 모든 오픈소스 라이브러리 관련 라이센스의 정보가 나온다.
            // 어플을 출시할때 꼭 어플이 사용하는 오픈소스 라이센스를 고지해야한다. 이걸 전부 만들어줌.
            onTap: () => showAboutDialog(
                context: context,
                applicationVersion: "1.0",
                applicationLegalese:
                    "All rights reserved. Please don't copy me."),
            title: const Text(
              "About",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text("About this app..."),
          ),
          const AboutListTile(), // 위 ListTile의 간소화
        ],
      ),
    );
  }
}
