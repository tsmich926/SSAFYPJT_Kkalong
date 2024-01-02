// import 'package:dio/dio.dart';
// import './wearcloth.dart';
// import 'package:http_parser/http_parser.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// //카메라
// import 'package:camera/camera.dart';
// import 'package:image/image.dart' as img;
// import 'package:flutter_mycloset/avata/choicepicture.dart';
// import 'package:provider/provider.dart';
// import '../store/userstore.dart';

// // import '../avata/wearcloth.dart';

// class AvataPicture extends StatefulWidget {
//   const AvataPicture({super.key});

//   @override
//   _AvataPictureState createState() => _AvataPictureState();
// }

// class _AvataPictureState extends State<AvataPicture> {
//   late CameraController _controller;
//   late List<CameraDescription> cameras;
//   bool isInitialized = false;
//   File? capturedImage;

//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }

//   Future<void> initCamera() async {
//     cameras = await availableCameras();
//     _controller = CameraController(cameras[0], ResolutionPreset.medium);
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         isInitialized = true;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // String token = Provider.of<UserStore>(context, listen: false).accessToken;
//     // print('가져온 토큰!!!!!!!!!!!!출력!!!!!!!!!!: $token');

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 254),
//       body: Stack(
//         children: [
//           isInitialized
//               ? SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height * 0.95,
//                   child: CameraPreview(_controller),
//                 )
//               // ? FittedBox(
//               //     fit: BoxFit.cover,
//               //     child: SizedBox(
//               //       width: _controller.value.previewSize!.height,
//               //       height: _controller.value.previewSize!.width,
//               //       child: CameraPreview(_controller),
//               //     ),
//               //   )
//               : const Center(child: CircularProgressIndicator()),

//           // Display captured image
//           capturedImage != null
//               ? SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height * 0.95,
//                   child: Image.file(capturedImage!, fit: BoxFit.cover),
//                 )
//               : Container(),
//           // ? Image.file(capturedImage!, fit: BoxFit.cover)
//           // : Container(),

//           // capturedImage == null
//           //     ? Positioned.fill(
//           //         child: Opacity(
//           //           opacity: 1,
//           //           child: Image.asset(
//           //             'Assets/Image/guide.png',
//           //             fit: BoxFit.cover,
//           //           ),
//           //         ),
//           //       )
//           //     : Container(),
//           capturedImage == null
//               ?
//               // Align(
//               //     alignment: Alignment.center,
//               //     child: Opacity(
//               //       opacity: 1,
//               //       child: Image.asset(
//               //         'Assets/Image/guide.png',
//               //         width: 700.0,
//               //         height: 800.0,
//               //       ),
//               //     ),
//               //   )
//               //가이드라인이미지 가운데 정렬
//               Align(
//                   // alignment: Alignment.center,
//                   alignment: const Alignment(0, 3.0),
//                   child: Container(
//                     width: 600.0,
//                     height: 700.0,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('Assets/Image/guide.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             capturedImage == null
//                 ? buildCaptureButton()
//                 : buildSaveAndRetakeButtons(),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildCaptureButton() {
//     return SizedBox(
//       width: 400,
//       child: ElevatedButton(
//         onPressed: () async {
//           if (isInitialized) {
//             final image = await _controller.takePicture();

//             setState(() {
//               capturedImage = File(image.path);
//             });
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFFF5BEB5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//         child: const Text(
//           '사진찍기',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildSaveAndRetakeButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () async {
//             setState(() {
//               capturedImage = null;
//             });

//             // if (isInitialized) {
//             //   final image = await _controller.takePicture();
//             //   setState(() {
//             //     capturedImage = File(image.path);
//             //   });
//             // }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFF5BEB5),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//           ),
//           child: const Text(
//             '다시찍기↺',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if (capturedImage != null) {
//               var accessToken = context.read<UserStore>().accessToken;
//               print(accessToken);
//               // img.Image resizedImage = img.copyResize(originalImage, width: 600, height: 400);

//               Dio dio = Dio();
//               const serverURL = 'http://k9c105.p.ssafy.io:8761';
//               try {
//                 print('capturedImage path: ${capturedImage!}');
//                 print('capturedImage path: ${capturedImage!.path}');
//                 FormData formData = FormData.fromMap({
//                   "multipartFile": await MultipartFile.fromFile(
//                       capturedImage!.path,
//                       contentType: MediaType('image', 'jpeg')),
//                 });
//                 print('어디까지 왔나');
//                 Map<String, dynamic> headers = {};
//                 if (accessToken.isNotEmpty) {
//                   headers['Authorization'] = 'Bearer $accessToken';
//                   headers['Content-Type'] = 'multipart/form-data';
//                 }

//                 final response = await dio.post(
//                   '$serverURL/api/photo',
//                   data: formData,
//                   options: Options(
//                     headers: headers,
//                   ), // 수정된 부분
//                 );

//                 print('디오요청완료');
//                 print(response.data);
//                 var photoSeq = response.data['body']['photoSeq'];

//                 print('포토시퀀스ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
//                 print(photoSeq);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => WearCloth(photoSeq: photoSeq)),
//                 );
//                 return response.data;
//               } catch (e) {
//                 print('그밖의 에러ㅜㅜㅜㅜㅜㅜㅜㅜㅜ: $e');
//               } finally {}
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFF5BEB5),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//           ),
//           child: const Text(
//             '저장하기📁',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:dio/dio.dart';
import './wearcloth.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:flutter/material.dart';
//카메라
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_mycloset/avata/choicepicture.dart';
import 'package:path_provider/path_provider.dart'; // 파일 시스템 접근을 위한 패키지

import 'package:provider/provider.dart';
import '../store/userstore.dart';

// import '../avata/wearcloth.dart';

class AvataPicture extends StatefulWidget {
  const AvataPicture({super.key});

  @override
  _AvataPictureState createState() => _AvataPictureState();
}

class _AvataPictureState extends State<AvataPicture> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool isInitialized = false;
  File? capturedImage;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String token = Provider.of<UserStore>(context, listen: false).accessToken;
    // print('가져온 토큰!!!!!!!!!!!!출력!!!!!!!!!!: $token');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 254),
      body: Stack(
        children: [
          isInitialized
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: CameraPreview(_controller),
                )
              // ? FittedBox(
              //     fit: BoxFit.cover,
              //     child: SizedBox(
              //       width: _controller.value.previewSize!.height,
              //       height: _controller.value.previewSize!.width,
              //       child: CameraPreview(_controller),
              //     ),
              //   )
              : const Center(child: CircularProgressIndicator()),

          // Display captured image
          capturedImage != null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Image.file(capturedImage!, fit: BoxFit.cover),
                )
              : Container(),
          // ? Image.file(capturedImage!, fit: BoxFit.cover)
          // : Container(),

          // capturedImage == null
          //     ? Positioned.fill(
          //         child: Opacity(
          //           opacity: 1,
          //           child: Image.asset(
          //             'Assets/Image/guide.png',
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       )
          //     : Container(),
          capturedImage == null
              ?
              // Align(
              //     alignment: Alignment.center,
              //     child: Opacity(
              //       opacity: 1,
              //       child: Image.asset(
              //         'Assets/Image/guide.png',
              //         width: 700.0,
              //         height: 800.0,
              //       ),
              //     ),
              //   )
              //가이드라인이미지 가운데 정렬
              Align(
                  // alignment: Alignment.center,
                  alignment: const Alignment(0, 3.0),
                  child: Container(
                    width: 600.0,
                    height: 700.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Assets/Image/guide.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            capturedImage == null
                ? buildCaptureButton()
                : buildSaveAndRetakeButtons(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildCaptureButton() {
    return SizedBox(
      width: 400,
      child: ElevatedButton(
        onPressed: () async {
          if (isInitialized) {
            final XFile rawimage = await _controller.takePicture();
            img.Image originalImage =
                img.decodeImage(File(rawimage.path).readAsBytesSync())!;

            // 이미지 크기 조정
            img.Image resizedImage =
                img.copyResize(originalImage, width: 768, height: 1024);

            // 조정된 이미지 임시 저장
            final Directory tempDir = await getTemporaryDirectory();
            final String imagePath = '${tempDir.path}/resized_image.jpg';
            File(imagePath).writeAsBytesSync(img.encodeJpg(resizedImage));

            // 조정된 이미지로 상태 업데이트
            setState(() {
              capturedImage = File(imagePath);
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5BEB5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Text(
          '사진찍기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget buildSaveAndRetakeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            setState(() {
              capturedImage = null;
            });

            // if (isInitialized) {
            //   final image = await _controller.takePicture();
            //   setState(() {
            //     capturedImage = File(image.path);
            //   });
            // }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5BEB5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: const Text(
            '다시찍기↺',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (capturedImage != null) {
              var accessToken = context.read<UserStore>().accessToken;
              print(accessToken);
              // img.Image resizedImage = img.copyResize(originalImage, width: 600, height: 400);

              Dio dio = Dio();
              const serverURL = 'http://k9c105.p.ssafy.io:8761';
              try {
                print('capturedImage path: ${capturedImage!}');
                print('capturedImage path: ${capturedImage!.path}');
                FormData formData = FormData.fromMap({
                  "multipartFile": await MultipartFile.fromFile(
                      capturedImage!.path,
                      contentType: MediaType('image', 'jpeg')),
                });
                print('어디까지 왔나');
                Map<String, dynamic> headers = {};
                if (accessToken.isNotEmpty) {
                  headers['Authorization'] = 'Bearer $accessToken';
                  headers['Content-Type'] = 'multipart/form-data';
                }

                final response = await dio.post(
                  '$serverURL/api/photo',
                  data: formData,
                  options: Options(
                    headers: headers,
                  ), // 수정된 부분
                );

                print('디오요청완료');
                print(response.data);
                var photoSeq = response.data['body']['photoSeq'];

                print('포토시퀀스ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ');
                print(photoSeq);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WearCloth(photoSeq: photoSeq)),
                );
                return response.data;
              } catch (e) {
                print('그밖의 에러ㅜㅜㅜㅜㅜㅜㅜㅜㅜ: $e');
              } finally {}
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5BEB5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: const Text(
            '저장하기📁',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
