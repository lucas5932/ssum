import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSUM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF4D6D)),
        useMaterial3: true,
        fontFamily: 'Roboto', // Replace with a more premium font if needed
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Firebase 연결/초기화 중일 때 로딩 표시
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF4D6D)),
              ),
            );
          }
          // 유저 데이터가 들어왔다는 건 이미 로그인이 유효하다는 뜻
          if (snapshot.hasData) {
            return const MainScreen();
          }
          // 유저 데이터가 없으면 로그인 화면으로 분기
          return const LoginScreen();
        },
      ),
    );
  }
}
