import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PageApi {
  final Dio dio = Dio(); // Dio HTTP 클라이언트 초기화
  final serverURL = 'http://k9c105.p.ssafy.io:8761';

  Future<dynamic> login(id, password) async {
    try {
      // final deviceToken = getMyDeviceToken();
      final response = await dio.post('$serverURL/api/member/login', data: {
        'memberId': id,
        'memberPw': password,
      });
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> checkid(id) async {
    try {
      final response = await dio.get('$serverURL/api/member/id/$id',
          // queryParameters: {'userEmail': id}
          );
      print(response.data['body']);
      return response.data['body'];
    } catch (e) {
      print(e);
    }
  }

    Future<dynamic> checkNick(nick) async {
    try {
      final response = await dio.get('$serverURL/api/member/nickname/$nick',
          // queryParameters: {'userEmail': id}
          );
      print(response.data['body']);
      return response.data['body'];
    } catch (e) {
      print(e);
    }
  }


  // Future<dynamic> sendEmail(id) async {
  //   try {
  //     final response = await dio
  //         .post('$serverURL/user/auth/sendEmail', data: {'userEmail': id});
  //     print(response.data);
  //     return response.data;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<dynamic> checkcode(id, code) async {
  //   try {
  //     final response = await dio.post('$serverURL/user/auth/checkEmail/$code',
  //         data: {'userEmail': id}, queryParameters: {'code': code});
  //     print('코드 확인 여부 ${response.data}');
  //     return response.data;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<dynamic> signup(
      nick, id, pw, email, phone, gender, birth) async {
    try {
      final response = await dio.post('$serverURL/api/member/sign-up', data: {
        'memberNickname': nick,
        'memberId': id,
        'memberPw': pw,
        'memberEmail': email,
        'memberPhone': phone,
        'memberGender': gender,
        'memberBirthYear': birth
      });
      print('회원가입 여부 ${response.data['result']['resultCode']}');
      return response.data['result']['resultCode'];
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getinfo(token) async {
    print(token);
    print(token.runtimeType);
    try {
      final response = await dio.get('$serverURL/api/member',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      print('개인정보 조회 ${response.data}');
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> updateuserinfo(
      token, nick, pw, pwc) async {
    try {
      final response = await dio.put('$serverURL/api/member',
          data: {
            'memberNickname':nick,
            'newPassword':pw,
            'newPasswordCheck':pwc
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      print('유저 정보 수정 ${response.data}');
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

//   Future<dynamic> findPassword(id, birth) async {
//     try {
//       final response = await dio.post('$serverURL/user/find/pwd',
//           data: {'userBirthday': birth, 'userEmail': id});
//       print('비밀번호 찾기 ${response.data}');
//       return response.data;
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<dynamic> changepassword(token, curpwd, nextpwd) async {
//     try {
//       final response = await dio.post('$serverURL/user/pwd',
//           data: {'curpassword': curpwd, 'nextpassword': nextpwd},
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
//               // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
//             },
//           ));
//       print('비밀번호 변경 ${response.data}');
//       return response.data;
//     } catch (e) {
//       print(e.toString());
//     }
//   }

  Future<dynamic> logout(token) async {
    try {
      final response = await dio.delete('$serverURL/api/member/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      print('로그아웃 api ${response.data}');
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> tokenValidation(token) async {
    try {
      final response = await dio.post('$serverURL/api/member/auth/checktoken',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      print('토큰유효 api ${response.data}');
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> deleteuser(token) async {
    try {
      final response = await dio.put('$serverURL/api/member/delete',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // 토큰을 'Bearer' 스타일로 포함
              // 다른 헤더도 필요한 경우 여기에 추가할 수 있습니다.
            },
          ));
      print('회원탈퇴 api ${response.data}');
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
