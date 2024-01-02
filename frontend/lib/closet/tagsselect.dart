import 'package:flutter/material.dart';
import 'package:flutter_mycloset/closet/clothcamera.dart';
import 'package:flutter_mycloset/closet/clothdetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';

class TagsSelect extends StatefulWidget {
  const TagsSelect({
    super.key,
    this.storage,
    required this.tagSeq,
    required this.tagName,
  });

  final storage;
  final tagSeq;
  final tagName;

  @override
  State<TagsSelect> createState() => _TagsSelectState();
}

class _TagsSelectState extends State<TagsSelect> {
  final ScrollController scrollController = ScrollController();
  static final storage = FlutterSecureStorage();
  String? accessToken;

  @override
  void initState() {
    super.initState();
    final userStore = Provider.of<UserStore>(context, listen: false);
    accessToken = userStore.accessToken;
    dioData(accessToken);
  }

  final TextEditingController inputController = TextEditingController();
  final Dio dio = Dio(); // Dio HTTP 클라이언트 초기화
  final serverURL = 'http://k9c105.p.ssafy.io:8761';

  var data = [];

  Future<dynamic> dioData(token) async {
    try {
      final response =
          await dio.get('$serverURL/api/cloth/tag/${widget.tagSeq}',
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          '태그별 조회',
          style: TextStyle(color: Colors.white), // 텍스트의 색상을 흰색으로 설정
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 212, 206),
        iconTheme: const IconThemeData(color: Colors.black),
        // collapsedHeight: 325,
        // expandedHeight: 325,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(4, 0, 4, 10),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFF5BEB5),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Text(
                      '#${widget.tagName}',
                      style: TextStyle(
                        color: Color(0xFFF5BEB5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        // 클릭 이벤트 -> 옷상세로 넘어가게 할거임..
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClothDetail(
                                  clothSeq: data[index]['clothSeq'])),
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClothCamera()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // 원하는 각진 정도로 설정
          ),
          // 다른 스타일 속성들
        ),
        child: const Text(' + 옷등록'),
      ),
    ));
  }
}
