import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:dz_2/resources/resources.dart';

import '../resources/app_color.dart';

var date = [DateTime.now().day, DateTime.now().month, DateTime.now().year]
    .map((e) => e.toString());

class ListComments {
  List<Comment> listText = [];
  List<Comment> listImage = [];
}

class Comment {
  String text;
  final String avatar = AppImages.avatarImage;
  final String nickname = 'lybitel_vkusno_poest';
  var imageComment;
  final String datecomment = date.join('.');

  Comment(
    this.text,
    this.imageComment,
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
      fileIm = file.path;
      final imageBox = Hive.box('imagesFromCam');
      imageBox.add(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Изображение успешно сохранено')));
    }

    // ignore: void_checks
  }

  void addCommentFromDataBase() {
    String commentText = _commentController.text;
    comments.add(Comment(commentText, fileDB));
    _commentController.clear();
  }

  void addCommentNotImage() {
    String commentText = _commentController.text;
    comments.add(Comment(commentText, null));
    _commentController.clear();
  }

  void addCommentfromCam() {
    String commentText = _commentController.text;

    comments.add(Comment(commentText, fileIm));
    _commentController.clear();
  }

  final List<Comment> comments = [];
  final List<ListComments> com = [];
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
                      child:
                          // fileIm == null || comment.images.isEmpty
                          //     ? Text('No image selected.')
                          //     :
                          Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage((File(comment.imageComment
                                    // fileDB == null ? fileIm : fileDB
                                    ))), fit: BoxFit.cover)),
                      ),
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
                    showBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                children: [
                                  TextButton(
                                      onPressed: () =>
                                          _getImageFromCamera(context),
                                      child: Text('Камера')),
                                  TextButton(
                                    child: Text(' Добавить из галереи'),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Scaffold(
                                              appBar: AppBar(
                                                title: Text('Галерея'),
                                              ),
                                              body: FutureBuilder(
                                                future: Hive.openBox(
                                                    'imagesFromCam'),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else {
                                                      if (snapshot.hasData) {
                                                        Box imagesBox =
                                                            snapshot.data;
                                                        List imagePaths =
                                                            imagesBox.values
                                                                .toList();
                                                        return GridView.builder(
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  mainAxisExtent:
                                                                      200,
                                                                  crossAxisCount:
                                                                      2,
                                                                  crossAxisSpacing:
                                                                      16),
                                                          itemCount:
                                                              imagePaths.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                fileDB =
                                                                    (imagePaths[
                                                                        index]);
                                                                if (fileDB !=
                                                                    null) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text('Изображение выбрано')));
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },

                                                              // onLongPress: () {
                                                              //   showDialog(
                                                              //     context: context,
                                                              //     builder: (BuildContext context) {
                                                              //       return AlertDialog(
                                                              //         content: Image.file(
                                                              //           File(imagePaths[index]),
                                                              //           fit: BoxFit.scaleDown,
                                                              //         ),
                                                              //       );
                                                              //     },
                                                              //   );
                                                              // },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    Image.file(
                                                                  File(imagePaths[
                                                                      index]),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        return Text(
                                                            'No images available');
                                                      }
                                                    }
                                                  } else {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                },
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Отмена'))
                                ],
                              ),
                            ),
                          );
                        });

                    // _getImageFromCamera(context);
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (fileDB != null && _commentController.text.isNotEmpty) {
                      //тут мы проверяем какая картинка выбрана
                      addCommentFromDataBase();
                    } else if (fileDB == null && fileIm == null) {
                      addCommentNotImage();
                    } else if (fileIm != null &&
                        _commentController.text.isNotEmpty) addCommentfromCam();
                    setState(() {
                      fileDB = null;
                      fileIm =
                          null; //после отправки комента картинки обнуляются чтобы сделать новый выбор
                    });
                    ;
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
