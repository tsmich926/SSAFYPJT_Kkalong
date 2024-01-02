import 'package:flutter/material.dart';
// import 'package:flutter_mycloset/category/categoryselect.dart';
import './categoryselect.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    this.storage,
  });

  final storage;

  @override
  State<CategoryPage> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    // 초기화 작업 수행
  }

  final savecloset = {
    "list": [
      {"image": "Assets/Image/TShirt.png", "name": "Top"},
      {"image": "Assets/Image/Pants.png", "name": "Pants"},
      {"image": "Assets/Image/Suit.png", "name": "Outer"},
      {"image": "Assets/Image/Skirt.png", "name": "Skirts"},
      {"image": "Assets/Image/Dress.png", "name": "Dress"},
      {"image": "Assets/Image/Ellipsis.png", "name": "Etc"},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 198, 197),
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
                AppBar(
                  toolbarHeight: 55,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                    onPressed: () {},
                  ),
                  backgroundColor: const Color.fromARGB(255, 251, 235, 233),
                  centerTitle: true,
                  title: const Text(
                    'Category',
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.fromLTRB(2, 2, 2, 1),
          //   sliver: SliverGrid(
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 2.0,
          //       mainAxisSpacing: 2.0,
          //     ),
          //     delegate: SliverChildBuilderDelegate(
          //       (BuildContext context, int index) {
          //         final item = savecloset['list']?[index];
          //         if (item == null) {
          //           return const SizedBox(); // 빈 위젯 반환
          //         }
          //         return GestureDetector(
          //           onTap: () {
          //             // 클릭이벤트
          //           },
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               Image.asset(
          //                 item["image"] ?? "Assets/Image/logo.png",
          //                 height: 120,
          //                 width: 180,
          //               ),
          //               Text(
          //                 item["name"] ?? "Unknown",
          //                 style: const TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //       childCount: savecloset['list']?.length ?? 0,
          //     ),
          //   ),
          // ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = savecloset['list']?[index];
                  if (item == null) {
                    return const SizedBox();
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySelect(category: index)),
                      );
                    },
                    child: Container(
                      color: const Color.fromARGB(
                          255, 251, 235, 233), // "점선"의 색상입니다.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            item["image"] ?? "Assets/Image/logo.png",
                            height: 125,
                            width: 180,
                          ),
                          Text(
                            item["name"] ?? "Unknown",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: savecloset['list']?.length ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
