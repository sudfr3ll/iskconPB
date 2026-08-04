import 'package:flutter/material.dart';

class ShowDescription extends StatelessWidget {
  dynamic data;
  String title;
  String description;
  String image;
  ShowDescription(
      {super.key,
      required this.data,
      required this.description,
      required this.image,
      required this.title});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: size.height * 0.6,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(alignment: Alignment.center, child: Icon(Icons.drag_handle)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        image,
                        height: 150,
                        width: size.width,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 120,
                            width: size.width * 0.5,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: title, style: TextStyle(color: Colors.black))
                      ], style: Theme.of(context).textTheme.titleLarge!),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: description,
                            style: TextStyle(color: Colors.black54))
                      ], style: Theme.of(context).textTheme.titleSmall),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
