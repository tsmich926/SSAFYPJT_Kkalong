import 'package:flutter/material.dart';
import '../closet/clothdetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';

class CategoryClothList extends StatefulWidget {
  const CategoryClothList({super.key, this.storage, required this.category});

  final storage;
  final int category;

  @override
  State<CategoryClothList> createState() => _CategoryClothListState();
}

class _CategoryClothListState extends State<CategoryClothList> {
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
  List<String> sort = ['Top', 'Pants', 'Outer', 'Skirt', 'Dress', 'Etc'];

  var imgUrl =
      'https://mblogthumb-phinf.pstatic.net/MjAxODEyMTlfMTcz/MDAxNTQ1MjA0MTk4NDQy.-lCTSpFhyK1yb6_e8FaFoZwZmMb_-rRZ04AnFmNijB4g.ID8x5cmkX8obTOxG8yoq39JRURXvKBPjbxY_z5M90bkg.JPEG.cine_play/707211_1532672215.jpg?type=w800';
  var fashionSeq = 0;
  var fashionName = '';
  var data = [];

  Future<dynamic> dioData(token) async {
    try {
      final response =
          await dio.get('$serverURL/api/cloth/sort/${sort[widget.category]}',
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
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
            child: Column(
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
    );
  }
}
