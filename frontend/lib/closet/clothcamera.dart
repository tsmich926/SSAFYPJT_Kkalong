import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_mycloset/closet/clothinfo.dart';

class ClothCamera extends StatefulWidget {
  const ClothCamera({super.key});

  @override
  _ClothCameraState createState() => _ClothCameraState();
}

class _ClothCameraState extends State<ClothCamera> {
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
              : const Center(child: CircularProgressIndicator()),
          capturedImage != null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Image.file(capturedImage!, fit: BoxFit.cover),
                )
              : Container(),
          capturedImage == null
              ? Align(
                  alignment: const Alignment(0, 3.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      width: 600.0,
                      height: 700.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('Assets/Image/topguide.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
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
            final image = await _controller.takePicture();
            setState(() {
              capturedImage = File(image.path);
              String filePath = image.path;
              String fileExtension = filePath.split('.').last; // 파일 확장자를 추출합니다.
              print(fileExtension);
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClothInfo(image: capturedImage)),
            );
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
