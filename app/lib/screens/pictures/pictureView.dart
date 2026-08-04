// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

class PictureViewList extends StatefulWidget {
  final dynamic data;
  final int index;
  const PictureViewList({super.key, this.data, required this.index});

  @override
  State<PictureViewList> createState() => _PictureViewListState();
}

class _PictureViewListState extends State<PictureViewList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final carousel.CarouselSliderController controller =
      carousel.CarouselSliderController();
  void carouselPrev() => controller.previousPage();
  void carouselNext() => controller.nextPage();
  int initalIndex = 0;
  int selectedIndex = 0;
  bool isLoading = false;
  bool show = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    setState(() {
      initalIndex = widget.index;
      selectedIndex = widget.index;
    });
  }

  void shareImage() async {
    setState(() {
      isLoading = true;
    });

    final response = await get(
      Uri.parse(widget.data[selectedIndex]['image']['mob']),
    );

    final Directory temp = await getTemporaryDirectory();

    final File imageFile = File(
      '${temp.path}/${widget.data[selectedIndex]['title']}.png',
    );

    await imageFile.writeAsBytes(response.bodyBytes);

    SharePlus.instance
        .share(ShareParams(files: [XFile(imageFile.path)]))
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> Image_Downloader() async {
}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    PageController pageController = PageController(initialPage: initalIndex);

    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  show = true;
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      show = false;
                    });
                    print(show);
                  });
                });
              },
              child: PhotoViewGallery.builder(
                pageController: pageController,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: ((value) {
                  setState(() {
                    selectedIndex = value;
                    print(selectedIndex);
                  });
                }),
                itemCount: widget.data.length,
                builder: ((context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      widget.data[index]['image']['org'],
                    ),
                    //      Image.network(
                    //   widget.data[index]['image']['mob'],
                    //   // loadingBuilder: (BuildContext context, Widget child,
                    //   //     ImageChunkEvent? loadingProgress) {
                    //   //   if (loadingProgress == null) return child;
                    //   //   return SizedBox(
                    //   //     height: 120,
                    //   //     width: size.width * 0.5,
                    //   //     child: Center(
                    //   //       child: Image.asset('assets/images/defImage.png')
                    //   //     ),
                    //   //   );
                    //   // },
                    // )
                  );
                }),
                // options: CarouselOptions(

                //   enableInfiniteScroll: false,
                //   initialPage: initalIndex,
                //   autoPlay: false,
                //   height: MediaQuery.of(context).size.height,
                //   enlargeCenterPage: true,
                //   viewportFraction: 1,
                // ),
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 12.0, vertical: 32),
            //     child: Container(
            //         padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
            //         child: SizedBox(
            //             height: 80.0, width: 80.0, child: _offsetPopup())),
            //   ),
            // ),
            show == false
                ? SizedBox()
                : Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      alignment: Alignment.topLeft,
                      color: Colors.transparent,
                      height: size.height * 2,
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              _offsetPopup(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        onTap: () {
          //         showDialog(
          // context: context,
          // builder: (context) {
          //   return Dialog(
          //     child: Container(
          //       height: 100,
          //       width: 100,
          //       child: Center(child: CircularProgressIndicator()),
          //     ),
          //   );
          // });
          shareImage();
        },
        value: 1,
        child: Wrap(
          children: [
            Icon(Icons.share),
            SizedBox(width: 10),
            Text(
              "Share",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: () => Image_Downloader(),
        value: 2,
        child: Wrap(
          children: [
            Icon(Icons.download),
            SizedBox(width: 10),
            Text(
              "Download",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
    icon: Icon(Icons.more_vert, color: Colors.white),
  );
}
