import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그인 기능
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      // 에러 처리는 UI에서 수행하거나 여기서 기본 처리를 합니다.
      throw Exception(e.message);
    }
  }

  // 회원가입 기능 (Firebase 인증 + 백엔드 DB 저장)
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
         await _createBackendProfile(credential.user!);
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // 백엔드 파스그레스 DB 연동
  Future<void> _createBackendProfile(User user) async {
    // 안드로이드 에뮬레이터에서 로컬 호스트 접근 시 10.0.2.2 사용
    // iOS 시뮬레이터 또는 데스크탑에서는 localhost 사용
    String host = 'localhost';
    if (Platform.isAndroid) {
      host = '10.0.2.2';
    }
    final backendUrl = 'http://$host:3000/users/profile'; 

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': user.uid,
          'email': user.email,
        }),
      );

      if (response.statusCode != 201) {
         // 백엔드 에러 처리를 세밀하게 하려면 이곳을 수정
         throw Exception('백엔드 DB 등록 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 파이어베이스 가입은 성공했으나, 백엔드 서버가 죽어있는 등 연결이 안되는 케이스
      print('Backend profile creation error: $e');
      throw Exception('서버 연결 문제로 프로필 생성을 완료하지 못했습니다.');
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 현재 로그인한 사용자 정보 얻기
  User? get currentUser => _auth.currentUser;
}
