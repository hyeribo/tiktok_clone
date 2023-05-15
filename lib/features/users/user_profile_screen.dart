import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          stretch: true,
          pinned: true,
          // title: const Text('User Profile'),
          backgroundColor: Colors.teal,
          elevation: 1,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              "assets/images/placeholder.jpeg",
              fit: BoxFit.cover,
            ),
            title: const Text('User Profile'),
            stretchModes: const [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
            ],
          ),
        ),
      ],
    );
  }
}
