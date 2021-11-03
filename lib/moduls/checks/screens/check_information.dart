import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckInformation extends StatelessWidget {
  final id,color;

  const CheckInformation({Key? key,required this.id,required this.color,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,

            height: size.height * .3,
            color: color,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('checks').snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
              try {
                final docs = snapshot.data!.docs.firstWhere((element) => element.id.toString()==id);
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError)
                  return Text("error");
                else if (snapshot.hasData && snapshot.data!.docs.length != 0) {
                  return Align(
                    alignment: Alignment(0, 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      height: size.height * .8,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                        child: Column(
                          children: [
                            buildColumn(text1: 'االشيك من :  ', text2: docs['from']),
                            buildColumn(text1: 'الشيك إلي :  ', text2: docs['to']),
                            buildColumn(
                                text1: 'المعاد المستحق :  ', text2: docs['dueDate']),
                            buildColumn(text1: 'المعاد السداد :  ', text2: docs['dateOfPayment']),
                            buildColumn(text1: 'المبلغ :  ', text2: '${docs['money']} ج'),
                            buildColumn(text1: 'تم التسديد :  ', text2: docs['paid']?'نعم':'لا'),
                            buildColumn(text1: 'تم الرفض من البنك :  ',text2: docs['rejected ']?'نعم':'لا'),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text('لا يوجد عملاء مدينون'),
                  );
                }
              } catch (e) {}
              return Center(child: Text('fff'));
            }
          ),
        ],
      ),
    );
  }



  Flexible buildFlexible({text, flex}) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
        ),
        width: 150,
        height: 35,
      ),
      flex: flex,
    );
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
}
