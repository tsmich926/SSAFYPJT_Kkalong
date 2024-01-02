import 'package:flutter_mycloset/pages/swipe.dart';
import 'package:provider/provider.dart';
import 'store/userstore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../user/pageapi.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mycloset/avata/choicepicture.dart';
import './reafeat/splash.dart';
import '../user/login.dart';
import '../user/mypage.dart';
import './reafeat/bottom.dart';
import './closet/closetdetail.dart';
import './closet/mycloset.dart';
import './category/category.dart';
import './user/pageapi.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Pretendard",
        ),
        home: const Splash(),
      ),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // static String? userToken; //user의 정보를 저장하기 위한 변수;
  // static final storage = FlutterSecureStorage();
  final PageApi pageapi = PageApi();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await _asyncMethod();
      setState(() {});
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 136, 126, 136),
          content: Text('한번 더 뒤로가기를 누를 시 종료됩니다'),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    // SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await onWillPop(); // 기존 onWillPop 함수 호출
      },
      child: DefaultTabController(
        initialIndex: 1,
        length: 5,
        child: Scaffold(
          body: SafeArea(
            child: TabBarView(
              children: const [
                ChoicePicture(),
                MyCloset(),
                CategoryPage(),
                Swipe(),
                MyPage(),
                // userToken == null
                //     ? LogIn(storage: storage)
                //     : MyPage(storage: storage)
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }
}
