
import 'package:flutter/material.dart';
class DefaultField extends StatelessWidget {
  final String hint;
  final double elevation;
  final Widget? perfix;
  final Widget? sufix;

  const DefaultField({Key? key,required this.hint, this.elevation=5, this.perfix, this.sufix}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: size.height,
        height: 50,
        child: Card(
          elevation: elevation,
          child: TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              suffixIcon:sufix ,
              prefixIcon: perfix,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color:Color(0xff002A4D).withOpacity(.5)),
              contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            ),
          ),
        ),
      ),
    );
  }
}
