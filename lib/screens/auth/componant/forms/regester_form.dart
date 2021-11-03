import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/main_layout.dart';
import 'package:financial_dealings/screens/auth/sgin_up/cupit/cupit.dart';
import 'package:financial_dealings/screens/auth/sgin_up/cupit/stats.dart';
import 'package:financial_dealings/screens/auth/sgin_up/virification_signup_code.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  //vars
  bool obsecure = true;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // TextEditingController
  final _emailControlle = TextEditingController();
  final _nameControlle = TextEditingController();
  final _passControlle = TextEditingController();
  final _rePassControlle = TextEditingController();
  final _phoneControlle = TextEditingController();
  final _idControlle = TextEditingController();

  // FocusNodes
  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _rePassFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _idFocusNode = FocusNode();

  void dispose() {
    // TODO: implement dispose
    _emailControlle.dispose();
    _passControlle.dispose();
    _nameControlle.dispose();
    _rePassControlle.dispose();
    _phoneControlle.dispose();
    _idControlle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => RegisterCupit(),
      child: BlocConsumer<RegisterCupit, RegisterState>(
        listener: (context, state) {},
        builder: (context, state) => Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: DefaultTextField(
                      textInputType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      nextFocusNode: _phoneFocusNode,
                      textEditingController: _emailControlle,
                      hint: 'الاميل',
                      validetor: (v) {
                        if (v.toString().isEmpty || !v.toString().contains("@"))
                          return 'ادخل اميل صحيح';
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => _showPhotoDialog(),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.blueAccent)),
                              child: image == null
                                  ? Icon(
                                      Icons.person_sharp,
                                      size: 50,
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
                          Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                image == null ? Icons.camera_alt : Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DefaultTextField(
                textInputType: TextInputType.phone,
                focusNode: _phoneFocusNode,
                nextFocusNode: _idFocusNode,
                textEditingController: _phoneControlle,
                hint: 'رقم الهاتف',
                validetor: (v) {
                  if (v.toString().isEmpty || v.toString().length != 11)
                    return 'أدخل رقم هاتف صحيح';
                },
              ),
              SizedBox(height: 10),
              DefaultTextField(
                textInputType: TextInputType.number,
                focusNode: _idFocusNode,
                nextFocusNode: _fullnameFocusNode,
                textEditingController: _idControlle,
                hint: 'رقم القومي',
                validetor: (v) {
                  if (v.toString().isEmpty || v.toString().length != 14)
                    return 'أدخل رقم القومي صحيح';
                },
              ),
              SizedBox(height: 10),
              DefaultTextField(
                focusNode: _fullnameFocusNode,
                nextFocusNode: _passFocusNode,
                textEditingController: _nameControlle,
                hint: 'الاسم',
                validetor: (v) {
                  if (v.toString().isEmpty) return 'ادخل اسم صحيح';
                },
              ),
              SizedBox(height: 10),
              DefaultTextField(
                textInputType: TextInputType.visiblePassword,
                focusNode: _passFocusNode,
                nextFocusNode: _rePassFocusNode,
                textEditingController: _passControlle,
                hint: 'كلمة مرور',
                validetor: (v) {
                  if (v.toString().isEmpty || v.toString().length < 7)
                    return 'يجب علي كلمة المرور ان لا تقل عن 7 احرف';
                },
                isPass: obsecure,
                sufix: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecure = !obsecure;
                    });
                  },
                  icon: Icon(
                    obsecure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              DefaultTextField(
                textInputType: TextInputType.visiblePassword,
                focusNode: _rePassFocusNode,
                textEditingController: _rePassControlle,
                hint: 'تأكيد كلمة المرور',
                validetor: (v) {
                  if ((v.toString().isEmpty || v.toString().length < 7) &&
                      (_passControlle.value.text.toString() !=
                          _rePassControlle.value.text.toString()))
                    return 'ليست تأكيد لكلمة المرور';
                },
                isPass: obsecure,
                sufix: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecure = !obsecure;
                    });
                  },
                  icon: Icon(
                    obsecure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 50),
              loading
                  ? CircularProgressIndicator()
                  : DefaultButton(
                      text: 'انشاء الحساب',
                      iconData: null,
                      function: () {
                        _submit(context);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext ctx) async {
    String error='';
    if(_formKey.currentState!.validate()) {
      if(image==null){
        return _showErrorDialog('no image sellcted');
      }
      setState(() {
        loading=true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailControlle.text.toLowerCase().trim(),
          password: _passControlle.text.trim(),
        );
        final User?  user= userCredential.user;
        final uid=user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(uid + '.jpg');
        await ref.putFile(image!);
        final  url = await ref.getDownloadURL();
        await  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'id':FirebaseAuth.instance.currentUser!.uid,
          'name':_nameControlle.text,
          'email':_emailControlle.text,
          'imageUrl':url,
          'phoneNum':_phoneControlle.text,
          'ip':_idControlle.text,
          'createdAt':Timestamp.now(),
          'admin':false
        });
        Navigator.canPop(context)?Navigator.pop(context):null;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>MainLayout()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading=false;
        });
        if (e.code == 'weak-password') {
          error='The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          error='The account already exists for that email.';
        }
        _showErrorDialog('error is${e.toString()}');

      } catch (e) {
        print(e);
      }
    }
    setState(() {
      loading=false;
    });
  }

  _showErrorDialog(error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('InValid data'),
        content: Text(
          error,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ok'))
        ],
      ),
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
}
