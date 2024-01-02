import 'package:flutter/material.dart';
import 'package:flutter_mycloset/closet/closetinfo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';
import './closetdetail.dart';
import '../user/pageapi.dart';

class MyCloset extends StatefulWidget {
  const MyCloset({
    super.key,
    this.storage,
  });

  final storage;

  @override
  State<MyCloset> createState() => MyClosetState();
}

class MyClosetState extends State<MyCloset> {
  static final storage = FlutterSecureStorage();
  String? accessToken;
  final PageApi pageapi = PageApi();

  var nick = '';

  @override
  void initState() {
    super.initState();
    // 초기화 작업 수행
    Future.delayed(Duration.zero, () async {
      final userStore = Provider.of<UserStore>(context, listen: false);
      final accessToken = userStore.accessToken;
      final info = await pageapi.getinfo(accessToken);
      if (info != null) {
        nick = info['body']['memberNickname'];
      }
      dioData(accessToken);
    });
  }

  final Dio dio = Dio(); // Dio HTTP 클라이언트 초기화
  final serverURL = 'http://k9c105.p.ssafy.io:8761';
  var data = [];

  final savecloset = {
    "list": [
      {"image": "Assets/Image/logo.png"},
      {"image": "Assets/Image/logo.png"},
      {"image": "Assets/Image/logo.png"},
      {"image": "Assets/Image/logo.png"},
    ]
  };

  Future<dynamic> dioData(token) async {
    try {
      final response = await dio.get('$serverURL/api/closet',
          // queryParameters: {'userEmail': id}
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      var result = response.data['body'];
      setState(() {
        data = result;
      });
      return response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        // DioError를 확인
        _showErrorDialog('오류 발생: ${e.response?.statusCode}');
      } else {
        _showErrorDialog('오류발생!');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('오류 발생!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
// BearList? bearList;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF5BEB5),
//         toolbarHeight: 55,
//         title: const Text(
//           '나의 옷장',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         leading: const Text(''),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                       child: Text(
//                         '안녕하세요,',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                         child: Text(
//                           '나는야김싸피',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFFF5BEB5),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                         child: Text(
//                           '님',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                     child: Text(
//                       '오늘도 깔롱쟁이와 멋쟁이 돼보아요!',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'My깔롱',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFFF5BEB5),
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () async {
//                               final ImagePicker picker = ImagePicker();
//                               final XFile? image = await picker.pickImage(
//                                   source: ImageSource.camera);

//                               if (image != null) {
//                                 // 이미지가 선택되면 처리할 작업을 여기에 추가합니다.
//                                 // image.path를 사용하여 이미지 파일에 접근할 수 있습니다.
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5.0), // 원하는 각진 정도로 설정
//                               ),
//                               // 다른 스타일 속성들
//                             ),
//                             child: const Text(' + 옷장등록'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Expanded(
//                   //   child:
//                   const Column(
//                     children: [
//                       SizedBox(
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // ),

//                   Expanded(
//                     child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2, // Number of columns in the grid
//                         crossAxisSpacing: 5.0, // Spacing between columns
//                         mainAxisSpacing: 5.0, // Spacing between rows
//                       ),
//                       itemCount: savecloset['list']?.length ?? 0,
//                       itemBuilder: (BuildContext context, int index) {
//                         final item = savecloset['list']?[index];
//                         if (item == null) {
//                           return const SizedBox(); // 빈 위젯 반환
//                         }
//                         return GestureDetector(
//                           onTap: () {
//                             // 클릭이벤트
//                           },
//                           // child: Card(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Image.asset(
//                                   item["image"] ?? "Assets/Image/logo.png",
//                                   height: 200,
//                                   width: 200),
//                               // Text(
//                               //   item["name"] ?? "Unknown",
//                               //   style: const TextStyle(
//                               //     fontSize: 16,
//                               //     fontWeight: FontWeight.w600,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                           // ),
//                         );
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Color(0xFFF5BEB5),
            expandedHeight: 55.0,
            floating: true,
            pinned: true,
            title: Text(
              '나의 옷장',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0,
            leading: Text(''),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
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
                                    nick,
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
                            const Padding(
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
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 12),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       SizedBox(
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(20, 0, 10, 12),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               const Text(
                //                 'My깔롱',
                //                 style: TextStyle(
                //                   fontSize: 22,
                //                   fontWeight: FontWeight.w700,
                //                   color: Color(0xFFF5BEB5),
                //                 ),
                //               ),
                //               const Spacer(),
                //               ElevatedButton(
                //                 onPressed: () async {
                //                   final ImagePicker picker = ImagePicker();
                //                   final XFile? image = await picker.pickImage(
                //                       source: ImageSource.camera);

                //                   if (image != null) {
                //                     // 이미지가 선택되면 처리할 작업을 여기에 추가합니다.
                //                     // image.path를 사용하여 이미지 파일에 접근할 수 있습니다.
                //                   }
                //                 },
                //                 style: ElevatedButton.styleFrom(
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(
                //                         5.0), // 원하는 각진 정도로 설정
                //                   ),
                //                   // 다른 스타일 속성들
                //                 ),
                //                 child: const Text(' + 옷장등록'),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 30, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 12),
                        child: Text(
                          'My깔롱',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF5BEB5),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        // onPressed: () async {
                        //   final ImagePicker picker = ImagePicker();
                        //   final XFile? image = await picker.pickImage(
                        //       source: ImageSource.camera);

                        //   if (image != null) {
                        //     // 이미지가 선택되면 처리할 작업을 여기에 추가합니다.
                        //     // image.path를 사용하여 이미지 파일에 접근할 수 있습니다.
                        //   }
                        // },
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            // 이미지가 선택되면 처리할 작업을 여기에 추가합니다.
                            // image.path를 사용하여 이미지 파일에 접근할 수 있습니다.
                            String filePath = image.path;
                            String fileExtension =
                                filePath.split('.').last; // 파일 확장자를 추출합니다.
                            print(fileExtension);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClosetInfo(image: image)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.0), // 원하는 각진 정도로 설정
                          ),
                          // 다른 스타일 속성들
                        ),
                        child: const Text(
                          ' + 옷장등록',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = data?[index];
                  if (item == null) {
                    return const SizedBox(); // 빈 위젯 반환
                  }
                  return GestureDetector(
                    onTap: () {
                      // 클릭이벤트
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ClosetDetail(closetSeq: item['closetSeq'])),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                          item['closetPictureUrl'] ?? "Assets/Image/logo.png",
                          height: 150,
                          width: 150,
                        ),
                        // ... (이전 GridView.builder 코드의 나머지 부분)
                      ],
                    ),
                  );
                },
                childCount: data?.length ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: const Color(0xFFF5BEB5),
    );

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFFF5BEB5),
//           toolbarHeight: 55,
//           title: const Text(
//             '나의 옷장',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//           elevation: 0,
//           leading: const Text(''),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(0, 0, 0, 35),
//                   child: const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                           child: Text(
//                             '안녕하세요,',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                             child: Text(
//                               '나는야김싸피',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFF5BEB5),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                             child: Text(
//                               '님',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                         child: Text(
//                           '오늘도 깔롱쟁이와 멋쟁이 돼보아요!',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'My깔롱',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFFF5BEB5),
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 final ImagePicker picker = ImagePicker();
//                                 final XFile? image = await picker.pickImage(
//                                     source: ImageSource.camera);

//                                 if (image != null) {
//                                   // 이미지가 선택되면 처리할 작업을 여기에 추가합니다.
//                                   // image.path를 사용하여 이미지 파일에 접근할 수 있습니다.
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5.0), // 원하는 각진 정도로 설정
//                                 ),
//                                 // 다른 스타일 속성들
//                               ),
//                               child: const Text(' + 옷장등록'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Expanded(
//                     //   child:
//                     const Column(
//                       children: [
//                         SizedBox(
//                           child: Padding(
//                             padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // ),

//                     GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2, // Number of columns in the grid
//                         crossAxisSpacing: 5.0, // Spacing between columns
//                         mainAxisSpacing: 5.0, // Spacing between rows
//                       ),
//                       itemCount: savecloset['list']?.length ?? 0,
//                       itemBuilder: (BuildContext context, int index) {
//                         final item = savecloset['list']?[index];
//                         if (item == null) {
//                           return const SizedBox(); // 빈 위젯 반환
//                         }
//                         return GestureDetector(
//                           onTap: () {
//                             // 클릭이벤트
//                           },
//                           // child: Card(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Image.asset(
//                                   item["image"] ?? "Assets/Image/logo.png",
//                                   height: 200,
//                                   width: 200),
//                               // Text(
//                               //   item["name"] ?? "Unknown",
//                               //   style: const TextStyle(
//                               //     fontSize: 16,
//                               //     fontWeight: FontWeight.w600,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                           // ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

// void showSnackBar(BuildContext context, String text) {
//   final snackBar = SnackBar(
//     content: Text(text),
//     backgroundColor: const Color(0xFFF5BEB5),
//   );

//   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
}
