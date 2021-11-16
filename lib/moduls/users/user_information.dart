import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/users/social_connect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfo extends StatelessWidget {
  final String id;

  const UserInfo({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsSates>(
        listener: (ctx, state) {},
        builder: (ctx, state) => Scaffold(
          body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                try {
                  final docs = snapshot.data!.docs
                      .firstWhere((element) => element.id == id);
                  // NewsCubit.get(context).isAdmin(docs['admin']);
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Text("error");
                  else if (snapshot.hasData &&
                      snapshot.data!.docs.length != 0) {
                    var user = _user();
                    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                        docs['createdAt'].microsecondsSinceEpoch);

                    return Stack(children: [
                      Container(
                        width: size.width,
                        height: size.height * .35,
                        child: Image.network(
                          docs['imageUrl'],
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          height: size.height * .7,
                          width: size.width,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, right: 20, left: 20),
                            child: Column(
                              children: [
                                buildColumn(
                                    text1: 'الاسم : ', text2: docs['name']),
                                buildColumn(
                                    text1: 'الاميل :  ', text2: docs['email']),
                                buildColumn(
                                    text1: 'الرقم القومي :  ',
                                    text2: docs['ip']),
                                buildColumn(
                                    text1: 'رقم الهاتف :  ',
                                    text2: docs['phoneNum']),
                                buildColumn(
                                    text1: 'تاريخ الانضمام :  ',
                                    text2:
                                        '${date.year}-${date.month}-${date.day}'),
                                SizedBox(
                                  height: 30,
                                ),
                                if (id !=
                                    FirebaseAuth.instance.currentUser!.uid)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SocialContact(
                                          function: () {
                                            goToWhatsApp(
                                              name: docs['name'],
                                              phonNumber: docs['phoneNum'],
                                            );
                                          },
                                          iconData: FontAwesomeIcons.whatsapp,
                                          color: Colors.green),
                                      SocialContact(
                                          function: () {
                                            goToMail(email: docs['email']);
                                          },
                                          iconData: Icons.email_outlined,
                                          color: Colors.redAccent),
                                      SocialContact(
                                          function: () {
                                            goToPhone(
                                              phoneNumber: docs['phoneNum'],
                                            );
                                          },
                                          iconData: Icons.call,
                                          color: Colors.deepPurple)
                                    ],
                                  ),
                                SizedBox(height: 20),
                                if (docs['admin'] == false && FirebaseAuth.instance.currentUser!.uid!= id)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        docs['bloked']
                                            ? " فك حظر"
                                            : 'حظر',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch(
                                        activeColor: Colors.red,
                                        value: docs['bloked'],
                                        onChanged: (v) {
                                          NewsCubit.get(context).isBlocked(v);
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(id)
                                              .update({
                                            'bloked': NewsCubit.get(context).bloked
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'اجعله ادمن',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Switch(
                                        activeColor: Colors.red,
                                        value: docs['admin'],
                                        onChanged: (v) {
                                          NewsCubit.get(context).isAdmin(v);
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(id)
                                              .update(
                                            {
                                              'admin':
                                                  NewsCubit.get(context).admin
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]);
                  } else if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Text('لا يوجد عملاء '),
                    );
                  }
                } catch (e) {
                  print(e);
                  return Center(child: Text(e.toString()));
                }
                return Center(child: Text('rr'));
              }),
        ),
      ),
    );
  }

  _user() async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return user;
  }

  Column buildColumn({required text1, required text2}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Divider(
          thickness: 2,
          color: Colors.blue.shade100,
        ),
      ],
    );
  }

  void goToWhatsApp({phonNumber, name}) async {
    var phonNum = phonNumber;
    String url =
        'http://wa.me/+2$phonNum?text=كيف حاالك  ${name}  انا ادمن الابليكيشن دليل التجار كنت حابب استفسر منك علي شيئ معين ';
    await launch(url);
  }

  void goToMail({email}) async {
    String url = 'mailto:$email';
    await launch(url);
  }

  void goToPhone({phoneNumber}) async {
    String url = 'tel://+2${phoneNumber}';
    await launch(url);
  }
}
