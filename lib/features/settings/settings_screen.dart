import 'package:flutter/material.dart';

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
    return Scaffold(
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
              print(date);

              final time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              print(time);

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
              print(booking);
            },
            title: const Text("What is your birthday?"),
            subtitle: const Text("I need to know!"),
          ),
          const AboutListTile(
              applicationVersion: "1.0",
              applicationLegalese:
                  "All rights reserved. Please don't copy me."),
        ],
      ),
    );
  }
}
