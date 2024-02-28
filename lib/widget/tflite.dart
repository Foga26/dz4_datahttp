import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic>? _recognitions;
  bool _isloading = false;
  ReceivePort _port = ReceivePort();
  late File? _image;

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'isolate');
    _port.listen((dynamic message) {
      setState(() {
        _recognitions = message['recognitions'];
        _isloading = false;
        _image = message['image'];
      });
    });
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/label.txt',
      );
    } on PlatformException {}
  }

  Future<void> detectObjects(XFile image) async {
    setState(() {
      _isloading = true;
    });

    final sendPort = IsolateNameServer.lookupPortByName('isolate');
    sendPort!.send({'path': image.path});

    try {
      List<int> bytes = await image.readAsBytes();
      sendPort.send({'bytes': bytes});

      final receivePort = ReceivePort();
      sendPort.send({'port': receivePort.sendPort});

      final Map<dynamic, dynamic> result = await receivePort.first;
      final List<dynamic> recognitions = result['recognitions'];
      final File imageFile = result['imageFile'];

      setState(() {
        _recognitions = recognitions;
        _isloading = false;
        _image = imageFile;
      });
    } on PlatformException {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detection'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_isloading)
                  const CircularProgressIndicator()
                else
                  _recognitions == null
                      ? const Text('No image selected')
                      : Image.file(File(_image!.path)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isloading
                      ? null
                      : () async {
                          final ImagePicker imagePicker = ImagePicker();
                          final XFile? image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            await detectObjects(image);
                          }
                        },
                  child: const Text('Select Image'),
                ),
              ],
            ),
          ),
          if (_recognitions != null)
            Positioned.fill(
              child: CustomPaint(
                painter: ObjectDetectionPainter(
                  objects: _recognitions!,
                  imageWidth: 1,
                  imageHeight: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ObjectDetectionPainter extends CustomPainter {
  final List<dynamic> objects;
  final double imageWidth;
  final double imageHeight;

  ObjectDetectionPainter({
    required this.objects,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final object in objects) {
      final Rect rect = Rect.fromLTWH(
        (object['rect']['x'] as double) * size.width / imageWidth,
        (object['rect']['y'] as double) * size.height / imageHeight,
        (object['rect']['w'] as double) * size.width / imageWidth,
        (object['rect']['h'] as double) * size.height / imageHeight,
      );
      canvas.drawRect(rect, paint);

      final TextStyle textStyle = TextStyle(
        color: Colors.red,
        fontSize: 16,
        backgroundColor: Colors.white,
      );
      final TextSpan textSpan = TextSpan(
        text: object['detectedClass'],
        style: textStyle.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.left + 4, rect.top + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}














// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';

// class MyApppp extends StatelessWidget {
//   const MyApppp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Object Detection',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<dynamic>? _recognitions;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();

//     _loadModel();
//   }

//   Future<void> _loadModel() async {
//     try {
//       await Tflite.loadModel(
//         model: 'assets/model.tflite',
//         labels: 'assets/label.txt',
//       );
//     } on PlatformException {}
//   }

//   var _image;
//   Future<void> _detectObjects(XFile image) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final recognitions = await Tflite.detectObjectOnImage(
//         path: image.path,
//         numResultsPerClass: 1,
//         threshold: 0.4,
//       );

//       setState(() {
//         _recognitions = recognitions!;
//         _isLoading = false;
//         _image = image.path;
//       });
//     } on PlatformException {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Object Detection'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 if (_isLoading)
//                   CircularProgressIndicator()
//                 else
//                   _recognitions == null
//                       ? Text('No image selected')
//                       : Image.file(File(_image)),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _isLoading
//                       ? null
//                       : () async {
//                           final imagePicker = ImagePicker();
//                           final image = await imagePicker.pickImage(
//                             source: ImageSource.gallery,
//                           );
//                           if (image != null) {
//                             await _detectObjects(image);
//                           }
//                         },
//                   child: Text('Select Image'),
//                 ),
//               ],
//             ),
//           ),
//           if (_recognitions != null)
//             Positioned.fill(
//               child: CustomPaint(
//                 painter: ObjectDetectionPainter(
//                   objects: _recognitions!,
//                   imageWidth: 1,
//                   imageHeight: 1,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// //d
// class ObjectDetectionPainter extends CustomPainter {
//   final List<dynamic> objects;
//   final double imageWidth;
//   final double imageHeight;

//   ObjectDetectionPainter({
//     required this.objects,
//     required this.imageWidth,
//     required this.imageHeight,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;

//     for (final object in objects) {
//       final rect = Rect.fromLTWH(
//         (object['rect']['x'] as double) * size.width / imageWidth,
//         (object['rect']['y'] as double) * size.height / imageHeight,
//         (object['rect']['w'] as double) * size.width / imageWidth,
//         (object['rect']['h'] as double) * size.height / imageHeight,
//       );
//       canvas.drawRect(rect, paint);

//       final textSpan = TextSpan(
//         text: object['detectedClass'],
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 16.0,
//           fontWeight: FontWeight.bold,
//         ),
//       );
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         Offset(rect.left + 4, rect.top + 4),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
