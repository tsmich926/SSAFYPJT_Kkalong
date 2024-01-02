import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';
import 'package:dio/dio.dart';

class ClothSlide extends StatefulWidget {
  final String sortName;

  const ClothSlide({super.key, required this.sortName});

  @override
  State<ClothSlide> createState() => _ClothSlideState();
}

class _ClothSlideState extends State<ClothSlide> {
  int? selectedIndex;
  List<dynamic> cloList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var accessToken = context.read<UserStore>().accessToken;
    Dio dio = Dio();
    const serverURL = 'http://k9c105.p.ssafy.io:8761';

    try {
      Map<String, dynamic> headers = {};
      if (accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await dio.get(
        '$serverURL/api/cloth/sort/${widget.sortName}',
        options: Options(headers: headers),
      );
      print('옷슬라이드-------------디오요청했음-------------');
      print('리스판스데이터--------------');
      print(response.data);
      // var cloList = response.data['body'];
      setState(() {
        cloList = response.data['body'];
      });
      print('클로리스트출력');
      print(cloList);
      return response.data;
    } catch (e) {
      print('에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var ranking = [
    //   {'rank': '1', 'title': '깔롱한옷1', 'image': 'exshirts'},
    //   {'rank': '2', 'title': '깔롱한옷2', 'image': 'exshirts2'},
    //   {'rank': '3', 'title': '집에가고싶은옷', 'image': 'exshirts3'},
    //   {'rank': '4', 'title': '집에보내줄옷', 'image': 'exshirts'},
    //   {'rank': '5', 'title': '졸린다', 'image': 'exshirts'},
    //   {'rank': '6', 'title': '잠온다', 'image': 'exshirts'},
    //   {'rank': '7', 'title': '여름에 입으면 예쁠 반바지', 'image': 'exshirts'},
    //   {'rank': '8', 'title': '오늘 점심은 장각칼국수 셔츠', 'image': 'exshirts'},
    //   {'rank': '9', 'title': '졸린다람쥐반팔', 'image': 'exshirts'},
    //   {'rank': '10', 'title': '언제어디서나 반짝반짝한 은갈치슈트', 'image': 'exshirts'},
    // ];

    return SliverToBoxAdapter(
      child: Container(
        width: 1500,
        height: 170,
        margin: const EdgeInsets.fromLTRB(7, 8, 7, 0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // itemCount: cloList.length,
            itemCount: cloList.isNotEmpty ? cloList.length : 0,
            itemBuilder: (c, i) {
              return Container(
                width: 120,
                height: 150,
                margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectedIndex = i;
                            });

                            var accessToken =
                                context.read<UserStore>().accessToken;
                            print(accessToken);
                            Dio dio = Dio();
                            const serverURL = 'http://k9c105.p.ssafy.io:8761';

                            try {
                              // print('capturedImage path: ${capturedImage!}');
                              // print('capturedImage path: ${capturedImage!.path}');
                              print('어디까지 왔나');
                              Map<String, dynamic> headers = {};
                              if (accessToken.isNotEmpty) {
                                headers['Authorization'] =
                                    'Bearer $accessToken';
                              }

                              FormData formData = FormData.fromMap({
                                // "photoSeq": cloList[i].,
                                "clothSeq": cloList[i].clothSeq,
                              });

                              final response = await dio.post(
                                '$serverURL/api/photo/mix',
                                data: formData,
                                options: Options(
                                  headers: headers,
                                ), // 수정된 부분
                              );

                              print('디오요청완료');
                              print(response.data);
                              // var photoSeq = response.data['body'][i];

                              // print('포토시퀀스ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
                              // print(photoSeq);
                              // return response.data;
                            } catch (e) {
                              print('그밖의 에러ㅜㅜㅜㅜㅜㅜㅜㅜㅜ: $e');
                            } finally {}

                            print('완료');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: i == selectedIndex
                                  ? Border.all(
                                      color: const Color(0xFFF5BEB5),
                                      width: 3.0)
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:
                                  //  Image.asset(
                                  //   'Assets/Image/${ranking[i]['image']}.png',
                                  //   width: 100,
                                  //   height: 120,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  //     Image.network(
                                  //   cloList[i]['url'], // URL을 직접 사용
                                  //   width: 100,
                                  //   height: 120,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  Image.network(
                                cloList[i]['imgUrl'] ??
                                    'https://images.unsplash.com/photo-1551963831-b3b1ca40c98e',
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                      child: Text(
                        // ranking[i]['clothName']이 null이 아닌지 확인하고, 그에 따라 조건부 로직을 실행합니다.
                        '${cloList[i]['clothName'] != null && cloList[i]['clothName']!.length > 6 ? cloList[i]['clothName']!.substring(0, 6) : cloList[i]['clothName'] ?? ''}' // null일 경우 빈 문자열을 사용합니다.
                        '${cloList[i]['clothName'] != null && cloList[i]['clothName']!.length > 6 ? ".." : ""}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
