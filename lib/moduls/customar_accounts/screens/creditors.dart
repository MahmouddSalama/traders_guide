import 'package:financial_dealings/moduls/customar_accounts/componants/add_dialg.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/customar_card.dart';
import 'package:flutter/material.dart';

class Creditors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (ctx, index) {
              return CustomerCard(index: index,);
            },
            itemCount: 10,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(context: context, builder:(context) =>AddCustomar());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
