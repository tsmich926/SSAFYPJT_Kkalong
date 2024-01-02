import 'package:flutter/material.dart';
import 'package:flutter_mycloset/closet/clothinfo.dart';
import 'package:image_picker/image_picker.dart';
import './categorycloth.dart';
import '../closet/closetcloth.dart';
import '../closet/clothcamera.dart';

class CategorySelect extends StatefulWidget {
  const CategorySelect({super.key, required this.category});

  final int category;

  @override
  State<CategorySelect> createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 6,
          initialIndex: widget.category,
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  title: const Text(
                    '씅쑤신다람쥐의 옷장',
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
                SliverPersistentHeader(
                  delegate: MyDelegate(const TabBar(
                      labelColor: Colors.black,
                      indicatorWeight: 6,
                      unselectedLabelColor: Color(0xffD0D0D0),
                      labelPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      indicatorColor: Color.fromARGB(255, 68, 25, 80),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Text('Top'),
                        Text('Pants'),
                        Text('Outer'),
                        Text('Skirts'),
                        Text('Dress'),
                        Text('Etc'),
                      ])),
                  floating: true,
                  pinned: true,
                )
              ];
            },
            body: TabBarView(children: [
              CategoryClothList(category: 0),
              CategoryClothList(category: 1),
              CategoryClothList(category: 2),
              CategoryClothList(category: 3),
              CategoryClothList(category: 4),
              CategoryClothList(category: 5),
            ]),
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
        // floatingActionButton: ElevatedButton(
        //   onPressed: () {
        //     print('여기까지 잘왔니??????');
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const ClothCamera()),
        //     );
        //   },
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.grey[50],
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20.0), // 원하는 각진 정도로 설정
        //     ),
        //     // 다른 스타일 속성들
        //   ),
        //   child: const Text(' + 옷등록'),
        // ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.grey[50],
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
