import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) {
      return;
    }
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale("es"),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            SwitchListTile.adaptive(
              title: const Text("Enable Notifications"),
              subtitle: const Text("They will be cute."),
              value: _notifications,
              onChanged: _onNotificationsChanged,
            ),
            CheckboxListTile(
              title: const Text("Marketing Emails"),
              subtitle: const Text("We won't spam you."),
              value: _notifications,
              onChanged: _onNotificationsChanged,
            ),
            ListTile(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                );
                if (kDebugMode) {
                  print(date);
                }

                // await 안에서 context를 사용하려면 mounted 여부를 체크해줘야 한다.
                if (!mounted) return;
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (kDebugMode) {
                  print(time);
                }

                if (!mounted) return;
                final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    // appBar의 색깔때문에 상단헤더가 보이지 않아서, builder를 통해 wrapper 모양을 바꿔준다.
                    return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black),
                      ),
                      child: child!,
                    );
                  },
                );
                if (kDebugMode) {
                  print(booking);
                }
              },
              title: const Text("What is your birthday?"),
              subtitle: const Text("I need to know!"),
            ),
            ListTile(
              // iOS 버전 로그아웃
              title: const Text(
                "Log out (iOS)",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Modal과 Dialog의 차이점 : 겉 배경을 클릭했을때 사라지는지 안사라지는지. Modal은 사라짐.
                // 유저가 버튼을 반드시 클릭하길 원하면 Dialog(CupertinoAlertDialog), 아니면 Modal(showCupertinoModalPopup) 사용
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("Please don't go"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              // Android 버전 로그아웃
              title: const Text(
                "Log out (Android)",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const FaIcon(
                        FontAwesomeIcons.skull), // Android는 아이콘 추가 가능
                    title: const Text("Are you sure?"),
                    content: const Text("Please don't go"),
                    actions: [
                      // 아무거나 넣어주면 됨
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const FaIcon(FontAwesomeIcons.check),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              // Android 버전 로그아웃
              title: const Text(
                "Log out (iOS / Android)",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    // 밖을 누르면 사라짐
                    title: const Text("Are you sure?"),
                    message: const Text("Please don't go"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("No"),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(context).pop(),
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
            const AboutListTile(
                applicationVersion: "1.0",
                applicationLegalese:
                    "All rights reserved. Please don't copy me."),
          ],
        ),
      ),
    );
  }
}
