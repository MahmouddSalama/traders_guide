import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBlackListItem extends StatefulWidget {
  final String id;

  const AdminBlackListItem({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _AdminBlackListItemState createState() => _AdminBlackListItemState();
}

class _AdminBlackListItemState extends State<AdminBlackListItem> {
  bool loadinf=false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('admin_blacklist')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            var docs =
                snapshot.data!.docs.firstWhere((element) => element.id == widget.id);
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Text("error");
            else if (snapshot.hasData && snapshot.data!.docs.length != 0) {
              List images=[docs['imageUrl0'],docs['imageUrl1'],docs['imageUrl2'],];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                Text('صور رفض البنك',style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold
                                ),),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    height: size.height * .25,
                                    width: size.width - 100,
                                    child: CarouselSlider.builder(
                                      itemCount: images.length,
                                      options: CarouselOptions(
                                        height: size.height*.25,
                                        autoPlay: true,
                                        reverse: true,
                                      ),
                                      itemBuilder:(context,index,_)=> Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: GestureDetector(
                                          onTap: (){
                                            showDialog(context: context, builder: (context){
                                              return AlertDialog(
                                                content: Container(
                                                  height: size.height*.6,
                                                  width: size.width,
                                                  child: Image.network(images[index],fit: BoxFit.fill,),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20)),
                                              );
                                            });
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(22),
                                            child: Image.network(
                                              images[index],
                                              fit: BoxFit.fill,
                                              width: 240,
                                            ),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                loadinf?Center(child: CircularProgressIndicator(),) : Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          buildGestureDetector(
                                              function: () async{
                                                await FirebaseFirestore.instance.collection('blacklist').doc().set({
                                                  'name':docs['name'],
                                                  'trak':docs['trak'],
                                                  'address':docs['address'],
                                                  'imageUrl0': docs['imageUrl0'],
                                                  'imageUrl1': docs['imageUrl1'],
                                                  'imageUrl2': docs['imageUrl2'],
                                                  'userId':docs['userId'],
                                                  'createAt':docs['createAt']
                                                }).then((value)async {
                                                  await FirebaseFirestore.instance.collection('admin_blacklist').doc(widget.id).delete().then((value) {
                                                    setState(() {
                                                      loadinf=false;
                                                    });
                                                  });
                                                });
                                              },
                                              color: Colors.blue,
                                              text: 'قبول',
                                              icon: Icons.add
                                          ),
                                          buildGestureDetector(
                                            function: () async{
                                              await FirebaseFirestore.instance.collection('admin_blacklist').doc(widget.id).delete().then((value) {
                                                setState(() {
                                                  loadinf=false;
                                                });
                                              });
                                            },
                                            color: Colors.red,
                                            text: 'رفض',
                                            icon: Icons.delete,
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
              }
            else if (snapshot.data!.docs.isEmpty) {
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

  GestureDetector buildGestureDetector({text,icon,color,required Function function}) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: color,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 20, color: color),
          ),
        ],
      ),
    );
  }
}
