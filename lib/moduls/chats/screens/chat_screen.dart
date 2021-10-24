
import 'package:financial_dealings/moduls/chats/componant/defualt_field.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          title: Text('اسم اسم',style: TextStyle(
            color: Colors.black
          ),),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHVzZXJ8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(child: Text('gfhbrf')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultField(hint: 'اكتب رسالتك',elevation: 0,),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(0xff002A4D),
                    onPressed: () {},
                    child: Icon(Icons.send),
                    mini: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
