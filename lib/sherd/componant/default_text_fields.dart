import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final String hint;
  final String? Function(dynamic value) validetor;
  final bool? isPass;
  final Widget? sufix;
  final TextEditingController textEditingController;
  final TextInputType? textInputType;
  final bool? enabled;
  final Function(dynamic value)? submit;

  const DefaultTextField(
      {Key? key,
        this.enabled=true,
        this.textInputType=TextInputType.text,
        required this.hint,
        required this.validetor,
        this.isPass = false,
        this.sufix,
        required this.textEditingController,
        this.focusNode,
        this.nextFocusNode,
        this.textInputAction=TextInputAction.next,
        this.submit,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onEditingComplete: (){
        if (nextFocusNode!=null)
          FocusScope.of(context).requestFocus(nextFocusNode);
        if(textInputAction== TextInputAction.done)
          FocusScope.of(context).unfocus();
      },
      style: TextStyle(fontSize: 20, color: Colors.white),
      keyboardType: textInputType,
      validator: (v) => validetor(v),
      obscureText: isPass!,
     onFieldSubmitted: (v)=>submit!(v),
      controller:textEditingController,
      decoration: InputDecoration(
          suffixIcon: sufix,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          disabledBorder: buildUnderlineInputBorder(Colors.white),
          enabledBorder: buildUnderlineInputBorder(Colors.white),
          focusedBorder: buildUnderlineInputBorder(Colors.blue.shade700),
          errorBorder: buildUnderlineInputBorder(Colors.red)),
    );
  }

  UnderlineInputBorder buildUnderlineInputBorder(color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: .7),
    );
  }
}
