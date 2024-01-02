// import 'package:flutter/material.dart';
// import '../user/signup.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// // 이 함수는 아이디와 비밀번호를 매개변수로 받아 백엔드 서버에 로그인 요청을 보냅니다.
// Future<void> login(
//     String id, String password, FlutterSecureStorage storage) async {
//   Dio dio = Dio();

//   // try {
//   //   final response = await dio.post(
//   //     'http://k9c105.p.ssafy.io:8761/api/member/login', // 로그인 API 엔드포인트로 변경해야 합니다.
//   //     data: {"memberId": id, "memberPw": password},
//   //   );

//   //   if (response.statusCode == 200) {
//   //     // 로그인 성공 시 처리, 예를 들면 토큰 저장
//   //     var token = response.data['accessToken'];
//   //     // 토큰을 안전하게 저장하기 위한 로직 추가 필요
//   //     print('로그인 성공ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ: $token');
//   //     // 로그인 성공 후 다른 페이지로 이동 또는 상태 업데이트
//   //   } else {
//   //     // 서버로부터 받은 에러 메시지 표시
//   //     print('로그인 실패ㅅㅅㅅㅅㅅㅅㅅㅅㅅ: ${response.data['resultMessage']}');
//   //   }
//   // } catch (e) {
//   //   // DioError 처리
//   //   print('디오에러');
//   // }
//   // try {
//   //   final response = await dio.post(
//   //     'http://k9c105.p.ssafy.io:8761/api/member/login', // 로그인 API 엔드포인트로 변경해야 합니다.
//   //     data: {"memberId": id, "memberPw": password},
//   //   );

//   //   if (response.statusCode == 200) {
//   //     // 로그인 성공 시 처리, 예를 들면 토큰 저장
//   //     var token = response.data['accessToken'];
//   //     // 토큰을 안전하게 저장하기 위한 로직 추가 필요
//   //     print('로그인 성공: $token');
//   //     // 로그인 성공 후 다른 페이지로 이동 또는 상태 업데이트
//   //   } else if (response.statusCode == 400) {
//   //     // Bad request 처리
//   //     print('잘못된 요청: ${response.data['resultMessage']}');
//   //     // 적절한 사용자 피드백을 제공하거나 로그인 페이지에 남아 있습니다.
//   //   } else {
//   //     // 다른 HTTP 에러 코드 처리
//   //     print('로그인 실패: HTTP 상태 코드 ${response.statusCode}');
//   //   }
//   // } catch (e) {
//   //   // DioError 처리
//   //   if (e is DioException) {
//   //     // Specific DioError handling
//   //     print('DioError: ${e.response?.data['resultMessage'] ?? e.message}');
//   //   } else {
//   //     // Generic error handling
//   //     print('Unexpected error');
//   //   }
//   // }

//   try {
//     final response = await dio.post(
//       'http://k9c105.p.ssafy.io:8761/api/member/login',
//       data: {"memberId": id, "memberPw": password},
//     );

//     if (response.statusCode == 200) {
//       var token = response.data['accessToken'];
//       // 토큰을 안전하게 저장
//       await storage.write(key: "token", value: token);
//       print('로그인 성공: $token');
//       // 저장된 토큰을 읽어옵니다.
//       String? storedToken = await storage.read(key: "token");
//       print('저장된 토큰: $storedToken');

//       // 여기에서 로그인 성공 후의 로직을 실행할 수 있습니다.
//       // 예를 들어 홈 화면으로 이동하거나 상태 관리 솔루션에 토큰을 저장할 수 있습니다.
//     } else if (response.statusCode == 400) {
//       // 잘못된 요청 처리
//       print('잘못된 요청: ${response.data['resultMessage']}');
//     } else {
//       // 다른 HTTP 에러 코드 처리
//       print('로그인 실패: HTTP 상태 코드 ${response.statusCode}');
//     }
//   } catch (e) {
//     if (e is DioError) {
//       print('DioError: ${e.response?.data['resultMessage'] ?? e.message}');
//     } else {
//       print('Unexpected error');
//     }
//   }
// }

// class LogIn extends StatefulWidget {
//   final String? token;
//   final FlutterSecureStorage storage;
//   // const LogIn({this.token, required this.storage, super.key});
//   const LogIn({this.token, required this.storage, super.key});
//   @override
//   State<LogIn> createState() => _LogInState();
// }

// class _LogInState extends State<LogIn> {
//   TextEditingController controller = TextEditingController();
//   TextEditingController controller2 = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//             title: const Text(
//               '로그인',
//               style: TextStyle(
//                   fontSize: 25,
//                   color: Color.fromARGB(255, 0, 0, 0),
//                   fontWeight: FontWeight.w700),
//             ),
//             elevation: 0.0,
//             backgroundColor: Colors.white,
//             centerTitle: true,
//             toolbarHeight: 65),
//         // email, password 입력하는 부분을 제외한 화면을 탭하면, 키보드 사라지게 GestureDetector 사용
//         body: Center(
//           child: SingleChildScrollView(
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             child: Column(
//               children: [
//                 Form(
//                     child: Theme(
//                   data: ThemeData(
//                       primaryColor: Colors.grey,
//                       // primaryColor: const Color.fromARGB(255, 242, 241, 241),
//                       inputDecorationTheme: const InputDecorationTheme(
//                           labelStyle:
//                               TextStyle(color: Colors.grey, fontSize: 16.0))),
//                   // TextStyle(
//                   //     color: Color.fromARGB(255, 242, 241, 241),
//                   //     fontSize: 16.0))),
//                   child: Container(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Builder(builder: (context) {
//                         return SizedBox(
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: 58,
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                                   child: TextField(
//                                     onChanged: (context) {},
//                                     style: const TextStyle(fontSize: 15),
//                                     controller: controller,
//                                     autofocus: true,
//                                     decoration: const InputDecoration(
//                                         contentPadding: EdgeInsets.symmetric(
//                                             vertical: 16.0, horizontal: 10.0),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 width: 1.5,
//                                                 color: Color(0xFFF5BEB5))),
//                                         prefixIconColor: Color(0xFFF5BEB5),
//                                         prefixIcon: Icon(
//                                           Icons.alternate_email_rounded,
//                                         ),
//                                         border: OutlineInputBorder(
//                                             borderSide: BorderSide()),
//                                         labelText: '아이디',
//                                         focusColor: Color(0xFFF5BEB5)),
//                                     keyboardType: TextInputType.text,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 58,
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                                   child: TextField(
//                                     controller: controller2,
//                                     decoration: const InputDecoration(
//                                         contentPadding: EdgeInsets.symmetric(
//                                             vertical: 16.0, horizontal: 10.0),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 width: 1.5,
//                                                 color: Color(0xFFF5BEB5))),
//                                         prefixIconColor: Color(0xFFF5BEB5),
//                                         prefixIcon:
//                                             Icon(Icons.vpn_key_outlined),
//                                         border: OutlineInputBorder(),
//                                         labelText: '비밀번호',
//                                         focusColor: Color(0xFFF5BEB5)),
//                                     keyboardType: TextInputType.visiblePassword,
//                                     obscureText: true, // 비밀번호 안보이도록 하는 것
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 60,
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                                   child: ButtonTheme(
//                                       child: TextButton(
//                                           onPressed: () async {
//                                             await login(
//                                                 controller.text,
//                                                 controller2.text,
//                                                 widget.storage);
//                                           },
//                                           style:
//                                               // const ButtonStyle(
//                                               //     backgroundColor:
//                                               //         MaterialStatePropertyAll(
//                                               //             Color(0xFFF5BEB5))),
//                                               OutlinedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       5.0), // 원하는 각진 정도로 설정
//                                             ),
//                                             backgroundColor:
//                                                 const Color(0xFFF5BEB5),
//                                           ),
//                                           child: const SizedBox(
//                                             height: 40,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                   '로그인',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ))),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const SignUp()), // SignUpPage는 회원가입 페이지의 위젯입니다.
//                                   );
//                                 },
//                                 child: Container(
//                                   margin:
//                                       const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                                   child: const Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text('아직 깔롱쟁이 회원이 아니라면?'),
//                                           Text(
//                                             '회원가입',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       })),
//                 )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void showSnackBar(BuildContext context, Text text) {
//   final snackBar =
//       SnackBar(content: text, backgroundColor: const Color(0xFFF5BEB5));

//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../user/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pageapi.dart';
import '../main.dart';
import '../store/userstore.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final PageApi pageapi = PageApi();
  static final storage = FlutterSecureStorage();

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              '로그인',
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w700),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            toolbarHeight: 65),
        // email, password 입력하는 부분을 제외한 화면을 탭하면, 키보드 사라지게 GestureDetector 사용
        body: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Form(
                    child: Theme(
                  data: ThemeData(
                      primaryColor: Colors.grey,
                      // primaryColor: const Color.fromARGB(255, 242, 241, 241),
                      inputDecorationTheme: const InputDecorationTheme(
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.0))),
                  // TextStyle(
                  //     color: Color.fromARGB(255, 242, 241, 241),
                  //     fontSize: 16.0))),
                  child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Builder(builder: (context) {
                        return SizedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 58,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: TextField(
                                    onChanged: (context) {},
                                    style: const TextStyle(fontSize: 15),
                                    controller: controller,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 10.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.5,
                                                color: Color(0xFFF5BEB5))),
                                        prefixIconColor: Color(0xFFF5BEB5),
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide()),
                                        labelText: '아이디',
                                        focusColor: Color(0xFFF5BEB5)),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 58,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: TextField(
                                    controller: controller2,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 10.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.5,
                                                color: Color(0xFFF5BEB5))),
                                        prefixIconColor: Color(0xFFF5BEB5),
                                        prefixIcon:
                                            Icon(Icons.vpn_key_outlined),
                                        border: OutlineInputBorder(),
                                        labelText: '비밀번호',
                                        focusColor: Color(0xFFF5BEB5)),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true, // 비밀번호 안보이도록 하는 것
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: ButtonTheme(
                                      child: TextButton(
                                          onPressed: () async {
                                            try {
                                              final response =
                                                  await pageapi.login(
                                                controller.text.toString(),
                                                controller2.text,
                                              );
                                              print(response['body']
                                                  ['accessToken']);
                                              if (response['body']
                                                      ['accessToken'] !=
                                                  null) {
                                                print(2);
                                                final accessToken =
                                                    await response['body']
                                                        ['accessToken'];
                                                final refreshToken =
                                                    response['body']
                                                        ["refreshToken"];
                                                await storage.write(
                                                    key: "login",
                                                    value:
                                                        "accessToken $accessToken refreshToken $refreshToken");

                                                print('여기는 로그인 버튼');
                                                await context
                                                    .read<UserStore>()
                                                    .changeAccessToken(
                                                        accessToken);
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           const Main()),
                                                // );
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Main(),
                                                  ),
                                                  (route) =>
                                                      false, // 모든 이전 페이지를 제거하려면 false를 반환
                                                );
                                              } else {
                                                //  showSnackBar(context,
                                                //     Text('로그인 실패'));
                                              }
                                            } catch (e) {
                                              print('로그인실패');
                                              // showSnackBar(context,
                                              //     Text('로그인 실패'));
                                            }

                                            // try {
                                            //   final response =
                                            //       await pageapi.login(
                                            //     controller.text.trim(),
                                            //     controller2.text.trim(),
                                            //   );

                                            //   final body = response['body'];

                                            //   final accessToken =
                                            //       body['accessToken'];
                                            //   if (accessToken != null) {
                                            //     print(
                                            //         'Access token is available.');

                                            //     final refreshToken =
                                            //         body['refreshToken'];

                                            //     await storage.write(
                                            //       key: "login",
                                            //       value:
                                            //           "accessToken $accessToken refreshToken $refreshToken",
                                            //     );

                                            //     print(
                                            //         'Here is the login button.');

                                            //     await context
                                            //         .read<UserStore>()
                                            //         .changeAccessToken(
                                            //             accessToken);

                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               const Main()),
                                            //     );
                                            //   } else {
                                            //     ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //       SnackBar(
                                            //           content: Text('로그인실패.')),
                                            //     );
                                            //   }
                                            // } on DioException catch (dioError) {
                                            //   String errorMessage =
                                            //       '로그인 중 문제가 발생했습니다.';
                                            //   if (dioError
                                            //           .response?.statusCode ==
                                            //       400) {
                                            //     errorMessage =
                                            //         '잘못된 아이디나 비밀번호입니다.';
                                            //   }
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     SnackBar(
                                            //         content:
                                            //             Text(errorMessage)),
                                            //   );
                                            // } catch (e) {
                                            //   // 그 외의 예외 처리
                                            //   print(
                                            //       'An unexpected error occurred: $e');
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     SnackBar(
                                            //         content: Text(
                                            //             '예기치 못한 에러가 발생하였습니다.')),
                                            //   );
                                            // }

                                            // try {
                                            //   final response =
                                            //       await pageapi.login(
                                            //     controller.text.trim(),
                                            //     controller2.text.trim(),
                                            //   );

                                            //   // 결과 코드 확인
                                            //   final resultCode =
                                            //       response['result']
                                            //           ['resultCode'];
                                            //   if (resultCode == 200) {
                                            //     // 성공적으로 토큰을 받았는지 확인
                                            //     final body = response['body'];
                                            //     final accessToken =
                                            //         body['accessToken'];
                                            //     if (accessToken != null) {
                                            //       print(
                                            //           'Access token is available.');

                                            //       final refreshToken =
                                            //           body['refreshToken'];

                                            //       await storage.write(
                                            //         key: "login",
                                            //         value:
                                            //             "accessToken $accessToken refreshToken $refreshToken",
                                            //       );

                                            //       print(
                                            //           'Here is the login button.');

                                            //       await context
                                            //           .read<UserStore>()
                                            //           .changeAccessToken(
                                            //               accessToken);

                                            //       Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 const Main()),
                                            //       );
                                            //     } else {
                                            //       // accessToken이 없을 때의 처리
                                            //       ScaffoldMessenger.of(context)
                                            //           .showSnackBar(
                                            //         SnackBar(
                                            //             content: Text(
                                            //                 '로그인 실패: 토큰을 받지 못했습니다.')),
                                            //       );
                                            //     }
                                            //   } else {
                                            //     // resultCode가 200이 아닌 경우의 처리
                                            //     final resultMessage =
                                            //         response['result']
                                            //             ['resultMessage'];
                                            //     ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //       SnackBar(
                                            //           content: Text(
                                            //               '로그인 실패: $resultMessage')),
                                            //     );
                                            //   }
                                            // } on DioException catch (dioError) {
                                            //   String errorMessage =
                                            //       '로그인 중 문제가 발생했습니다.';
                                            //   if (dioError
                                            //           .response?.statusCode ==
                                            //       400) {
                                            //     errorMessage =
                                            //         '잘못된 아이디나 비밀번호입니다.';
                                            //   } else {
                                            //     // 기타 HTTP 에러 처리
                                            //     errorMessage +=
                                            //         ' 에러 코드: ${dioError.response?.statusCode}';
                                            //   }
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     SnackBar(
                                            //         content:
                                            //             Text(errorMessage)),
                                            //   );
                                            // } catch (e) {
                                            //   // 그 외의 예외 처리
                                            //   print(
                                            //       'An unexpected error occurred: $e');
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     SnackBar(
                                            //         content: Text(
                                            //             '예기치 못한 에러가 발생하였습니다.')),
                                            //   );
                                            // }

                                            // try {
                                            //   final response =
                                            //       await pageapi.login(
                                            //     controller.text.toString(),
                                            //     controller2.text,
                                            //   );
                                            //   if (response["accessToken"] !=
                                            //       null) {
                                            //     final accessToken =
                                            //         await response[
                                            //             "accessToken"];
                                            //     final refreshToken =
                                            //         response["refreshToken"];
                                            //     await widget.storage.write(
                                            //         key: "login",
                                            //         value:
                                            //             "accessToken $accessToken refreshToken $refreshToken");

                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               const Main()),
                                            //     );
                                            //   } else if (response == "fail") {
                                            //     print('fail들어왔다');
                                            //   }
                                            // } catch (e) {
                                            //   print('아이디 비밀번호를 확인 해주세요');
                                            // }

                                            // try {
                                            //   final response =
                                            //       await pageapi.login(
                                            //     controller.text.toString(),
                                            //     controller2.text,
                                            //   );

                                            //   if (response["accessToken"] !=
                                            //       null) {
                                            //     final accessToken =
                                            //         await response[
                                            //             "accessToken"];
                                            //     final refreshToken =
                                            //         response["refreshToken"];
                                            //     await widget.storage.write(
                                            //       key: "login",
                                            //       value:
                                            //           "accessToken $accessToken refreshToken $refreshToken",
                                            //     );

                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             const Main(),
                                            //       ),
                                            //     );
                                            //   } else if (response == "fail") {
                                            //     print('로그인 실패');
                                            //   }
                                            // } catch (e) {
                                            //   print('아이디 비밀번호를 확인해주세요: $e');
                                            // }
                                          },
                                          style:
                                              // const ButtonStyle(
                                              //     backgroundColor:
                                              //         MaterialStatePropertyAll(
                                              //             Color(0xFFF5BEB5))),
                                              OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0), // 원하는 각진 정도로 설정
                                            ),
                                            backgroundColor:
                                                const Color(0xFFF5BEB5),
                                          ),
                                          child: const SizedBox(
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '로그인',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUp()), // SignUpPage는 회원가입 페이지의 위젯입니다.
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: const Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('아직 깔롱쟁이 회원이 아니라면?'),
                                          Text(
                                            '회원가입',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// void showSnackBar(BuildContext context, Text text) {
//   final snackBar =
//       SnackBar(content: text, backgroundColor: const Color(0xFFF5BEB5));

//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
