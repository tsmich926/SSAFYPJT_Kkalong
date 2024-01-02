import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(bottom: 2, top: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  spreadRadius: 0.0,
                  offset: const Offset(0, -0.5))
            ]),
        child: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            labelColor: Color(0xFFF5BEB5),
            labelStyle: TextStyle(fontSize: 12),
            unselectedLabelColor: Color(0xffCACACA),
            tabs: [
              Tab(
                icon: Icon(Icons.accessibility),
                text: '아바타',
              ),
              Tab(
                icon: Icon(
                  Icons.space_dashboard_outlined,
                ),
                text: '옷장',
              ),
              Tab(
                icon: Icon(Icons.menu),
                text: '카테고리',
              ),
              Tab(
                icon: Icon(Icons.checkroom),
                text: '코디평가',
              ),
              Tab(
                icon: Icon(Icons.perm_identity),
                text: '내프로필',
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 1.0),
              //   child: Tab(
              //     icon: Icon(Icons.accessibility),
              //     text: '아바타',
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 1.0),
              //   child: Tab(
              //     icon: Icon(
              //       Icons.space_dashboard_outlined,
              //     ),
              //     text: '옷장',
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 1.0),
              //   child: Tab(
              //     icon: Icon(Icons.menu),
              //     text: '카테고리',
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 1.0),
              //   child: Tab(
              //     icon: Icon(Icons.checkroom),
              //     text: '코디평가',
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 1.0),
              //   child: Tab(
              //     icon: Icon(Icons.perm_identity),
              //     text: '내프로필',
              //   ),
              // ),
            ]),
      ),
    );
  }
}
