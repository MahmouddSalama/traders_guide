import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlackListItem extends StatelessWidget {
  final String id;
  final Function delete;

  const BlackListItem({
    Key? key,
    required this.id,
    required this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blacklist').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            var docs =
                snapshot.data!.docs.firstWhere((element) => element.id == id);
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Text("error");
            else if (snapshot.hasData && snapshot.data!.docs.length != 0) {
              List images = [
                docs['imageUrl0'],
                docs['imageUrl1'],
                docs['imageUrl2'],
              ];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  width: size.width,
                  height: size.height * .35,
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Container(
                          height: size.height * .35,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'صور رفض البنك',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                flex: 3,
                                child: Container(
                                  height: size.height * .25,
                                  width: size.width - 100,
                                  child: CarouselSlider.builder(
                                    options: CarouselOptions(
                                      height: size.height * .25,
                                      autoPlay: true,
                                      reverse: true,
                                    ),
                                    itemCount: images.length,
                                    itemBuilder: (context, index, _) =>
                                        GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Container(
                                                  height: size.height * .6,
                                                  width: size.width,
                                                  child: Image.network(
                                                    images[index],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              );
                                            });
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: Image.network(
                                          images[index],
                                          fit: BoxFit.fill,
                                          width: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            docs['name'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            docs['trak'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            docs['address'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            delete();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('لا يوجد عملاء مدينون'),
              );
            }
          } catch (e) {}
          return Center(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }

  Align buildAlign() {
    return Align(
      alignment: Alignment(.3, 1),
      child: IconButton(
        onPressed: () {
          delete();
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red,
          size: 25,
        ),
      ),
    );
  }
}
