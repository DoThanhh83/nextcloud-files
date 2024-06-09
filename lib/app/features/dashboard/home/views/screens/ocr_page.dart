import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/webdav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

class OCRPage extends StatefulWidget {
  const OCRPage({super.key, required this.title, required this.client});

  final String title;
  final NextcloudClient client;

  @override
  State<OCRPage> createState() => _MyHomePageState();
}

// class _MyHomePageState extends State<OCRPage> {
//   String text = "";
//   late NextcloudClient client;
//   final StreamController<String> controller = StreamController<String>();
//   File? localFile;
//   bool _isScanning = true;
//
//   void setText(value) {
//     controller.add(value);
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     client = widget.client;
//     checkCameraPermission();
//   }
//
//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }
//
//   void saveOcrResultToFile(String ocrResult, String name) async {
//     final dir = await getApplicationDocumentsDirectory();
//     localFile = File('${dir.path}/${name}');
//     await localFile!.writeAsString(ocrResult);
//   }
//
//   void uploadFileToNextcloud(String filepath) async {
//     final file = File(localFile?.path ?? "");
//     final data = await file.readAsBytes();
//     String date = DateTime.now().toIso8601String() + ".txt";
//     await client.webdav.put(data, PathUri.parse(filepath)).then((value) {
//       Fluttertoast.showToast(msg: "Quét thành công");
//     });
//     setState(() {
//       _isScanning = true;
//     });
//   }
//
//   void checkCameraPermission() async {
//     // Kiểm tra quyền truy cập camera
//     PermissionStatus cameraPermissionStatus = await Permission.camera.status;
//
//     // Kiểm tra xem quyền truy cập đã được cấp hay chưa
//     if (cameraPermissionStatus.isGranted) {
//       // Quyền đã được cấp, thực hiện các hành động liên quan đến camera
//     } else {
//       // Quyền chưa được cấp, yêu cầu người dùng cấp quyền
//       PermissionStatus permissionStatus = await Permission.camera.request();
//
//       // Kiểm tra kết quả của yêu cầu quyền
//       if (permissionStatus.isGranted) {
//         // Quyền đã được cấp, thực hiện các hành động liên quan đến camera
//       } else {
//         // Quyền không được cấp, có thể hiển thị thông báo hoặc thông báo lỗi
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 ScalableOCR(
//                     // paintboxCustom: Paint()
//                     //   ..style = PaintingStyle.stroke
//                     //   ..strokeWidth = 4.0
//                     //   ..color = const Color.fromARGB(153, 102, 160, 241),
//                     boxLeftOff: 5,
//                     boxBottomOff: 2.5,
//                     boxRightOff: 5,
//                     boxTopOff: 2.5,
//                     boxHeight: MediaQuery.of(context).size.height / 3,
//                     getRawData: (value) {
//                       inspect(value);
//                     },
//                     getScannedText: (value) {
//                       if (_isScanning) {
//                         setText(value);
//                         saveOcrResultToFile(
//                             value, DateTime.now().toIso8601String());
//                       }
//                     }),
//                 StreamBuilder<String>(
//                   stream: controller.stream,
//                   builder:
//                       (BuildContext context, AsyncSnapshot<String> snapshot) {
//                     return Result(
//                         text: snapshot.data != null ? snapshot.data! : "");
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isScanning = false;
//                     });
//                     if (_isScanning == false) {
//                       var now = DateTime.now();
//                       final DateFormat formatter = DateFormat('yyyy-MM-dd');
//                       final String formatted = formatter.format(now);
//
//                       var filename = 'OCR_$formatted';
//                       uploadFileToNextcloud('$filename.txt');
//                     }
//                     // uploadFileToNextcloud('path_to_your_file.txt');
//                   },
//                   child: Text('Upload to Nextcloud'),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

class _MyHomePageState extends State<OCRPage> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  bool isProcesssing = false;
  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('OCR'),
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _scanImage,
                              child: const Text('Quét'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'Chưa có quyền camera',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
            isProcesssing
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }
    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;
    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

    final inputImage = InputImage.fromFile(file);
      setState(() {
        isProcesssing = true;
      });
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        isProcesssing = false;
      });
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Result(
            text: recognizedText.text,
            client: widget.client,

          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Đã xảy ra lỗi khi quét ảnh');
    }
  }
}

class Result extends StatefulWidget {
  const Result({
    Key? key,
    required this.text,
    required this.client, this.imagePath,
  }) : super(key: key);
  final NextcloudClient client;
  final String? imagePath;
  final String text;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late NextcloudClient client;
  File? localFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveOcrResultToFile(widget.text, DateTime.now().toIso8601String());
    client = widget.client;
  }
  void saveOcrResultToFile(String ocrResult, String name) async {
    final dir = await getApplicationDocumentsDirectory();
    localFile = File('${dir.path}/${name}');
    await localFile!.writeAsString(ocrResult);
  }

  void uploadFileToNextcloud(String filepath) async {
    final file = File(localFile?.path ?? "");
    final data = await file.readAsBytes();
    await client.webdav.put(data, PathUri.parse(filepath)).then((value) {
      Fluttertoast.showToast(msg: "Tải lên thành công");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
        actions: [

          ElevatedButton(
            onPressed: (){
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title:Text(" Thông báo "),
                  content: Text("Bạn muốn upload lên nextcloud? "),
                  actions: [
                    ElevatedButton(
                      onPressed: (){
                         Navigator.pop(context);
                      },
                      child: const Text('Hủy'),
                    ),
              ElevatedButton(
                      onPressed: (){
                        var now = DateTime.now();
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted = formatter.format(now);
                        var filename = 'OCR_$formatted';
                        uploadFileToNextcloud('$filename.txt');
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Upload'),
                    )

                  ],
                );
              },);

            },
            child: const Icon(Icons.upload),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child:    Column(
            children: [
              Text(widget.text, style: TextStyle(
                fontSize: 16.0,
                height: 1.5,
              ),),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: (){
              //       var now = DateTime.now();
              //         final DateFormat formatter = DateFormat('yyyy-MM-dd');
              //         final String formatted = formatter.format(now);
              //
              //         var filename = 'OCR_$formatted';
              //         uploadFileToNextcloud('$filename.txt');
              //     },
              //     child: const Text('Quét'),
              //   ),
              // ),
            ],
          )
        ),
      ),
    );
  }
}
