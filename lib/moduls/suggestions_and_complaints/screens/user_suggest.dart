import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class UserSuggest extends StatefulWidget {
  @override
  _UserSuggestState createState() => _UserSuggestState();
}

class _UserSuggestState extends State<UserSuggest> {
  final _nameControll = TextEditingController();

  final _supjectControll = TextEditingController();

  final _messageControll = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('المقترحات و الشكاوي'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
        body: Stack(
          children: [
            BackgroundAnimationImage(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DefaultTextField(
                        textEditingController: _nameControll,
                        hint: 'الاسم',
                        validetor: (v) {
                          if (v.toString().isEmpty) {
                            return 'من فضلك ادخل اسم صحيح';
                          }
                        },
                        textInputType: TextInputType.name,
                      ),
                      DefaultTextField(
                        textEditingController: _supjectControll,
                        hint: 'الموضوع',
                        validetor: (v) {
                          if (v.toString().isEmpty) {
                            return 'من فضلك ادخل اسم الموضع الذي تريد الشكوي منه صحيح';
                          }
                        },
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          width: size.width ,
                          child: TextFormField(
                            controller: _messageControll,
                            maxLines: 10,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                      ),
                      loading
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20),
                        child: DefaultButton(
                          function: () {
                            _addSuggest(context);
                          },
                          text: 'ارسال',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  _addSuggest(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await FirebaseFirestore.instance.collection('SuggestionsAndComplaints').doc().set({
        'name': _nameControll.value.text,
        'supject': _supjectControll.value.text,
        'message': _messageControll.value.text,
        'createdAt': Timestamp.now(),
        'userId':FirebaseAuth.instance.currentUser!.uid,
      }).then(
            (value) {
              _messageControll.clear();
              _supjectControll.clear();
              _nameControll.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Container(
                  height: 50,
                  child: Column(
                    children: [
                      Text('شكرا علي مقترحك و ناسف جدا علي سبب الشكوي'),
                      Text('تم رفع شكوتك او مقترحك للإداره بنجاح'),
                    ],
                  ),
                ),
              ));
          setState(() {
            loading = false;
          });
        },
      );
    }
  }
}
