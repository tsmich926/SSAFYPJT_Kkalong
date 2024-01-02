// import 'package:flutter/material.dart';

// class ClosetClothList extends StatefulWidget {
//   const ClosetClothList({super.key, this.scrollController});
//   final scrollController;

//   @override
//   State<ClosetClothList> createState() => _ClosetClothListState();
// }

// class _ClosetClothListState extends State<ClosetClothList> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getCategory(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData == false) {
//             return Shimmer.fromColors(
//               baseColor: Colors.grey.shade300,
//               highlightColor: Colors.grey.shade100,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 2,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Shimmer.fromColors(
//                         baseColor: Colors.grey.shade300,
//                         highlightColor: Colors.grey.shade100,
//                         child: Container(
//                           height: 230,
//                           width: double.infinity,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: Container(
//                                 height: 40,
//                                 width: 40,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             Expanded(
//                               child: Shimmer.fromColors(
//                                 baseColor: Colors.grey.shade300,
//                                 highlightColor: Colors.grey.shade100,
//                                 child: Container(
//                                   height: 20,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             );
//           }
//           //error가 발생하게 될 경우 반환
//           else if (snapshot.hasError) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(fontSize: 15),
//               ),
//             );
//           }
//           // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행
//           else {
//             return Expanded(
//               child: RefreshIndicator(
//                 color: const Color(0xFFF5BEB5),
//                 onRefresh: () async {
//                   setState(() {});
//                 },
//                 child: ListView.builder(
//                     controller: widget.scrollController,
//                     shrinkWrap: true,
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () {},
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Image.network(
//                             //     snapshot.data[index]['ClothesThumbnail'],
//                             //     height: 230,
//                             //     width: double.infinity,
//                             //     fit: BoxFit.fill),
//                             Container(
//                                 margin:
//                                     const EdgeInsets.fromLTRB(20, 15, 20, 30),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: Image.asset(
//                                         'Assets/Image/logo.png',
//                                         height: 40,
//                                         width: 40,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             '${snapshot.data[index]['recipeName']}',
//                                             style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                             softWrap: true,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ))
//                           ],
//                         ),
//                       );
//                     }),
//               ),
//             );
//           }
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';
import 'clothdetail.dart';

class ClosetClothList extends StatefulWidget {
  const ClosetClothList({super.key, this.storage, required this.sectionSeq});

  final storage;
  final int sectionSeq;

  @override
  State<ClosetClothList> createState() => _ClosetClothListState();
}

class _ClosetClothListState extends State<ClosetClothList> {
  static final storage = FlutterSecureStorage();
  String? accessToken;

  @override
  void initState() {
    super.initState();
    final userStore = Provider.of<UserStore>(context, listen: false);
    accessToken = userStore.accessToken;
    dioData(accessToken);
  }

  final Dio dio = Dio(); // Dio HTTP 클라이언트 초기화
  final serverURL = 'http://k9c105.p.ssafy.io:8761';

  var data = [];

  Future<dynamic> dioData(token) async {
    try {
      final response =
          await dio.get('$serverURL/api/cloth/section/${widget.sectionSeq}',
              // queryParameters: {'userEmail': id}
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
                  // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
                },
              ));
      var result = response.data['body'];
      print(result);
      setState(() {
        data = result;
      });
      return response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        // DioError를 확인
        _showErrorDialog('오류 발생: ${e.response?.statusCode}\n더이상 평가할 사진이 없습니다!');
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length, // 3줄을 나타내도록 설정
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                // 클릭 이벤트 -> 옷상세로 넘어가게 할거임..
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClothDetail(clothSeq: data[index]['clothSeq'])),
                );
              },
              child:
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           margin: const EdgeInsets.all(8.0),
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(10),
                  //             child: Image.asset(
                  //               'Assets/Image/logo.png',
                  //               height: 100,
                  //               width: 150,
                  //               fit: BoxFit.fill,
                  //             ),
                  //           ),
                  //         ),

                  //         Container(
                  //           padding: const EdgeInsets.only(right: 20),
                  //           child: Text(
                  //             '룰루랄라 오늘은 금요일 이미지ㅇㅇㅇ $index',
                  //             style: const TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //             overflow: TextOverflow.clip, // 글자를 자르도록 설정
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //     const Divider(
                  //       height: 1,
                  //       thickness: 1,
                  //     ), // 구분선
                  //   ],
                  // ),
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            data[index]['imgUrl'],
                            height: 100,
                            width: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Flexible(
                        // Flexible 추가
                        child: Container(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            data[index]['clothName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.clip, // 글자를 자르도록 설정
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Icon(data[index]['private'] == true
                            ? Icons.lock
                            : Icons.lock_open),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ), // 구분선
                ],
              ));
        },
      ),
    );
  }
}
