import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('imagesFromCam'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                Box imagesBox = snapshot.data;
                List imagePaths = imagesBox.values.toList();
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 200,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16),
                  itemCount: imagePaths.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Image.file(
                                File(imagePaths[index]),
                                fit: BoxFit.scaleDown,
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(imagePaths[index]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text('No images available');
              }
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
