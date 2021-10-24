import 'package:financial_dealings/moduls/blac_list/componant/add_black_list_item.dart';
import 'package:financial_dealings/moduls/blac_list/componant/black_list_item.dart';
import 'package:flutter/material.dart';

class BlackListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
              ),
            ),
          ],
          elevation: 0,
          title: Text(
            'القائمة السوداء',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
        body: Center(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return BlackListItem();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              builder: (context) => AddItem(),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
