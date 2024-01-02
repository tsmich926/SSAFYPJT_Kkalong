import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';

class Swipe extends StatefulWidget {
  const Swipe({
    super.key,
    this.storage,
  });

  final storage;

  @override
  State<Swipe> createState() => SwipeState();
}

class SwipeState extends State<Swipe> {
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
  var imgUrl =
      'https://mblogthumb-phinf.pstatic.net/MjAxODEyMTlfMTcz/MDAxNTQ1MjA0MTk4NDQy.-lCTSpFhyK1yb6_e8FaFoZwZmMb_-rRZ04AnFmNijB4g.ID8x5cmkX8obTOxG8yoq39JRURXvKBPjbxY_z5M90bkg.JPEG.cine_play/707211_1532672215.jpg?type=w800';
  var fashionSeq = 0;
  var fashionName = '';

  Future<dynamic> dioData(token) async {
    try {
      final response = await dio.get('$serverURL/api/assess',
          // queryParameters: {'userEmail': id}
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      var result = response.data['body'][0];
      setState(() {
        imgUrl = result['imgUrl'];
        fashionSeq = result['fashionSeq'];
        fashionName = result['fashionName'];
      });
      print(imgUrl);
      return response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        // DioError를 확인
        _showErrorDialog('오류 발생: ${e.response?.statusCode}\n더이상 평가할 사진이 없습니다!');
      } else {
        _showErrorDialog('더이상 평가할 사진이 없습니다!');
      }
    }
  }

  Future<dynamic> likeData(token) async {
    Response response;
    try {
      // final deviceToken = getMyDeviceToken();
      final response = await dio.post('$serverURL/api/assess',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ),
          data: {
            'fashionSeq': fashionSeq,
            'like': true,
          });
      return response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        // DioError를 확인
        _showErrorDialog('오류 발생: ${e.response?.statusCode}\n더이상 평가할 사진이 없습니다!');
      } else {
        _showErrorDialog('더이상 평가할 사진이 없습니다!');
      }
    }
  }

  Future<dynamic> hateData(token) async {
    Response response;
    try {
      // final deviceToken = getMyDeviceToken();
      final response = await dio.post('$serverURL/api/assess',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ),
          data: {
            'fashionSeq': fashionSeq,
            'like': false,
          });
      return response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        // DioError를 확인
        _showErrorDialog('오류 발생: ${e.response?.statusCode}\n더이상 평가할 사진이 없습니다!');
      } else {
        _showErrorDialog('더이상 평가할 사진이 없습니다!');
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
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Color(0xFFF5BEB5),
            expandedHeight: 55.0,
            floating: true,
            pinned: true,
            title: Text(
              '코디 평가',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0,
            leading: Text(''),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      fashionName,
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
                      '님의 코디',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ])),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.chevron_left,
                                size: 40,
                                color: Color(0xFF54545b),
                              ),
                              Expanded(
                                child: Center(
                                  child: Dismissible(
                                    key: Key(imgUrl),
                                    onDismissed: (direction) {
                                      final previousImgUrl = imgUrl;

                                      // 오른쪽에서 왼쪽으로 스와이프한 경우 싫어요
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        hateData(accessToken);
                                      }
                                      // 왼쪽에서 오른쪽으로 스와이프한 경우 좋아요
                                      else if (direction ==
                                          DismissDirection.startToEnd) {
                                        likeData(accessToken);
                                      }
                                      dioData(accessToken);
                                    },
                                    child: Card(
                                      child: Container(
                                        height: 300,
                                        width: 200,
                                        alignment: Alignment.center,
                                        child: Image.network(
                                          imgUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 40,
                                color: Color(0xFF54545b),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Image.asset('Assets/Image/swipe.png'),
                        ),
                      ],
                    )),
              )),
        ],
      ),
    );
  }
}
