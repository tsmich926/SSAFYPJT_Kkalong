import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mycloset/avata/choicecloth.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';

// import 'package:flutter_mycloset/category/categoryselect.dart';

class WearCloth extends StatefulWidget {
  final int photoSeq;
  // WearCloth({super.key, this.storage});
  WearCloth({super.key, this.storage, required this.photoSeq});

  final storage;

  @override
  State<WearCloth> createState() => WearClothState();
}

class WearClothState extends State<WearCloth> {
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    // 초기화 작업 수행
    loadImageUrl();
  }

  void loadImageUrl() async {
    var accessToken = context.read<UserStore>().accessToken;
    print(accessToken);
    Map<String, dynamic> headers = {};
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      print('photoSeq출력ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ: ${widget.photoSeq}');
      print('특정이미지 출력할수있을까');
      var response = await Dio().get(
        'http://k9c105.p.ssafy.io:8761/api/photo/${widget.photoSeq}',
        options: Options(
          headers: headers,
        ),
      );
      print('특정이미지 요청완료');
      print('내가 response를 뽑아볼게뿅');
      print(response.data);
      var url = response.data['body']['url'];
      print('내가 url을 뽑아볼게뿅');
      print(url);
      setState(() {
        print('url을 imageUrl에 넣어볼게');
        imageUrl = url;
        print(imageUrl);
      });
    } catch (e) {
      print('이미지 로드 중 에러!!!!!!!!!!!');
      print(e.toString());
    }
  }

  final savecloset = {
    "list": [
      {"image": "Assets/Image/TShirt.png"},
    ]
  };

  final clomenue = {
    "list": [
      {"image": "Assets/Image/TShirt.png", "name": "Top"},
      {"image": "Assets/Image/Pants.png", "name": "Pants"},
      {"image": "Assets/Image/Suit.png", "name": "Outer"},
      {"image": "Assets/Image/Skirt.png", "name": "Skirts"},
      {"image": "Assets/Image/Dress.png", "name": "Dress"},
      {"image": "Assets/Image/Ellipsis.png", "name": "ect"},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 254),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Color(0xFFF5BEB5),
            expandedHeight: 55.0,
            floating: true,
            pinned: true,
            title: Text(
              '깔롱의 변신',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0,
            leading: Text(''),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                AppBar(
                  toolbarHeight: 55,
                  centerTitle: true,
                  title: const Text(
                    '어떤 옷을 입어보시겠어요?',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 1, 20, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = savecloset['list']?[index];
                  if (item == null) {
                    return const SizedBox(); // 빈 위젯 반환
                  }
                  return
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     color: const Color.fromARGB(255, 251, 235, 233),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Image.asset(
                      //           item["image"] ?? "Assets/Image/logo.png",
                      //           height: 125,
                      //           width: 180,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                      Image.network(
                    imageUrl ?? "Assets/Image/logo.png",
                    height: 125,
                    width: 180,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "Assets/Image/logo.png",
                        height: 125,
                        width: 180,
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  );
                },
                childCount: savecloset['list']?.length ?? 0,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 10, 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 400,
                    child: Text(
                      '옷종류',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List<Widget>.from(
                          (clomenue["list"] ?? []).map<Widget>((item) {
                        return GestureDetector(
                          onTap: () {
                            String sortName = item["name"] ?? 'Unknown';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChoiceCloth(
                                      photoSeq: widget.photoSeq,
                                      imageUrl: imageUrl,
                                      sortName: sortName)),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                item["image"] ?? 'Assets/Image/logo.png',
                                width: 60,
                                height: 100,
                              ),
                              const SizedBox(height: 5),
                              Text(item["name"] ?? 'Unknown'),
                            ],
                          ),
                        );
                      })),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
