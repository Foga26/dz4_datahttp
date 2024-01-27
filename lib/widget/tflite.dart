import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class MyApppp extends StatelessWidget {
  const MyApppp({super.key});

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
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic>? _recognitions;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/label.txt',
      );
    } on PlatformException {}
  }

  var _image;
  Future<void> _detectObjects(XFile image) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        numResultsPerClass: 1,
        threshold: 0.4,
      );

      setState(() {
        _recognitions = recognitions!;
        _isLoading = false;
        _image = image.path;
      });
    } on PlatformException {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  _recognitions == null
                      ? Text('No image selected')
                      : Image.file(File(_image)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final imagePicker = ImagePicker();
                          final image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            await _detectObjects(image);
                          }
                        },
                  child: Text('Select Image'),
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

//d
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
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final object in objects) {
      final rect = Rect.fromLTWH(
        (object['rect']['x'] as double) * size.width / imageWidth,
        (object['rect']['y'] as double) * size.height / imageHeight,
        (object['rect']['w'] as double) * size.width / imageWidth,
        (object['rect']['h'] as double) * size.height / imageHeight,
      );
      canvas.drawRect(rect, paint);

      final textStyle = TextStyle(
        color: Colors.red,
        fontSize: 16,
        backgroundColor: Colors.white,
      );
      final textSpan = TextSpan(
        text: object['detectedClass'],
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
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
