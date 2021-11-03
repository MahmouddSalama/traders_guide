import 'package:financial_dealings/moduls/customar_accounts/model/customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProvider with ChangeNotifier {
  List<Customer> customerCreditList = [];
  List<Customer> customerOweList = [];
  void addCustomerCredit({required Customer customer}) {
    if(customerCreditList.contains(customer)==false)
    customerCreditList.add(
    customer
    );
    notifyListeners();
  }
  void addCustomerOwe({
    required String name,
    required String phone,
    required String ip,
    required int money,
    required String date,
     required archef,
  }) {
    customerOweList.add(
      Customer(
        name: name,
        phone: phone,
        ip: ip,
        money: money,
        date: date,
        archef: archef,
      ),
    );
    notifyListeners();
  }
  void deletCridet( int index){
    customerCreditList.removeAt(index);
    notifyListeners();
  }
}
