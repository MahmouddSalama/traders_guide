import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/main_layout.dart';
import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:financial_dealings/screens/auth/sgin_up/cupit/stats.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/virification_textfield.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cupit/cupit.dart';

class VirificationSignUPCode extends StatefulWidget {
  final String email;
  final String phone;
  final String ip;
  final String name;
  final String pass;
  final File image;

  VirificationSignUPCode({
    required this.email,
    required this.phone,
    required this.ip,
    required this.name,
    required this.pass,
    required this.image,
  });

  @override
  _VirificationSignUPCodeState createState() => _VirificationSignUPCodeState();
}

class _VirificationSignUPCodeState extends State<VirificationSignUPCode> {
  final _virifyControll = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                SizedBox(height: size.height * .1),
                PageTitle(text: 'الرقم التاكيدي'),
                SizedBox(height: 50),
                VirificationTextField(textEditingController: _virifyControll),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .15, vertical: 20),
                  child: loading
                      ? CircularProgressIndicator()
                      : DefaultButton(
                          function: () {
                            _submit(context);
                            print('ggg');
                          },
                          text: 'تاكيد',
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext ctx) async {
    String error = '';
    try {
      print(BlocProvider.of<RegisterCupit>(ctx).getname);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email
                  .trim()
                  .toLowerCase(),
              password: widget.pass
      );
      final User? user = userCredential.user;
      final uid = user!.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child(uid + '.jpg');
      await ref.putFile(widget.image);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'id': FirebaseAuth.instance.currentUser!.uid,
        'name': widget.name,
        'email':widget.email ,
        'imageUrl': url,
        'phoneNum': widget.phone,
        'ip': widget.ip,
        'createdAt': Timestamp.now(),
      });

      Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (ctx) => MainLayout()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }
}
