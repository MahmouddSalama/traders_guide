import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataArchifScreen extends StatefulWidget {
  final String id;
  final String colliction;
  final money;
  final payed;
  final rest;


   DataArchifScreen({
    Key? key,
   required this.id,
   required this.colliction,
    required this.money,
    required this.payed,
    required this.rest,
  }) : super(key: key);

  @override
  _DataArchifScreenState createState() => _DataArchifScreenState();
}

class _DataArchifScreenState extends State<DataArchifScreen> {
  TextEditingController textEditingController1 = TextEditingController();

  TextEditingController textEditingController2 = TextEditingController();

  TextEditingController textEditingController3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ارشيف ',style: TextStyle(
          fontSize: 20,
          color: Colors.black
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            _buildStreamBuilder(),
            Row(
              children: [
                buildFlexible(flex: 3, text: 'التاريخ'),
                SizedBox(width: 1.5),
                buildFlexible(flex: 2, text: 'التفاصيل'),
                SizedBox(width: 1.5),
                buildFlexible(flex: 3, text: 'وارد'),
                SizedBox(width: 1.5),
                buildFlexible(flex: 3, text: 'صادر',color: Colors.red),
                PopupMenuButton(itemBuilder: (ctx){
                  return[ PopupMenuItem(child: null)];
                },),
              ],
            ),
            SizedBox(height: 10),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(widget.colliction)
                    .doc(widget.id)
                    .collection('archif')
                    .orderBy('createAt')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot1) {
                  try {
                    final docs1 = snapshot1.data!.docs;
                    if (snapshot1.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if (snapshot1.hasError)
                      return Text("error");
                    else if (snapshot1.hasData &&
                        snapshot1.data!.docs.length != 0) {
                      return Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 2);
                          },
                          itemCount: docs1.length,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                buildFlexible(
                                    flex: 3, text: snapshot1.data!.docs[i]['date']),
                                SizedBox(width: 1.5),
                                buildFlexible(
                                    flex: 2,
                                    text: snapshot1.data!.docs[i]['details']),
                                SizedBox(width: 1.5),
                                buildFlexible(
                                    flex: 3, text: snapshot1.data!.docs[i]['in']),
                                SizedBox(width: 1.5),
                                buildFlexible(
                                    color: Colors.red,
                                    flex: 3, text: snapshot1.data!.docs[i]['out']),
                                SizedBox(width: 3),
                                PopupMenuButton(
                                  onSelected: (item)async{
                                    if(item==1){
                                      var archifData= await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection(widget.colliction)
                                          .doc(widget.id)
                                          .collection('archif').doc(snapshot1.data!.docs[i].id).get();
                                      textEditingController1.text=archifData['take']==1?archifData['out'].toString():archifData['in'].toString();
                                      textEditingController2.text=archifData['details'];
                                      textEditingController3.text=archifData['date'];
                                      showBottomSheet(
                                        context: context,
                                        builder: (ctx) {
                                          return editData(MediaQuery.of(context).size,
                                                  ()async {
                                                var cDate= await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(widget.colliction)
                                                    .doc(widget.id).get();
                                                archifData= await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(widget.colliction)
                                                    .doc(widget.id)
                                                    .collection('archif').doc(snapshot1.data!.docs[i].id).get();

                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(widget.colliction)
                                                    .doc(widget.id)
                                                    .collection('archif').doc(snapshot1.data!.docs[i].id).update({
                                                  'in':snapshot1.data!.docs[i]['take']==0?textEditingController1.text:'0',
                                                  'out':snapshot1.data!.docs[i]['take']==1?textEditingController1.text:'0',
                                                  'date':textEditingController3.text,
                                                  'details':textEditingController2.text,
                                                });
                                                if(snapshot1.data!.docs[i]['take']==0){
                                                  if(int.parse(textEditingController1.text)>int.parse(snapshot1.data!.docs[i]['in'])){
                                                    await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                                        .collection(widget.colliction)
                                                        .doc(widget.id).update({
                                                      'payed':cDate['payed']+(int.parse(textEditingController1.text)-int.parse(archifData['in'])),
                                                      'rest': cDate['rest']-(int.parse(textEditingController1.text)-int.parse(archifData['in'])),
                                                    });
                                                  }else{
                                                    await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                                        .collection(widget.colliction)
                                                        .doc( widget.id).update({
                                                      'payed':cDate['payed']-(int.parse(archifData['in'])-int.parse(textEditingController1.text)),
                                                      'rest': cDate['rest']+(int.parse(archifData['in'])-int.parse(textEditingController1.text)),
                                                    });
                                                  }
                                                }
                                                else{
                                                  if(int.parse(textEditingController1.text)>int.parse(snapshot1.data!.docs[i]['in'])){
                                                    await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                                        .collection(widget.colliction)
                                                        .doc(widget.id).update({
                                                      'money':'${int.parse(cDate['money'])+(int.parse(textEditingController1.text)-int.parse(archifData['out']))}',
                                                      'rest': cDate['rest']+(int.parse(textEditingController1.text)-int.parse(archifData['out'])),
                                                    });
                                                  }else{
                                                    await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                                        .collection(widget.colliction)
                                                        .doc( widget.id).update({
                                                      'money':'${int.parse(cDate['money'])-(int.parse(archifData['out']))-int.parse(textEditingController1.text)}',
                                                      'rest': cDate['rest']+(int.parse(archifData['out'])-int.parse(textEditingController1.text)),
                                                    });
                                                  }
                                                }
                                                textEditingController1.clear();
                                                textEditingController2.clear();
                                                textEditingController3 .clear();
                                              }
                                          );
                                        },
                                      );
                                    }
                                    else if(item==2){
                                     var data= await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection(widget.colliction)
                                          .doc(widget.id)
                                          .collection('archif').doc(snapshot1.data!.docs[i].id).get();

                                     var userdata= await FirebaseFirestore.instance
                                         .collection('users')
                                         .doc(FirebaseAuth.instance.currentUser!.uid)
                                         .collection(widget.colliction)
                                         .doc(widget.id).get();

                                     if(snapshot1.data!.docs[i]['take']==0){
                                       await FirebaseFirestore.instance
                                           .collection('users')
                                           .doc(FirebaseAuth.instance.currentUser!.uid)
                                           .collection(widget.colliction)
                                           .doc(widget.id).update({
                                         'money':(int.parse(userdata['money'])).toString(),
                                         'rest':userdata['rest']+int.parse(data['in']),
                                         'payed':userdata['payed']-int.parse(data['in']),
                                       });
                                     }else{
                                       await FirebaseFirestore.instance
                                           .collection('users')
                                           .doc(FirebaseAuth.instance.currentUser!.uid)
                                           .collection(widget.colliction)
                                           .doc(widget.id).update({
                                         'money':(int.parse(userdata['money'])-int.parse(data['out'])).toString(),
                                         'rest':userdata['rest']-int.parse(data['out']),
                                       });
                                     }
                                     await FirebaseFirestore.instance
                                         .collection('users')
                                         .doc(FirebaseAuth.instance.currentUser!.uid)
                                         .collection(widget.colliction)
                                         .doc(widget.id)
                                         .collection('archif').doc(snapshot1.data!.docs[i].id).delete();
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  color: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          'تعديل',
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text(
                                          'حذف',
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                      ),

                                    ];
                                  },
                                ),

                              ],
                            );
                          },
                        ),
                      );
                    } else if (snapshot1.data!.docs.length == 0) {
                      return Center(
                        child: Text('لا يوجد بيانات '),
                      );
                    }
                  } catch (e) {}
                  return Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton.extended(
          onPressed: () async {
            final user = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            if (user['bloked'] == false) {
              showBottomSheet(
                context: ctx,
                builder: (ctx) {
                  return AddArchef(
                    doc:widget.id,
                    collision: widget.colliction,
                  );
                },
              );
            } else
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'لا يمكنك ان تقوم باي عمليه في الوقت الحالي ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blue,
              ));
          },
          label: Text('اضافه بيان'),
        ),
      ),
    );
  }

  _buildStreamBuilder()  {
    return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection(widget.colliction)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                try {

                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Text("error");
                  else if (snapshot.hasData &&
                      snapshot.data!.docs.length != 0) {
                    final docs = snapshot.data!.docs
                        .firstWhere((element) => element.id.toString() == widget.id);
                    return  Column(
                            children: [
                              Center(
                                  child: Text(
                                    '${docs['name']}',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  )),
                              buildColumn(
                                  edit: false,
                                  text1: 'إجمالي الصادر :  ', text2: docs['money']),
                              buildColumn(
                                  edit: false,
                                  text1: 'اجمالي الوارد :  ',
                                  text2: docs['payed'].toString()),
                              buildColumn(
                                x: docs['rest'],
                                  edit: false,
                                  text1: 'اجمالي الباقي :  ',
                                  text2: docs['rest'].toString()),
                              SizedBox(height: 10,)
                            ],
                    );
                  } else if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Text('لا يوجد بيانات '),
                    );
                  }
                } catch (e) {}
                return Center(child: CircularProgressIndicator());
              });
  }

  Flexible buildFlexible({text, flex, color=Colors.blue}) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white),
        ),
        width: 150,
        height: 35,
      ),
      flex: flex,
    );
  }

  Column buildColumn({required text1, required text2, function,required bool edit , x=1}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: x>0?Colors.black:Colors.red),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: x>0?Colors.black:Colors.red),
            ),
            Spacer(),
            edit?
            IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ):SizedBox()
          ],
        ),
        Divider(
          thickness: 2,
          color: Colors.blue.shade100,
        ),
      ],
    );
  }
  DateTime? picked;
  pickedDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 50)),
      lastDate: DateTime.now().add(Duration(days: 50)),
    );
    if (picked != null) {
      setState(() {
        textEditingController3.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        //_timestamp=Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch,);
      });
    }
  }
  editData(size, Function function){
    return  Container(
      height: size.height * .4,
      child: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DefaultTextField(
                    textEditingController: textEditingController1,
                    textInputType: TextInputType.number,
                    hint: '',
                    validetor: (v) {
                      if (v.toString().isEmpty) return 'من فضلك ادخل عنوان صحيح';
                    },
                  ),
                  DefaultTextField(
                    textEditingController: textEditingController2,
                    textInputType: TextInputType.text,
                    hint: '',
                    validetor: (v) {
                      if (v.toString().isEmpty) return 'من فضلك ادخل نوع صحيح';
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      pickedDialog();
                    },
                    child: DefaultTextField(
                      enabled: false,
                      textEditingController: textEditingController3,
                      textInputType: TextInputType.phone,
                      hint: '',
                      validetor: (v) {
                        if (v.toString().isEmpty) return 'من فضلك ادخل موعد صحيح';
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                 DefaultButton(
                    text: 'تعديل',
                    function: () {
                      function();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
