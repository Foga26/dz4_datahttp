import 'package:dz_2/resources/resources.dart';
import 'package:flutter/material.dart';

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

class _CommentScreenState extends State<CommentScreen> {
  final List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();

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
                        child: Image.asset(comment.images)),
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
