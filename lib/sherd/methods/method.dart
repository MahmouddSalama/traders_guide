import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Methods{

  static NavReplace({ctx,page}){
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (ctx)=>page));
  }

  static Navplace({ctx,page}){
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx)=>page));
  }

 static showPhotoDialog({context,image}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختار صوره من'),
        content: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.gallery,image: image);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.blue,
                  size: 25,
                ),
                label: Text(
                  'المعرض',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.camera,image: image);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 25,
                ),
                label: Text(
                  'الكاميرا',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('اغلاق'))
        ],
      ),
    );
  }
 static final picker = ImagePicker();
  static Future getImage(ImageSource crs,{image}) async {

    final pickerFile = await picker.pickImage(source: crs);

      if (pickerFile != null) {
        image=File(pickerFile.path);
      } else {
        print('No photo');
      }

  }


}