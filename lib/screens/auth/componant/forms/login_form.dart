import 'package:financial_dealings/layout/main_layout.dart';
import 'package:financial_dealings/screens/auth/forget_password/forget_mypass.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginForm extends StatefulWidget {

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();

  //vars
  bool obsecure = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  //TextEditingController
  final _phoneControlle = TextEditingController();
  final _passControlle = TextEditingController();

  void dispose() {
    _passControlle.dispose();
    _phoneControlle.dispose();
    _passFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DefaultTextField(
            focusNode: _phoneFocusNode,
            nextFocusNode: _passFocusNode,
            textEditingController: _phoneControlle,
            textInputType: TextInputType.phone,
            hint: 'رقم الهاتف',
            validetor: (v) {
              if (v
                  .toString()
                  .isEmpty || v
                  .toString()
                  .length != 11)
                return 'من فضلك ادخل رقم هاتف صحيح';
            },
          ),
          SizedBox(height: 10),
          DefaultTextField(
            focusNode: _passFocusNode,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            textEditingController: _passControlle,
            hint: 'كلمة المرور',
            validetor: (v) {
              if (v
                  .toString()
                  .isEmpty || v
                  .toString()
                  .length < 7)
                return 'كلمة المرور يجب ان لا تقل عن سبع حروف';
            },
            isPass: obsecure,
            sufix: IconButton(
              onPressed: () {
                setState(() {
                  obsecure = !obsecure;
                });
              },
              icon: Icon(obsecure
                  ? Icons.visibility
                  : Icons.visibility_off, color: Colors.white,),
            ),
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                print('forget my pass');
                Methods.Navplace(page: ForgetPassScreen(), ctx: context);
              },
              child: Text(
                'نسيت كلمة المرور',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          SizedBox(height: 50),
            loading?CircularProgressIndicator() : DefaultButton(
            text: 'دخول',
            function: () {
              _submit();
            },
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      Future.delayed(Duration(seconds: 3), () {
        Methods.NavReplace(page: MainLayout(), ctx: context);
      }).then((value) {
        setState(() {
          loading = false;
        });
      });
    }
  }
}