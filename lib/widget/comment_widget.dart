import 'dart:io';
import 'package:dz_2/resources/resources.dart';
import 'package:dz_2/widget/galery_from_camera.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/app_color.dart';

var date = [DateTime.now().day, DateTime.now().month, DateTime.now().year]
    .map((e) => e.toString());

class Comment {
  final String text;
  final String avatar = AppImages.avatarImage;
  final String nickname = 'lybitel_vkusno_poest';
  final String images = AppImages.salmon;
  final String datecomment = date.join('.');

  Comment(
    this.text,
  );
}

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CommentScreenState createState() => _CommentScreenState();
}

// Получение файла либо с камеры либо с галерии
class _CommentScreenState extends State<CommentScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _getImageFromCamera(BuildContext context) async {
    final XFile? imageFromcam =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (imageFromcam != null) {
      File file = File(imageFromcam.path);
      fileIm = file;
      final imageBox = Hive.box('imagesFromCam');
      imageBox.add(file.path);
      print(imageBox);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Изображение успешно сохранено')));
    }

    // ignore: void_checks
  }

  Future<void> _getImageFromDatabase(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ImageListScreen()));

    // final imageBox = Hive.box('images');
    // final imagePath = imageBox.get('image') as String?;

    // if (imagePath != null) {
    //   final File fileFromDB = File(imagePath);
    //   fileDB = fileFromDB;

    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text('Изображение загружено')));

    //   // Действия с загруженным изображением
    //   // Например, отображение или обработка
    // } else {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text('Изображение не найдено')));
    // }
  }

  // Future<void> getFile(ImageSource source, BuildContext context) async {
  //   try {
  //     print(source);
  //     final XFile? file = _isVideo
  //         // ignore: invalid_use_of_visible_for_testing_member
  //         ? await ImagePicker.platform.getVideo(source: source)
  //         // ignore: invalid_use_of_visible_for_testing_member
  //         : await ImagePicker.platform.getImageFromSource(source: source);
  //     setState(() {
  //       if (file != null) {
  //         _file = File(file.path);
  //         fileIm = _file?.readAsBytes();
  //       } else {
  //         Text('No image selected.');
  //       }

  //       _showBottomSheet(context);
  //     });
  //     return await fileIm;

  //     // return fileImage;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  final List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();

  // File? _file;
  // bool _isVideo = false;
  // ignore: prefer_typing_uninitialized_variables
  var fileIm;
  var fileDB;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: comments.map((comment) {
            return SizedBox(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 17,
                    ),
                    child: SizedBox(
                        width: 63,
                        height: 63,
                        child: CircleAvatar(
                            backgroundImage: AssetImage(comment.avatar))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 98, right: 17),
                    child: SizedBox(
                      width: 314,
                      child: Text(
                        comment.text,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 98),
                    child: Text(
                      comment.nickname,
                      style: const TextStyle(
                          color: ColorApp.textColorGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 100, left: 98, right: 17, bottom: 35),
                    child: SizedBox(
                        width: 314,
                        height: 160,
                        child: fileIm == null
                            ? Text('No image selected.')
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(fileIm!),
                                        fit: BoxFit.cover)),
                              )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4, left: 312, right: 17),
                    child: Text(
                      comment.datecomment,
                      style: const TextStyle(
                          color: ColorApp.iconColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 17, right: 17),
          child: SizedBox(
            width: double.infinity,
            height: 72,
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xff165932))),
                border: const OutlineInputBorder(borderSide: BorderSide()),
                hintText: 'Оставить комментарий',
                suffixIconColor: ColorApp.textColorDarkGreen,
                prefixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    _getImageFromCamera(context);
                  },
                ),
                icon: IconButton(
                  onPressed: () {
                    _getImageFromDatabase(context);
                  },
                  icon: Icon(Icons.add_a_photo),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String commentText = _commentController.text;
                    if (commentText.isNotEmpty) {
                      setState(() {
                        comments.add(Comment(commentText));
                        _commentController.clear();
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
