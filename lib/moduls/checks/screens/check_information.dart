import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:flutter/material.dart';

class CheckInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            child: Image.network(
              'https://images.unsplash.com/flagged/photo-1573740144655-bbb6e88fb18a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=435&q=80',
              fit: BoxFit.fill,
            ),
            height: size.height * .5,
            color: Colors.blue,
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              height: size.height * .60,
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: Column(
                  children: [
                    buildColumn(text1: 'االشيك من :  ', text2: 'محمود سلامه '),
                    buildColumn(text1: 'الشيك إلي :  ', text2: 'محمد احمد'),
                    buildColumn(text1: 'المعاد المستحق :  ', text2: '12-2-2021'),
                    buildColumn(text1: 'المعاد السداد :  ', text2: '12-2-2021'),
                    buildColumn(text1: 'المبلغ :  ', text2: '1000 ج'),
                    buildColumn(text1: 'تم التسديد :  ', text2: ' ليس بعد'),
                    buildColumn(text1: 'تم الرفض من البنك :  ', text2: 'لا'),
                  ],
                ),
              ),
            ),
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
