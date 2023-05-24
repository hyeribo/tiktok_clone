import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';

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
      // flutter는 텍스트가 기본적으로 들어있는 위젯이 있다. (예: licenses)
      // 이런 위젯들은 이미 번역이 되어있으므로 include 시킨다.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // IANA language registry 에서 Subtag 국가 코드 보기
      supportedLocales: const [
        Locale("en"),
        Locale("ko"),
        Locale("es"),
      ],
      themeMode: ThemeMode
          .system, // light or dark: 사용자의 핸드폰 설정에 관계없이 모드 강제. system: 사용자의 핸드폰 설정에 맞춤
      theme: ThemeData(
        useMaterial3: true,
        textTheme: Typography.blackMountainView,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: Colors.black,
        ),
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        splashColor: Colors.transparent, // 클릭시 애니메이션 색
        highlightColor: Colors.transparent, // 클릭 유지시 백그라운드 색
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade700,
          indicatorColor: Colors.white,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        textTheme: Typography.whiteMountainView,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        primaryColor: const Color(0xFFE9435A),
      ),
      home: const SettingsScreen(),
    );
  }
}
