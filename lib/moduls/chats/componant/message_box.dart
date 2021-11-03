import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isme;
  final String imageurl;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.imageurl,
    required this.username,
    required this.isme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:  isme?MainAxisAlignment.start:MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              width: size.height*.3,
              decoration: BoxDecoration(
                color: isme ?Color(0xff002A4D):Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: isme?Radius.circular(15):Radius.circular(0),
                  bottomRight: !isme?Radius.circular(15):Radius.circular(0),
                ),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(12),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment:isme? CrossAxisAlignment.start:CrossAxisAlignment.end,
                  children: [
                    Text(message,style: TextStyle(
                      fontSize: 18,
                      color: isme?Colors.white:Colors.black,
                    ),),
                    SizedBox(height: 8,),
                    Text(username,style: TextStyle(
                      fontSize: 10,
                      color: isme?Colors.white:Colors.black,
                    ),)
                  ],
                ),
              ),
            ),
            Positioned(
              left:isme? 0:null,
              right: isme?null:0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                backgroundImage: NetworkImage(imageurl),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
