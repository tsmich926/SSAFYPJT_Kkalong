// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Signup(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_mycloset/user/login.dart';
import 'pageapi.dart';

// import './addinfo.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  final _wman = ['남자', '여자']; // 성별선택 드롭다운 리스트
  String? _selectedWman;

  bool idCheck = false;
  bool nickCheck = false;
  bool emailCheck = false;
  bool passwordCheck = false;
  bool samepasswordCheck = false;

  String? idError;
  String idMessage = '최소 5자 이상 20자 이하';
  String? emailError;
  String emailMessage = '이메일 형식으로 입력해주세요';
  String? passwordError;
  String passwordMessage = '영/숫자 한번 이상 사용, 최소 8자에서 20자 이내로 작성';
  String? samepasswordError;
  String samepasswordMessage = '비밀번호와 다릅니다.';
  String? nickError;
  String nickMessage = '최소 2자 이상 10자 이하';

  int? selectedYear;
  List<DropdownMenuItem<int>> yearItems = []; // 태어난 년도 드롭다운 리스트

  final PageApi pageapi = PageApi();

  void initYearItems() {
    for (int year = 1980; year <= DateTime.now().year - 10; year++) {
      yearItems.add(DropdownMenuItem<int>(
        value: year,
        child: Text(year.toString()),
      ));
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     _selectedWman = _wman[0];
  //   });
  // }

  @override
  void initState() {
    super.initState();
    initYearItems();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              '회원가입',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                    child: Theme(
                  data: ThemeData(
                      primaryColor: Colors.grey,
                      inputDecorationTheme: const InputDecorationTheme(
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.0))),
                  child: Container(
                      // padding: const EdgeInsets.all(40.0),
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
                      child: Builder(builder: (context) {
                        return SizedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          if (!RegExp(
                                                  r'^(?=.*[A-Za-z])[A-Za-z0-9]{5,20}$')
                                              .hasMatch(value)) {
                                            setState(() {
                                              idError = idMessage;
                                            });
                                          } else {
                                            setState(() {
                                              idError = null; // 에러 없음
                                            });
                                          }
                                        },
                                        controller: controller,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.0,
                                            horizontal: 40.0,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFF5BEB5),
                                            ),
                                          ),
                                          prefixIconColor: Color(0xFFF5BEB5),
                                          prefixIcon: Icon(
                                            Icons.account_circle,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                          labelText: '아이디',
                                          errorText: idError,
                                          errorStyle: TextStyle(height: 1),
                                          focusColor: Color(0xFFF5BEB5),
                                        ),
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20, // 중복 확인 버튼과 아이디 입력창 사이의 간격 설정
                                    ),
                                    SizedBox(
                                      width: 90,
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                                        final checkid =
                                                              await pageapi.checkid(
                                                                  controller
                                                                      .text
                                                                      .toString());
                                                          print(checkid);
                                                          if (checkid
                                                                  .toString() ==
                                                              "true") {
                                                                print(1);
                                                                showDialog(context: context, builder: (context) {
                                                                   return Dialog( child: 
                                                                   Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    color: Colors.white,
                                                                    child: Center(child: Text('사용가능한 아이디입니다.')))
                                                                   );
                                                                 }
                                                                );
                                                            setState(() {
                                                              idCheck = true;
                                                            });
                                                          } else {
                                                            showDialog(context: context, builder: (context) {
                                                                   return Dialog( child: 
                                                                   Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    color: Colors.white,
                                                                    child: Center(child: Text('중복된 아이디입니다.')))
                                                                   );
                                                                 }
                                                                );
                                                            setState(() {
                                                              idCheck = false;
                                                            });
                                                          }
                                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5.0), // 각진 정도 조절
                                          ),
                                          side: const BorderSide(
                                            color:
                                                Color(0xFFF5BEB5), // 외곽선 색상 설정
                                            width: 1, // 외곽선 두께 설정
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.2, 0.2, 0.2, 0.2),
                                          child: Text(
                                            '중복 확인',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color(0xFFF5BEB5), // 글자 색상 설정
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 80,
                                child: TextField(
                                  onChanged: (value) {
                                    if (!RegExp(
                                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$')
                                        .hasMatch(value)) {
                                      setState(() {
                                        passwordError = passwordMessage;
                                        passwordCheck = false;
                                        if (controller2.text ==
                                            controller3.text) {
                                          setState(() {
                                            samepasswordError = null;
                                            samepasswordCheck = true;
                                          });
                                        } else {
                                          samepasswordError =
                                              samepasswordMessage;
                                          samepasswordCheck = false;
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        passwordError = null; // 에러 없음
                                        passwordCheck = true;
                                      });
                                      if (controller2.text ==
                                          controller3.text) {
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 10.0),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFF5BEB5))),
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
                              SizedBox(
                                height: 80,
                                child: TextField(
                                  onChanged: (value){
                                    if (controller2.text ==
                                            controller3.text) {
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 10.0),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFF5BEB5))),
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
                              SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          if (!RegExp(
                                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                              .hasMatch(value)) {
                                            setState(() {
                                              emailError = emailMessage;
                                              emailCheck = false;
                                            });
                                          } else {
                                            setState(() {
                                              emailError = null; // 에러 없음
                                              emailCheck = true;
                                            });
                                          }
                                        },
                                        controller: controller4,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.0,
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
                                            Icons.alternate_email_rounded,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                          labelText: '이메일',
                                          errorText: emailError,
                                          errorStyle: TextStyle(height: 1),
                                          focusColor: Color(0xFFF5BEB5),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10, // 이메일 인풋창과 인증 버튼 사이의 간격 설정
                                    ),
                                    SizedBox(
                                      width: 70,
                                      height: 48,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // 중복 확인 작업을 수행하는 코드 추가
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5.0), // 각진 정도 조절
                                          ),
                                          side: const BorderSide(
                                            color:
                                                Color(0xFFF5BEB5), // 외곽선 색상 설정
                                            width: 1, // 외곽선 두께 설정
                                          ),
                                        ),
                                        child: const Text(
                                          '인증',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Color(0xFFF5BEB5), // 글자 색상 설정
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          if (!RegExp(
                                                  r'^[A-Za-z가-힣0-9]{2,10}$')
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
                                        controller: controller5,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 16.0,
                                            horizontal: 40.0,
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
                                      width: 20, // 중복 확인 버튼과 아이디 입력창 사이의 간격 설정
                                    ),
                                    SizedBox(
                                      width: 90,
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                                        final checkNick =
                                                              await pageapi.checkNick(
                                                                  controller5
                                                                      .text
                                                                      .toString());
                                                          print(checkNick);
                                                          if (checkNick
                                                                  .toString() ==
                                                              "true") {
                                                                print(11);
                                                            showDialog(context: context, builder: (context) {
                                                                   return Dialog( child: 
                                                                   Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    color: Colors.white,
                                                                    child: Center(child: Text('사용가능한 닉네임입니다.')))
                                                                   );
                                                                 }
                                                                );    
                                                            setState(() {
                                                              nickCheck = true;
                                                            });
                                                          } else {
                                                            showDialog(context: context, builder: (context) {
                                                                   return Dialog( child: 
                                                                   Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    color: Colors.white,
                                                                    child: Center(child: Text('중복된 닉네임입니다.')))
                                                                   );
                                                                 }
                                                                );
                                                            setState(() {
                                                              nickCheck = false;
                                                            });
                                                          }
                                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5.0), // 각진 정도 조절
                                          ),
                                          side: const BorderSide(
                                            color:
                                                Color(0xFFF5BEB5), // 외곽선 색상 설정
                                            width: 1, // 외곽선 두께 설정
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.2, 0.2, 0.2, 0.2),
                                          child: Text(
                                            '중복 확인',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Color(0xFFF5BEB5), // 글자 색상 설정
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '(선택)추가 정보',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                          '맞춤 정보 제공을 위해\n자율적으로 추가 정보를 입력해주세요.'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: TextField(
                                  controller: controller6,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 10.0),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xFFF5BEB5))),
                                      prefixIconColor: Color(0xFFF5BEB5),
                                      prefixIcon: Icon(Icons.call),
                                      border: OutlineInputBorder(),
                                      labelText: '전화번호',
                                      focusColor: Color(0xFFF5BEB5)),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                                child: Row(
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '생년',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          // DropdownButton<String>(
                                          //   value: _selectedWman,
                                          //   items: _wman.map((e) {
                                          //     return DropdownMenuItem<String>(
                                          //       value: e,
                                          //       child: Text(e),
                                          //     );
                                          //   }).toList(),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       _selectedWman = value!;
                                          //     });
                                          //   },
                                          // ),
                                          DropdownButton<int>(
                                            value: selectedYear,
                                            items: yearItems,
                                            onChanged: (int? year) {
                                              setState(() {
                                                selectedYear = year;
                                              });
                                            },
                                            hint: const Text('태어난 년도를 선택하세요'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '성별',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          DropdownButton<String>(
                                            value: _selectedWman,
                                            items: _wman.map((e) {
                                              return DropdownMenuItem<String>(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedWman = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: ButtonTheme(
                                      child: TextButton(
                                          onPressed: idCheck && nickCheck && emailCheck && passwordCheck && samepasswordCheck? 
                                          () async {
                                                        final signup =
                                                              await pageapi.signup(
                                                                  controller5
                                                                      .text
                                                                      .toString(),
                                                                  controller.text.toString(),
                                                                  controller2.text,
                                                                  controller4.text.toString(),
                                                                  controller6.text,
                                                                  selectedYear,
                                                                  _selectedWman
                                                                  );
                                                          print(signup);
                                                          if (signup == 200) {
                                                          await showDialog(context: context, builder: (context) {
                                                                   return Dialog( child: 
                                                                   Container(
                                                                    width: 100,
                                                                    height: 100,
                                                                    color: Colors.white,
                                                                    child: Center(child: Text('회원가입 성공')))
                                                                   );
                                                                 }
                                                                );
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => const LogIn()),
                                                          );
                                                          }
                                                          // if (signup
                                                          //         .toString() ==
                                                          //     "true") {
                                                          //       print(1);
                                                          //       showDialog(context: context, builder: (context) {
                                                          //          return Dialog( child: 
                                                          //          Container(
                                                          //           width: 100,
                                                          //           height: 100,
                                                          //           color: Colors.white,
                                                          //           child: Center(child: Text('사용가능한 아이디입니다.')))
                                                          //          );
                                                          //        }
                                                          //       );
                                                          //   setState(() {
                                                          //     idCheck = true;
                                                          //   });
                                                          // } else {
                                                          //   showDialog(context: context, builder: (context) {
                                                          //          return Dialog( child: 
                                                          //          Container(
                                                          //           width: 100,
                                                          //           height: 100,
                                                          //           color: Colors.white,
                                                          //           child: Center(child: Text('중복된 아이디입니다.')))
                                                          //          );
                                                          //        }
                                                          //       );
                                                          //   setState(() {
                                                          //     idCheck = false;
                                                          //   });
                                                          // }
                                                        } : null,
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFF5BEB5))),
                                          child: const SizedBox(
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '회원가입',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ))),
                                ),
                              ),
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

void showSnackBar(BuildContext context, Text text) {
  final snackBar =
      SnackBar(content: text, backgroundColor: const Color(0xFFF5BEB5));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
