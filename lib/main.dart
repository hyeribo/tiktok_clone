import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';

void main() async {
  // 앱이 시작하기 전에 state를 어떤식으로든 바꾸고 싶다면
  // engine자체와 engine과 widget의 연결을 초기화 시켜야한다.
  // 아래 코드를 작성하면 모든 widget들이 engine과 연결된것을 보장해준다.
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로모드 고정
  ]);

  // status bar 색상 설정 (꼭 main 함수에서 실행시킬 필요는 없다.)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 화면에 debug 모드 배너 제거
      title: 'TikTok Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        splashColor: Colors.transparent, // 클릭시 애니메이션 색
        highlightColor: Colors.transparent, // 클릭 유지시 백그라운드 색
      ),
      home: const LayoutBuilderCodeLab(),
    );
  }
}

class LayoutBuilderCodeLab extends StatelessWidget {
  const LayoutBuilderCodeLab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        // constraints: BoxConstraints. box가 커질 수 있는 최대치 한계. Container가 커질 수 있는 최대 크기를 알려준다.
        // MediaQuery의 size와 constraints.maxWidth가 같아 보이는 이유는, LayoutBuilder를 Scaffold의 body로 그리고 있기 때문이다.
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.teal,
          child: Center(
            child: Text(
              "${size.width} / ${constraints.maxWidth}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 98,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
