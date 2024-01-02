// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import '../user/nampage.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode((SystemUiMode.immersive));

//     // Future.delayed(const Duration(seconds: 2), () {
//     //   Navigator.of(context).pushReplacement(MaterialPageRoute(
//     //     builder: (_) => const Main(),
//     //   ));
//     // });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xffFEFFFF),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child:
//             // Column(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Image.asset(
//             //       'assets/images/splash_logo.png',
//             //       width: 70,
//             //     ),
//             //   ],
//             // ),
//             AnimatedSplashScreen(
//           splash: Transform.scale(
//             scale: 3, // 이미지 크기를 조절하려면 이 값을 조절합니다. 1.5는 이미지를 1.5배 확대합니다.
//             child: Image.asset('Assets/Image/logo.png'),
//           ),
//           nextScreen: const NamPage(),
//           splashTransition: SplashTransition.fadeTransition,
//         ),
//       ),
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: const Text(
//           'ⓒ 씅쑤신다. SSAFY',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const Main());
// }

// class Main extends StatelessWidget {
//   const Main({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color.fromARGB(255, 255, 255, 255)),
//         useMaterial3: true,
//       ),
//       home: AnimatedSplashScreen(
//         splash: Transform.scale(
//           scale: 3, // 이미지 크기를 조절하려면 이 값을 조절합니다. 1.5는 이미지를 1.5배 확대합니다.
//           child: Image.asset('Assets/Image/logo.png'),
//         ),
//         nextScreen: const NamPage(),
//         splashTransition: SplashTransition.fadeTransition,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import '../user/nampage.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: Splash(),
//   ));
// }

// class Splash extends StatelessWidget {
//   const Splash({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xffFEFFFF),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: AnimatedSplashScreen(
//           splash: Transform.scale(
//             scale: 3, // 이미지 크기를 조절
//             child: Image.asset('Assets/Image/logo.png'),
//           ),
//           nextScreen: const NamPage(),
//           splashTransition: SplashTransition.fadeTransition,
//         ),
//       ),
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: const Text(
//           'ⓒ 씅쑤신다. SSAFY',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../main.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode((SystemUiMode.immersive));

//     Future.delayed(const Duration(seconds: 4), () {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (_) => const Main(),
//       ));
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xffFEFFFF),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'Assets/Image/logo.png',
//               width: 300,
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: const Text(
//           'ⓒ 씅쑤신다. SSAFY',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../main.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode((SystemUiMode.immersive));

//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (_) => const Main(),
//       ));
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Color(0xffFEFFFF),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'Assets/Image/logo.png',
//               width: 300,
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
//         child: Text(
//           'ⓒ  씅쑤신다. SSAFY',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart';
import '../store/userstore.dart';
import '../user/login.dart';
import '../user/pageapi.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage(); // FlutterSecureStorage 인스턴스 생성
  final PageApi pageapi = PageApi();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), () async {
      final userToken = await storage.read(key: "login");
      if (userToken != null) {
        final response =
            await pageapi.tokenValidation(userToken.toString().split(" ")[1]);
        if (response == 'success') {
          // 토큰이 유효한 경우 메인 페이지로 이동
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const Main(),
          ));
        } else {
          // 토큰이 유효하지 않은 경우 처리
          await storage.delete(key: "login");
          await context.read<UserStore>().changeAccessToken('');

          setState(() {});
        }
      } else {
        // 토큰이 없는 경우 로그인 페이지로 이동
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => LogIn(),
        ));
        // Navigator.of(context).pushReplacementAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (_) => LogIn(storage: storage), // 이동할 새로운 페이지
        //   ),
        //   (route) => false, // 모든 이전 페이지를 제거하려면 false를 반환
        // );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffFEFFFF),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/Image/logo.png',
              width: 300,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
        child: Text(
          'ⓒ  씅쑤신다. SSAFY',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
