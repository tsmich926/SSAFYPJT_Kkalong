import 'package:flutter/material.dart';
import 'package:flutter_mycloset/avata/loadingna.dart';
import '../avata/clothslide.dart';
import 'package:image_picker/image_picker.dart';
import '../avata/namedavata.dart';

// import 'package:flutter_mycloset/category/categoryselect.dart';

class ChoiceCloth extends StatefulWidget {
  final int photoSeq;
  final String? imageUrl;
  final String sortName;

  const ChoiceCloth(
      {super.key,
      this.storage,
      required this.photoSeq,
      required this.imageUrl,
      required this.sortName});

  final storage;

  @override
  State<ChoiceCloth> createState() => ChoiceClothState();
}

class ChoiceClothState extends State<ChoiceCloth> {
  @override
  void initState() {
    super.initState();
    // 초기화 작업 수행
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
              '깔롱의 옷입히기',
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                        child: Image.asset(
                          'Assets/Image/TShirt.png',
                          width: 70.0,
                          height: 70.0,
                        ),
                        //  child: Image.network(
                        //     widget.imageUrl ?? "Assets/Image/logo.png",
                        //     height: 125,
                        //     width: 180,
                        //     errorBuilder: (context, error, stackTrace) {
                        //       return Image.asset(
                        //         "Assets/Image/logo.png",
                        //         height: 125,
                        //         width: 180,
                        //       );
                        //     },
                        //     loadingBuilder: (BuildContext context, Widget child,
                        //         ImageChunkEvent? loadingProgress) {
                        //       if (loadingProgress == null) return child;
                        //       return Center(
                        //         child: CircularProgressIndicator(
                        //           value: loadingProgress.expectedTotalBytes !=
                        //                   null
                        //               ? loadingProgress.cumulativeBytesLoaded /
                        //                   loadingProgress.expectedTotalBytes!
                        //               : null,
                        //         ),
                        //       );
                        //     },
                        //   )
                      ),
                      // const Text(
                      //   'Top',
                      //   style: TextStyle(
                      //     fontSize: 22,
                      //     color: Color.fromARGB(255, 0, 0, 0),
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      Text(
                        widget.sortName,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                ),
              ],
            ),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          //   sliver: SliverGrid(
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 1,
          //       crossAxisSpacing: 20.0,
          //       mainAxisSpacing: 20.0,
          //     ),
          //     delegate: SliverChildBuilderDelegate(
          //       (BuildContext context, int index) {
          //         final item = nookie['list']?[index];
          //         if (item == null) {
          //           return const SizedBox(); // 빈 위젯 반환
          //         }
          //         return GestureDetector(
          //           onTap: () {
          //             print(widget.photoSeq);
          //           },
          //           child: Container(
          //             color: const Color.fromARGB(255, 251, 235, 233),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: <Widget>[
          //                 Image.asset(
          //                   item["image"] ?? "Assets/Image/logo.png",
          //                   height: 125,
          //                   width: 180,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //       childCount: nookie['list']?.length ?? 0,
          //     ),
          //   ),
          // ),

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
                    widget.imageUrl ?? "Assets/Image/logo.png",
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
              padding: const EdgeInsets.fromLTRB(30, 2, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 12),
                    child: Text(
                      '옷선택',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF5BEB5),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30, 1, 10, 10),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                          foregroundColor:
                              const Color.fromARGB(255, 232, 170, 170),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 232, 170, 170),
                              width:
                                  1.0), // Adjusting border color and thickness
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0), // 원하는 각진 정도로 설정
                          ),
                          // 다른 스타일 속성들
                        ),
                        child: const Text(
                          '+ 다른 옷',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 1, 20, 10),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NamedAvata()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5BEB5),
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xFFF5BEB5), width: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // 원하는 각진 정도로 설정
                        ),
                        // 다른 스타일 속성들
                      ),
                      child: const Text(
                        ' 저장 ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ClothSlide(sortName: widget.sortName)
        ],
      ),
    );
  }
}
