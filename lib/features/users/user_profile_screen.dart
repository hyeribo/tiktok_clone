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
          snap: true, // 스크롤을 올리는 순간 빠르게 appbar가 나타남
          floating: true, // 스크롤을 올리면 바로 appbar가 나타남
          pinned: true, // 스크롤을 내려도 flexibleSpace가 사라지지 않음
          stretch: true, // stretchMode를 사용하기 위해 true로 설정
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
              StretchMode.fadeTitle,
            ],
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.amber[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("item $index"),
              ),
            ),
          ),
          itemExtent: 100,
        ),
      ],
    );
  }
}
