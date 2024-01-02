import 'package:flutter/material.dart';
import 'package:flutter_mycloset/main.dart';
import 'package:flutter_mycloset/user/login.dart';
import 'package:flutter_mycloset/user/pageapi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  // final storage;

  @override
  State<MyPage> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  static final storage = FlutterSecureStorage();
  final PageApi pageapi = PageApi();

  String nick = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final userStore = Provider.of<UserStore>(context, listen: false);
      final accessToken = userStore.accessToken;
      print(accessToken);
      final info = await pageapi.getinfo(accessToken);
      print(info);

      if (info != null) {
        nick = info['body']['memberNickname'];
        print(nick);
      }

      // if (info != null) {
      //   await userStore.changeUserInfo(info['userEmail']);
      //   favoringredient = info['ingredientList'];
      //   favorrecipe = info['recipeList'];
      //   selectedVeganNumber = info['veganId'];
      //   selectedVegan = veganList[selectedVeganNumber];

      //   final resallergyList = (info['allergyList']);
      //   print(resallergyList);
      //   print(resallergyList.runtimeType);
      //   if (resallergyList.isNotEmpty) {
      //     print(1);
      //     algdropdown = true;
      //     havAllergie = '있음';
      //   }
      //   for (int i = 0; i < resallergyList.length; i++) {
      //     selectedAllergieNumber.add(resallergyList[i]['algyId']);
      //     selectedAllergie.add(resallergyList[i]['algyName']);
      //   }
      //   print(selectedAllergieNumber);
      //   print(selectedAllergie);
      // }
      // setState(() {});
      // 이제 userStore를 사용할 수 있습니다.
      // ...
    });

    // 초기화 작업 수행
  }

  final savecloItem = {
    "list": [
      {"image": "Assets/Image/logo.png", "name": "깔쌈한코디1"},
      {"image": "Assets/Image/logo.png", "name": "깔쌈코디2"},
      {"image": "Assets/Image/logo.png", "name": "깔삼코디3"},
      {"image": "Assets/Image/logo.png", "name": "하늘하늘코디3"},
    ]
  };
// BearList? bearList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5BEB5),
          toolbarHeight: 55,
          title: const Text(
            '마이프로필',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body:
            // Container(
            //   padding: const EdgeInsets.all(30),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
            //         child: const Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //               child: Padding(
            //                 padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //                 child: Text(
            //                   '안녕하세요,',
            //                   style: TextStyle(
            //                     fontSize: 20,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Row(
            //               children: [
            //                 Padding(
            //                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //                   child: Text(
            //                     '나는야김싸피',
            //                     style: TextStyle(
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.w600,
            //                       color: Color(0xFFF5BEB5),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //                   child: Text(
            //                     '님',
            //                     style: TextStyle(
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Padding(
            //               padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: Text(
            //                 '오늘도 깔롱쟁이와 멋쟁이 돼보아요!',
            //                 style: TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //               child: Padding(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     const Text(
            //                       'My깔롱',
            //                       style: TextStyle(
            //                         fontSize: 22,
            //                         fontWeight: FontWeight.w700,
            //                         color: Color(0xFFF5BEB5),
            //                       ),
            //                     ),
            //                     ElevatedButton(
            //                       onPressed: () {
            //                         // 버튼 클릭 이벤트
            //                       },
            //                       style: ElevatedButton.styleFrom(
            //                         shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.circular(
            //                               5.0), // 원하는 각진 정도로 설정
            //                         ),
            //                         // 다른 스타일 속성들
            //                       ),
            //                       child: const Text('Follow List'),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             // Expanded(
            //             //   child:
            //             Column(
            //               children: [
            //                 SizedBox(
            //                   child: Padding(
            //                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       crossAxisAlignment: CrossAxisAlignment.end,
            //                       children: [
            //                         const Row(
            //                           children: [
            //                             Text(
            //                               '저장한 코디 ',
            //                               style: TextStyle(
            //                                 fontSize: 17,
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                             ),
            //                             Text(
            //                               '(3건)',
            //                               style: TextStyle(
            //                                 fontSize: 12,
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                         GestureDetector(
            //                           onTap: () {
            //                             // 이동 로직을 추가하세요.
            //                           },
            //                           child: const Text('더보기'),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             // ),
            //             Expanded(
            //               child: GridView.builder(
            //                 gridDelegate:
            //                     const SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 2, // Number of columns in the grid
            //                   crossAxisSpacing: 5.0, // Spacing between columns
            //                   mainAxisSpacing: 5.0, // Spacing between rows
            //                 ),
            //                 itemCount: savecloItem['list']?.length ?? 0,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   final item = savecloItem['list']?[index];
            //                   if (item == null) {
            //                     return const SizedBox(); // 빈 위젯 반환
            //                   }
            //                   return GestureDetector(
            //                     onTap: () {
            //                       // 클릭이벤트
            //                     },
            //                     child: Card(
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: <Widget>[
            //                           Image.asset(
            //                               item["image"] ?? "Assets/Image/logo.png",
            //                               height: 100,
            //                               width: 100),
            //                           Text(
            //                             item["name"] ?? "Unknown",
            //                             style: const TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   );
            //                 },
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       ListTileTheme(
            //         selectedColor: Colors.blue,
            //         child: ListTile(
            //           title: const Text('로그아웃'),
            //           trailing: const Icon(Icons.chevron_right),
            //           onTap: () async {
            //             await storage.delete(key: "login");
            //             await pageapi.logout(context.read<UserStore>().accessToken);
            //             await context.read<UserStore>().changeAccessToken('');

            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (BuildContext context) => LogIn()),
            //                 (route) => false);
            //           },
            //         ),
            //       ),
            //       ListTileTheme(
            //         selectedColor: Colors.blue,
            //         child: ListTile(
            //           title: const Text('정보수정'),
            //           trailing: const Icon(Icons.chevron_right),
            //           onTap: () {
            //             showDialog(
            //                 context: context,
            //                 builder: (context) {
            //                   return DialogUI(nick: nick);
            //                 });
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // )

            CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                '안녕하세요,',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  '나는야김싸피',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF5BEB5),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  '님',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              '오늘도 깔롱쟁이와 멋쟁이 돼보아요!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ... (any other widgets you want at the top of the scroll view)
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My깔롱',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF5BEB5),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5.0), // 원하는 각진 정도로 설정
                              ),
                              // 다른 스타일 속성들
                            ),
                            child: Text('Follow List'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child:
                  Column(
                    children: const [
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '저장한 코디 ',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '(3건)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     // 이동 로직을 추가하세요.
                              //   },
                              //   child: Text('더보기'),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(
                  20), // Use your desired padding value here.
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final item = savecloItem['list']?[index];
                    if (item == null) {
                      return const SizedBox(); // If the item is null, return an empty container
                    }
                    return GestureDetector(
                      onTap: () {
                        // 클릭 이벤트
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              item["image"] ?? "Assets/Image/logo.png",
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              item["name"] ?? "Unknown",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: savecloItem['list']?.length ?? 0,
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 8, 10),
              child: Column(
                children: [
                  ListTileTheme(
                    selectedColor: Colors.blue,
                    child: ListTile(
                      title: const Text('로그아웃'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                  ListTileTheme(
                    selectedColor: Colors.blue,
                    child: ListTile(
                      title: const Text('정보수정'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: const Color(0xFFF5BEB5),
  );

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/////////////////////////////////////정보수정 모달
class DialogUI extends StatefulWidget {
  DialogUI({Key? key, this.nick}) : super(key: key);
  final nick;

  @override
  State<DialogUI> createState() => _DialogUIState();
}

class _DialogUIState extends State<DialogUI> {
  late TextEditingController controller;
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();

  bool nickCheck = false;
  bool passwordCheck = false;
  bool samepasswordCheck = false;

  String? nickError;
  String nickMessage = '최소 2자 이상 10자 이하';
  String? passwordError;
  String passwordMessage = '영/숫자 한번 이상 사용, 최소 8자에서 20자 이내로 작성';
  String? samepasswordError;
  String samepasswordMessage = '비밀번호와 다릅니다.';
  String access = '';

  final PageApi pageapi = PageApi();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.nick);
    // final userStore = Provider.of<UserStore>(context, listen: false);
    // final accessToken = userStore.accessToken;
    // final access = accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // 이 부분이 중요합니다
                children: const [
                  Text(
                    '정보수정',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (!RegExp(r'^[A-Za-z가-힣0-9]{2,10}$')
                            .hasMatch(value)) {
                          setState(() {
                            nickError = nickMessage;
                          });
                        } else {
                          setState(() {
                            nickError = null; // 에러 없음
                          });
                        }
                      },
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Color(0xFFF5BEB5),
                          ),
                        ),
                        prefixIconColor: Color(0xFFF5BEB5),
                        prefixIcon: Icon(
                          Icons.face_6,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: '닉네임',
                        errorText: nickError,
                        errorStyle: TextStyle(height: 1),
                        focusColor: Color(0xFFF5BEB5),
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    width: 10, // 중복 확인 버튼과 아이디 입력창 사이의 간격 설정
                  ),
                  SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () async {
                        final checkNick =
                            await pageapi.checkNick(controller.text.toString());
                        print(checkNick);
                        if (checkNick.toString() == "true") {
                          print(11);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.white,
                                        child: Center(
                                            child: Text('사용가능한 닉네임입니다.'))));
                              });
                          setState(() {
                            nickCheck = true;
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.white,
                                        child: Center(
                                            child: Text('중복된 닉네임입니다.'))));
                              });
                          setState(() {
                            nickCheck = false;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 각진 정도 조절
                        ),
                        side: const BorderSide(
                          color: Color(0xFFF5BEB5), // 외곽선 색상 설정
                          width: 1, // 외곽선 두께 설정
                        ),
                        padding: EdgeInsets.all(10), // 모든 방향으로 10px의 패딩 적용
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown, // 텍스트가 버튼에 맞게 축소됨
                        child: Text(
                          '중복확인',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF5BEB5), // 글자 색상 설정
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                onChanged: (value) {
                  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$')
                      .hasMatch(value)) {
                    setState(() {
                      passwordError = passwordMessage;
                      passwordCheck = false;
                      if (controller2.text == controller3.text) {
                        setState(() {
                          samepasswordError = null;
                          samepasswordCheck = true;
                        });
                      } else {
                        samepasswordError = samepasswordMessage;
                        samepasswordCheck = false;
                      }
                    });
                  } else {
                    setState(() {
                      passwordError = null; // 에러 없음
                      passwordCheck = true;
                    });
                    if (controller2.text == controller3.text) {
                      setState(() {
                        samepasswordError = null;
                        samepasswordCheck = true;
                      });
                    } else {
                      samepasswordError = samepasswordMessage;
                      samepasswordCheck = false;
                    }
                  }
                },
                controller: controller2,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: Color(0xFFF5BEB5))),
                    prefixIconColor: Color(0xFFF5BEB5),
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                    border: OutlineInputBorder(),
                    labelText: '비밀번호',
                    errorText: passwordError,
                    errorStyle: TextStyle(height: 1),
                    focusColor: Color(0xFFF5BEB5)),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true, // 비밀번호 안보이도록 하는 것
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                onChanged: (value) {
                  if (controller2.text == controller3.text) {
                    setState(() {
                      samepasswordError = null;
                      samepasswordCheck = true;
                    });
                  } else {
                    setState(() {
                      samepasswordError = samepasswordMessage;
                      samepasswordCheck = false;
                    });
                    // samepasswordError =
                    //     samepasswordMessage;
                    // samepasswordCheck = false;
                  }
                },
                controller: controller3,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: Color(0xFFF5BEB5))),
                    prefixIconColor: Color(0xFFF5BEB5),
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(),
                    labelText: '비밀번호 확인',
                    errorText: samepasswordError,
                    errorStyle: TextStyle(height: 1),
                    focusColor: Color(0xFFF5BEB5)),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true, // 비밀번호 안보이도록 하는 것
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: Row(
                children: [
                  ButtonTheme(
                      child: TextButton(
                          onPressed: nickCheck &&
                                  passwordCheck &&
                                  samepasswordCheck
                              ? () async {
                                  final userStore = Provider.of<UserStore>(
                                      context,
                                      listen: false);
                                  final accessToken = userStore.accessToken;

                                  final updateinfo =
                                      await pageapi.updateuserinfo(
                                          accessToken,
                                          controller.text.toString(),
                                          controller2.text,
                                          controller3.text);
                                  print(updateinfo);
                                  if (updateinfo['result']['resultCode'] ==
                                      200) {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                              child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.white,
                                                  child: Center(
                                                      child: Text('정보수정 성공'))));
                                        });
                                    Navigator.pop(context);
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => const LogIn()),
                                    //   );
                                  }
                                }
                              : null,
                          style:
                              // const ButtonStyle(
                              //     backgroundColor:
                              //         MaterialStatePropertyAll(
                              //             Color(0xFFF5BEB5))),
                              OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5.0), // 원하는 각진 정도로 설정
                            ),
                            backgroundColor: const Color(0xFFF5BEB5),
                          ),
                          child: const SizedBox(
                            height: 40,
                            width: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '정보 수정',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  ButtonTheme(
                      child: TextButton(
                          onPressed: () async {
                            final userStore =
                                Provider.of<UserStore>(context, listen: false);
                            final accessToken = userStore.accessToken;

                            final deleteuser =
                                await pageapi.deleteuser(accessToken);
                            print(deleteuser);
                            if (deleteuser['result']['resultCode'] == 200) {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        child: Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.white,
                                            child: Center(
                                                child: Text('회원탈퇴 성공'))));
                                  });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogIn()),
                              );
                            }
                          },
                          style:
                              // const ButtonStyle(
                              //     backgroundColor:
                              //         MaterialStatePropertyAll(
                              //             Color(0xFFF5BEB5))),
                              OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5.0), // 원하는 각진 정도로 설정
                            ),
                            backgroundColor: const Color(0xFFF5BEB5),
                          ),
                          child: const SizedBox(
                            height: 40,
                            width: 95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '회원 탈퇴',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
