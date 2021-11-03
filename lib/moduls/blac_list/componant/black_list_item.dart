import 'package:flutter/material.dart';

class BlackListItem extends StatelessWidget {
  final String name;
  final String debartment;
  final String address;
  final String imageUrl;
  final Function delete;

  const BlackListItem({
    Key? key,
    required this.name,
    required this.debartment,
    required this.address,
    required this.imageUrl,
   required this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: size.height * .25,
        child: Stack(
          children: [
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Container(
                height: size.height * .25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Container(
                          width: size.width * .45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                debartment,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                address,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: size.height * .25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                            width: 200,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
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
            )
          ],
        ),
      ),
    );
  }
}
