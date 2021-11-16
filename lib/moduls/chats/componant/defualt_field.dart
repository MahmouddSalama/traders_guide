import 'package:flutter/material.dart';

class DefaultField extends StatelessWidget {
  final String hint;
  final double elevation;
  final Widget? perfix;
  final Widget? sufix;
  final TextEditingController textEditingController;
  final void Function (String v) search;

  const DefaultField({
   required this.search,
    Key? key,
    required this.hint,
    this.elevation = 5,
    this.perfix,
    this.sufix,
    required this.textEditingController,
  }) : super(key: key);

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
            onChanged: (v)=>search(v),
            maxLines: 3,
            maxLength: 500,
            controller: textEditingController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              counterText: '',
              suffixIcon: sufix,
              prefixIcon: perfix,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xff002A4D).withOpacity(.5)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ),
      ),
    );
  }
}
