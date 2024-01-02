import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dio/dio.dart';
import 'package:flutter_mycloset/closet/tagsselect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';
import '../main.dart';

class ClothDetail extends StatefulWidget {
  const ClothDetail({
    super.key,
    this.storage,
    required this.clothSeq,
  });

  final storage;
  final clothSeq;

  @override
  State<ClothDetail> createState() => ClothDetailState();
}

class ClothDetailState extends State<ClothDetail> {
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

  var data = {};
  var tags = [];

  Future<dynamic> dioData(token) async {
    try {
      final response = await dio.get('$serverURL/api/cloth/${widget.clothSeq}',
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
        tags = result['tagList'];
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

  Future<dynamic> deleteCloth(token) async {
    try {
      final response = await dio.put('$serverURL/api/cloth/${widget.clothSeq}',
          // queryParameters: {'userEmail': id}
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      print('옷삭제 api ${response.data}');
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

  // void navigateTaglist(BuildContext context, String tagName) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => TagListPage(tagName: tagName)),
  //   );
  // }

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

  var imgUrl =
      'https://mblogthumb-phinf.pstatic.net/MjAxODEyMTlfMTcz/MDAxNTQ1MjA0MTk4NDQy.-lCTSpFhyK1yb6_e8FaFoZwZmMb_-rRZ04AnFmNijB4g.ID8x5cmkX8obTOxG8yoq39JRURXvKBPjbxY_z5M90bkg.JPEG.cine_play/707211_1532672215.jpg?type=w800';

  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5BEB5),
          toolbarHeight: 55,
          title: Text(
            '나의 옷',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          leading: const Text(''),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => Text('옷수정하는 창')));
                },
                icon: Icon(
                  Icons.border_color,
                  color: Color(0xFFfc6474),
                )),
            IconButton(
                onPressed: () {
                  deleteCloth(accessToken);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Main()),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: Color(0xFFfc6474),
                )),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          size: 40,
                          color: Color(0xFF54545b),
                        ),
                        onPressed: () {},
                      ),
                      Image.network(
                        data['clothRes']['imgUrl'],
                        width: 200,
                        height: 350,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          size: 40,
                          color: Color(0xFF54545b),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    data['clothRes']['clothName'],
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Color(0xFF54545b),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 40.0,
                        color: Color(0xFF54545b),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${data['clothRes']['closetName']} ${data['clothRes']['sectionName']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xFF54545b),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 75,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFF5BEB5),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xFFF5BEB5),
                    ),
                    child: Center(
                        child: Text(
                      '#${data['clothRes']['sort']}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: tags
                          .map((tag) => GestureDetector(
                                onTap: () {
                                  // navigateTaglist(context, tag);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TagsSelect(
                                            tagSeq: tag['tagSeq'],
                                            tagName: tag['tag'])),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFFF5BEB5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '#${tag['tag']}',
                                      style: TextStyle(
                                        color: Color(0xFFF5BEB5),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
