import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../store/userstore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // MediaType을 사용하기 위해 추가

class ClothInfo extends StatefulWidget {
  const ClothInfo({
    super.key,
    this.storage,
    required this.image,
  });

  final storage;
  final image;

  @override
  State<ClothInfo> createState() => ClothInfoState();
}

class ClothInfoState extends State<ClothInfo> {
  static final storage = FlutterSecureStorage();
  String? accessToken;

  @override
  void initState() {
    super.initState();
    final userStore = Provider.of<UserStore>(context, listen: false);
    accessToken = userStore.accessToken;
  }

  final Dio dio = Dio(); // Dio HTTP 클라이언트 초기화
  final serverURL = 'http://k9c105.p.ssafy.io:8761';

  final TextEditingController inputController = TextEditingController();
  final TextEditingController inputController2 = TextEditingController();
  final List<String> tags = [];

  final List<String> closets = [
    '공주옷장',
    '할머니옷장',
    '아재옷장',
  ];
  String? selectedCloset;

  final List<String> sections = [
    '행거1',
    '행거2',
    '수납장1',
    '선반1',
    '선반2',
    '박스1',
  ];
  String? selectedSection;

  final List<String> clothes = [
    'Top',
    'Pants',
    'Outer',
    'Skirts',
    'Dress',
    'Etc',
  ];
  String? selectedCloth;

  // 항목을 추가하는 메소드
  void _addItem() {
    setState(() {
      String tagText = inputController2.text;

      if (tagText.isNotEmpty) {
        setState(() {
          tags.add(tagText);
        });
        inputController2.clear();
      }
    });
  }

  // 항목을 제거하는 메소드
  void _removeItem(int index) {
    setState(() {
      if (tags.isNotEmpty) {
        tags.removeAt(index);
      }
    });
  }

  //  데이터 보내는 함수
  var data = [];
  Future<dynamic> sendData(token) async {
    Response response;

    // 파일을 MultipartFile 형식으로 변환
    var file = await MultipartFile.fromFile(widget.image.path,
        contentType: MediaType('image', 'jpeg'));

    // JSON 데이터와 파일을 포함하는 FormData 생성
    FormData formData = FormData.fromMap({
      "mFile": file,
      "request": {
        "sectionSeq": 0,
        "sort": selectedCloth,
        "clothName": inputController.text,
        "tagList": tags,
        "private": true
      }
    });

    try {
      // final deviceToken = getMyDeviceToken();
      final response = await dio.post('$serverURL/api/cloth',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
              'Content-Type': 'multipart/form-data',
            },
          ),
          data: formData);
      print("Response: ${response.data}");
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

  // 리스트에 저장된 항목을 바탕으로 위젯을 생성하는 함수
  List<Widget> _buildItemList() {
    return tags.asMap().entries.map((entry) {
      int index = entry.key;
      String tag = entry.value;

      return GestureDetector(
        onTap: () => _removeItem(index),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFF5BEB5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Text(
              '#$tag X',
              style: TextStyle(
                color: Color(0xFFF5BEB5),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5BEB5),
          toolbarHeight: 55,
          title: const Text(
            '나의 옷',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          leading: const Text(''),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.file(
                      File(widget.image.path),
                      width: 200,
                      height: 300,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: inputController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: Color(0xFFF5BEB5))),
                            border: OutlineInputBorder(),
                            labelText: '옷이름',
                            focusColor: Color(0xFFF5BEB5)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 8,
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFF5BEB5)), // 포커스가 있을 때의 테두리 색상을 보라색으로 설정
                            ),
                            // Add more decoration..
                          ),
                          hint: const Text(
                            '옷장',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: closets
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return '옷장을 선택해주세요.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                          },
                          onSaved: (value) {
                            setState(() {
                              selectedCloset = value.toString();
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            maxHeight: 200,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      Flexible(fit: FlexFit.tight, flex: 1, child: SizedBox()),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 12,
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFF5BEB5)), // 포커스가 있을 때의 테두리 색상을 보라색으로 설정
                            ),
                            // Add more decoration..
                          ),
                          hint: const Text(
                            '옷장 세부구역',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: sections
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return '세부구역을 선택해주세요.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                          },
                          onSaved: (value) {
                            selectedSection = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            maxHeight: 200,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                      // the menu padding when button's width is not specified.
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(
                                0xFFF5BEB5)), // 포커스가 있을 때의 테두리 색상을 보라색으로 설정
                      ),
                      // Add more decoration..
                    ),
                    hint: const Text(
                      '옷 종류',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: clothes
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return '옷 종류를 선택해주세요.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      //Do something when selected item is changed.
                    },
                    onSaved: (value) {
                      selectedCloth = value.toString();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inputController2,
                            autofocus: true,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 40.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color(0xFFF5BEB5),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              labelText: '기타 태그',
                              focusColor: Color(0xFFF5BEB5),
                            ),
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          width: 20, // 중복 확인 버튼과 아이디 입력창 사이의 간격 설정
                        ),
                        SizedBox(
                          width: 90,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              _addItem();
                              // 태그 추가 수행하는 코드 추가
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5.0), // 각진 정도 조절
                              ),
                              side: const BorderSide(
                                color: Color(0xFFF5BEB5), // 외곽선 색상 설정
                                width: 1, // 외곽선 두께 설정
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0.2, 0.2, 0.2, 0.2),
                              child: Text(
                                '태그 추가',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFF5BEB5), // 글자 색상 설정
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildItemList(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ButtonTheme(
                          child: TextButton(
                              onPressed: () async {
                                sendData(accessToken);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // 원하는 각진 정도로 설정
                                ),
                                backgroundColor: const Color(0xFFF5BEB5),
                              ),
                              child: const SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '등록하기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
