import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;


  // 각 하단 탭에 들어갈 위젯 리스트
  final List<Widget> _pages = [
    const _DiscoverTab(),
    const _ChatTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFFF4D6D),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_solid),
            label: '발견',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            activeIcon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_solid),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}

// 임시 탭 컨텐츠 위젯들 (나중에 별도 파일로 분리 예정)

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSUM', style: TextStyle(color: Color(0xFFFF4D6D), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.person_2_alt, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              '주변의 새로운 인연을 찾는 중...',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메시지', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.chat_bubble_text, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              '아직 대화 내역이 없습니다.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: Icon(CupertinoIcons.person_solid, size: 50, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? '로그인 정보 없음',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          ListTile(
            leading: const Icon(CupertinoIcons.arrow_right_square),
            title: const Text('로그아웃'),
            onTap: () async {
              await authService.signOut();
              // authStateChanges로 인해 자동으로 LoginScreen으로 튕김
            },
          ),
        ],
      ),
    );
  }
}
