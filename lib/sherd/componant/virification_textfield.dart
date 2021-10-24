import 'package:flutter/material.dart';

class VirificationTextField extends StatelessWidget {
  final TextEditingController textEditingController;

  const VirificationTextField({Key? key,required this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
      width: size.width * .8,
      height: 60,
      alignment: Alignment.center,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextFormField(
          controller: textEditingController,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '******',
            counterText: "",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
