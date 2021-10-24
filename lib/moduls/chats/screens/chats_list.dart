import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
        elevation: 0,
        title: Text(
          'الدردشات',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
      ),
      body: Center(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chats(),
                      ),
                    );
                  },
                  title: Text(
                    'اسم اسم',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff002A4D)),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.check_outlined,
                        color: Color(0xff002A4D),
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'نص اخر رساله',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff002A4D)),
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHVzZXJ8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                  ),
                  trailing: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xff002A4D),
                    child: Text(
                      '1',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
