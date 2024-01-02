// import 'package:flutter/material.dart';

// class AddInfo extends StatefulWidget {
//   // const AddInfo({super.key, this.user, this.storage});
//   // final user;
//   // final storage;
//   const AddInfo({super.key});
//   // const AddInfo({Key? key, this.user, this.storage});

//   @override
//   State<AddInfo> createState() => _AddInfoState();
// }

// class _AddInfoState extends State<AddInfo> {
//   TextEditingController controller = TextEditingController();
//   TextEditingController controller2 = TextEditingController();
//   TextEditingController controller3 = TextEditingController();

//   int? selectedYear;
//   List<DropdownMenuItem<int>> yearItems = []; //태어난 년도 드롭다운 리스트
//   void initYearItems() {
//     for (int year = 1900; year <= DateTime.now().year; year++) {
//       yearItems.add(DropdownMenuItem<int>(
//         value: year,
//         child: Text(year.toString()),
//       ));
//     }
//   }

//   String? birthday;
//   String? gender;
//   List<String> genderList = [
//     '남성',
//     '여성',
//   ];
//   String selectedGender = '남성';
//   String selectedGenderString = 'm';

//   List<Object?> selectedAllergie = [];
//   List<dynamic> selectedAllergieNumber = [];

//   bool mandown = false;
//   bool yearcheck = false;

//   @override
//   void initState() {
//     super.initState();

//     // if (widget.user['userGender'] == "f") {
//     //   setState(() {
//     //     selectedGender = '여성';
//     //   });
//     //   selectedGenderString = 'f';
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           '',
//           style: TextStyle(
//               fontSize: 25, color: Colors.black, fontWeight: FontWeight.w700),
//         ),
//         elevation: 0.0,
//         backgroundColor: Colors.grey[50],
//         centerTitle: true,
//         toolbarHeight: 65,
//         leading: IconButton(
//           color: Colors.black,
//           icon: const Icon(Icons.keyboard_backspace_rounded),
//           onPressed: () {},
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.values.first,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '(선택)추가 정보',
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                     ),
//                     Text('맞춤 정보 제공을 위해\n자율적으로 추가 정보를 입력해주세요.'),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
//                 child: Row(
//                   children: [
//                     Flexible(
//                       fit: FlexFit.tight,
//                       flex: 1,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             '출생년도',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           DropdownButton<int>(
//                               value: selectedYear,
//                               items: yearItems,
//                               onChanged: (int? value) {
//                                 setState(() {
//                                   selectedYear = value;
//                                 });
//                               })
//                         ],
//                       ),
//                     ),
//                     Flexible(
//                       fit: FlexFit.tight,
//                       flex: 1,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             '성별',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           DropdownButton(
//                             alignment: Alignment.bottomLeft,
//                             value: selectedGender,
//                             items: genderList.map((String item) {
//                               return DropdownMenuItem<String>(
//                                 value: item,
//                                 child: Text(item),
//                               );
//                             }).toList(),
//                             onChanged: (dynamic value) {
//                               setState(() {
//                                 selectedGender = value;
//                               });
//                               if (selectedGender == '남자') {
//                                 selectedGenderString = 'm';
//                               } else {
//                                 selectedGenderString = 'f';
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({Key? key}) : super(key: key);

  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  int? selectedYear;
  List<DropdownMenuItem<int>> yearItems = []; // 태어난 년도 드롭다운 리스트

  void initYearItems() {
    for (int year = 1900; year <= DateTime.now().year; year++) {
      yearItems.add(DropdownMenuItem<int>(
        value: year,
        child: Text(year.toString()),
      ));
    }
  }

  String? birthday;
  String? gender;
  List<String> genderList = ['남성', '여성'];
  String selectedGender = '남성';
  String selectedGenderString = 'm';

  bool mandown = false;
  bool yearcheck = false;

  @override
  void initState() {
    super.initState();
    initYearItems(); // yearItems 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '추가 정보',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        toolbarHeight: 65,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.keyboard_backspace_rounded),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '(선택)추가 정보',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text('맞춤 정보 제공을 위해\n자율적으로 추가 정보를 입력해주세요.'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '태어난 년도',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          DropdownButton<int>(
                            value: selectedYear,
                            items: yearItems,
                            onChanged: (int? value) {
                              setState(() {
                                selectedYear = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '성별',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedGender,
                            items: genderList.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value!;
                                selectedGenderString =
                                    (value == '남성') ? 'm' : 'f';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
