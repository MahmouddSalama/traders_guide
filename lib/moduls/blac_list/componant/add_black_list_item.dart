import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _departmentFocusNode = FocusNode();

  final _nameControlle = TextEditingController();
  final _addressControlle = TextEditingController();
  final _departmentControlle = TextEditingController();
  bool loading =false;
  @override
  void dispose() {
    // TODO: implement dispose
    _nameControlle.dispose();
    _addressControlle.dispose();
    _departmentControlle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .6,
      child: Stack(children: [
        BackgroundAnimationImage(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showPhotoDialog(),
                    child: Container(
                      height: 150,
                      width: 200,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Container(
                                height: 150,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border:
                                        Border.all(color: Colors.blueAccent)),
                                child: image == null
                                    ? Center(
                                        child: Text('صورة رفض البنك',style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),),
                                      )
                                    : ClipRRect(
                                        child: Image.file(
                                          image!,
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              image == null ? Icons.camera_alt : Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DefaultTextField(
                    hint: 'الاسم',
                    textEditingController: _nameControlle,
                    validetor: (v) {
                      if (v.toString().isEmpty) return 'ادخل اسم صحيح';
                    },
                    focusNode: _nameFocusNode,
                    nextFocusNode: _addressFocusNode,
                    textInputType: TextInputType.name,
                  ),
                  DefaultTextField(
                    hint: 'العنوان',
                    textEditingController: _addressControlle,
                    validetor: (v) {
                      if (v.toString().isEmpty) return 'ادخل عنوان صحيح';
                    },
                    focusNode: _addressFocusNode,
                    nextFocusNode: _departmentFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  DefaultTextField(
                    hint: 'المجال',
                    textEditingController: _departmentControlle,
                    validetor: (v) {
                      if (v.toString().isEmpty) return 'ادخل اسم المجال صحيح';
                    },
                    focusNode: _departmentFocusNode,
                    textInputType: TextInputType.name,
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                 loading?Center(child: CircularProgressIndicator(),): DefaultButton(
                    function: () {
                      _add();
                    },
                    text: 'اضافه',
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _add()async{
    setState(() {
      loading=true;
    });
    final ref = await FirebaseStorage.instance
        .ref()
        .child('checkImages')
        .child(_nameControlle.text+ '.jpg');
    await ref.putFile(image!);
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('blacklist').doc().set({
      'name':_nameControlle.text,
      'trak':_departmentControlle.text,
      'address':_addressControlle.text,
      'imageUrl':url,
      'userId':FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      setState(() {
        loading=false;
      });
      Navigator.pop(context);
    });
  }
  File? image;
  _showPhotoDialog() {
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
                  getImage(ImageSource.gallery);
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
                  getImage(ImageSource.camera);
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

  final picker = ImagePicker();

  Future getImage(ImageSource crs) async {
    final pickerFile = await picker.pickImage(source: crs);
    setState(() {
      if (pickerFile != null) {
        image = File(pickerFile.path);
      } else {
        print('No photo');
      }
    });
  }
}
