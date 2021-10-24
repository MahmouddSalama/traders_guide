import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:flutter/material.dart';

class CustomerInformation extends StatefulWidget {
  @override
  _CustomerInformationState createState() => _CustomerInformationState();
}

class _CustomerInformationState extends State<CustomerInformation> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            child: Image.network(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60',
              fit: BoxFit.fill,
            ),
            height: size.height * .27,
            color: Colors.blue,
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              height: size.height * .75,
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: Column(
                  children: [
                    buildColumn(text1: 'الاسم :  ', text2: 'محمود سلامه '),
                    buildColumn(
                        text1: 'رقم الهاتف :  ', text2: '1111111111111'),
                    buildColumn(
                        text1: 'الرقم القومي :  ', text2: '00000000000000'),
                    buildColumn(text1: 'المبلغ :  ', text2: '1000 ج'),
                    buildColumn(text1: 'المعاد :  ', text2: '12-2-2021'),
                    Center(
                        child: Text(
                      'الارشيف',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Row(
                      children: [
                        buildFlexible(flex: 2, text: 'التاريخ'),
                        SizedBox(width: 5),
                        buildFlexible(flex: 1, text: 'التفاصيل'),
                        SizedBox(width: 5),
                        buildFlexible(flex: 1, text: 'وارد'),
                        SizedBox(width: 5),
                        buildFlexible(flex: 1, text: 'باقي')
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 2);
                          },
                          itemCount: 10,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                buildFlexible(flex: 2, text: '2-12-2021'),
                                SizedBox(width: 5),
                                buildFlexible(flex: 1, text: 'طقم'),
                                SizedBox(width: 5),
                                buildFlexible(flex: 1, text: '200'),
                                SizedBox(width: 5),
                                buildFlexible(flex: 1, text: '500')
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton.extended(
          onPressed: () {
            showBottomSheet(
                context: ctx,
                builder: (ctx) {
                  return AddArchef();
                });
          },
          label: Text('اضافه ارشيف'),
        ),
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
