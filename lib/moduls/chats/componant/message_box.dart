import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final bool isme;
  final String imageurl;
  final bool isImage;
  final Timestamp time;

  const MessageBubble({
    Key? key,
    required this.time,
    required this.isImage,
    required this.message,
    required this.imageurl,
    required this.username,
    required this.isme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime= DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
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
                    Text(username,style: TextStyle(
                      fontSize: 10,
                      color: isme?Colors.white:Colors.black,
                    ),),
                    SizedBox(height: 8,),
                    isImage?
                    GestureDetector(
                      onTap: (){
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            content: Container(
                              height: size.height*.6,
                              width: size.width,
                              child: Image.network(message,fit: BoxFit.fill,),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          );
                        });
                      },
                      child: Container(
                        child: Image.network(
                          message,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ):
                    Text(message,style: TextStyle(
                      fontSize: 18,
                      color: isme?Colors.white:Colors.black,
                    ),),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('hh:mm a').format(dateTime),style: TextStyle(
                          fontSize: 10,
                          color: isme?Colors.white:Colors.black,
                        ),),
                        Text('${dateTime.year.toString()}/${dateTime.month.toString()}/${dateTime.day.toString()}',style: TextStyle(
                          fontSize: 10,
                          color: isme?Colors.white:Colors.black,
                        ),),
                      ],
                    ),
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
