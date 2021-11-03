import 'package:financial_dealings/layout/main_layout.dart';
import 'package:financial_dealings/screens/auth/forget_password/forget_mypass.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginForm extends StatefulWidget {

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();

  //vars
  bool obsecure = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  //TextEditingController
  final _emailControlle = TextEditingController();
  final _passControlle = TextEditingController();

  void dispose() {
    _passControlle.dispose();
    _emailControlle.dispose();
    _passFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DefaultTextField(
            focusNode: _emailFocusNode,
            nextFocusNode: _passFocusNode,
            textEditingController: _emailControlle,
            textInputType: TextInputType.emailAddress,
            hint: 'الاميل',
            validetor: (v) {
              if (v
                  .toString()
                  .isEmpty || !v
                  .toString()
                  .contains("@"))
                return 'من فضلك ادخل اميل صحيح';
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

  void _submit() async{
    String error='';
    if(_formKey.currentState!.validate()){
      try {
        setState(() {
          loading=true;
        });
         await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailControlle.text.toLowerCase().trim().toString(),
          password: _passControlle.text.trim().toString(),
        );
        Navigator.canPop(context)?Navigator.pop(context):null;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>MainLayout()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading=false;
        });
        if (e.code == 'user-not-found') {
          error='No user found for that email.';
        } else if (e.code == 'wrong-password') {
          error='Wrong password provided for that user.';
        }
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text('InValid data'),
          content:Text(error,style: TextStyle(fontSize: 18,color: Colors.red),),
          actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text('ok'))],
        ));
      }catch (e) {
        //print(e);
      }
    }
    setState(() {
      loading=false;
    });
  }
}