import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/screens/auth/forget_password/forget_mypass.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = false;
  TextEditingController textEditingController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'حسابي',
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            try {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Text("error");
              else if (snapshot.hasData && snapshot.data!.docs.length != 0) {
                var cutomerData = FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                       loading?Center(child: CircularProgressIndicator(),):
                       Stack(
                          children: [
                            loading
                                ? Container(
                                width: 200,
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ))
                                : CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.indigo,
                              backgroundImage:NetworkImage(
                                  snapshot.data!.docs[0]['imageUrl']
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton(
                                backgroundColor: Colors.indigo,
                                onPressed: () async {
                                  _showPhotoDialog();
                                  if (image != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    final ref = FirebaseStorage.instance
                                        .ref()
                                        .child('userImages')
                                        .child(
                                        FirebaseAuth.instance.currentUser!.uid +
                                            '.jpg');
                                    await ref.putFile(image!);
                                    final url = await ref.getDownloadURL();

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                        .update({
                                      'imageUrl': url,
                                    }).then((value) {
                                      setState(() {
                                        loading = false;
                                        image=null;
                                      });
                                    });
                                  }
                                },
                                child: Icon(image==null?Icons.camera_alt:Icons.arrow_upward_outlined),
                              ),
                            )
                          ],
                        ),
                        buildListTile(
                          edit: true,
                          function: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return buildAlertDialog(size, context,
                                    textinput: TextInputType.text,

                                    lable: 'الاسم', function: () async {
                                      await cutomerData.update(
                                        {
                                          'name': textEditingController1.text,
                                        },
                                      );
                                      textEditingController1.clear();
                                      Navigator.pop(context);
                                    }, textEditingController: textEditingController1);
                              },
                            );
                          },
                          text1: 'الاسم',
                          text2: snapshot.data!.docs[0]['name'],
                          icon: Icons.person,
                        ),
                        buildListTile(
                          edit: false,
                          text1: 'الاميل',
                          text2: snapshot.data!.docs[0]['email'],
                          icon: Icons.email,
                        ),
                        buildListTile(
                          edit: true,
                          function: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return buildAlertDialog(size, context,
                                    lable: 'رقم الهاتف', function: () async {
                                      await cutomerData.update(
                                        {
                                          'phoneNum': textEditingController1.text,
                                        },
                                      );
                                      textEditingController1.clear();
                                      Navigator.pop(context);
                                    }, textEditingController: textEditingController1);
                              },
                            );
                          },
                          text1: 'رقم الهاتف',
                          text2: snapshot.data!.docs[0]['phoneNum'],
                          icon: Icons.phone,
                        ),
                        if (snapshot.data!.docs[0]['bloked'])
                          buildListTile(
                            edit: false,
                            text1: 'بلوك',
                            text2: snapshot.data!.docs[0]['bloked'] ? 'نعم' : 'لا',
                            icon: Icons.phone,
                          ),
                        buildListTile(
                          edit: true,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPassScreen()),
                            );
                          },
                          text1: 'تغير كلمه السر',
                          text2: '*********',
                          icon: Icons.lock_open_outlined,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }catch(e){}
            return Center(child: CircularProgressIndicator());
          }
          ),
    );
  }

  ListTile buildListTile({
    text1,
    text2,
    icon,
    required bool edit,
    function,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.indigo,
        size: 30,
      ),
      title: Text(text1),
      subtitle: Text(
        text2,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      trailing: edit
          ? IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(Icons.edit),
            )
          : null,
    );
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

  AlertDialog buildAlertDialog(Size size, ctx,
      {required Function function,
      required TextEditingController textEditingController,
      required String lable,
      textinput=TextInputType.phone}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: size.width,
        height: size.height * .1,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DefaultTextField(
          textInputType: textinput,
          textEditingController: textEditingController,
          hint: lable,
          validetor: (v) {},
        ),
      ),
      actions: [
        TextButton(
          child: Text('تم'),
          onPressed: () {
            function();
          },
        ),
        TextButton(
          child: Text('إلغاء'),
          onPressed: () {
            Navigator.pop(ctx);
          },
        )
      ],
    );
  }
}
