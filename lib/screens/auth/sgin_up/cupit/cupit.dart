import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:financial_dealings/screens/auth/sgin_up/cupit/stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCupit extends Cubit<RegisterState> {
  RegisterCupit() : super(InitialStates());

  //static RegisterCupit get(context) => BlocProvider.of(context);
  String email = '';
  String pass = '';
  String phone = '';
  String ip = '';
  String name = '';
  String verId = '';
  File? image;

  void setVerId(String vcode) {
    this.verId = vcode;
    emit(SetVerIdCode());
  }

  void setName(String name) {
    this.name = name;
    emit(SetName());
  }

  void setEmail(String email) {
    this.email = email;
    emit(SetEmail());
  }

  void setPhone(String phone) {
    this.phone = phone;
    emit(SetPhone());
  }

  void setIP(String ip) {
    this.ip = ip;
    emit(SetIp());
  }

  void setPass(String pass) {
    this.pass = pass;
    emit(SetPass());
  }

  void setImage(File image) {
    this.image = image;
    emit(SetImage());
  }

  String get getname {
    return this.name;
  }

  String get getpass {
    return this.pass;
  }

  String get getemail {
    return this.email;
  }

  String get getip {
    return this.ip;
  }

  String get getphone {
    return this.phone;
  }

  File? get getimage {
    return this.image;
  }
}
