import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/widgets/MessageWidget.dart';
import 'package:iskcon/widgets/customAppBar.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final carousel.CarouselSliderController _carouselController =
      carousel.CarouselSliderController();

  late final Future<dynamic> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = DataBaseSerice().messageList();
  }

  String _imageUrl(Map<String, dynamic> data) {
    final resizedImage = data['resizedCoverImage'];

    if (resizedImage is Map) {
      final thumbnail = resizedImage['thumb'];
      if (thumbnail is String && thumbnail.isNotEmpty) {
        return thumbnail;
      }
    }

    final coverImage = data['coverImage'];
    return coverImage is String ? coverImage : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(title: 'MESSAGE'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navigationButton(
                  label: 'PREV',
                  icon: Icons.arrow_back_ios,
                  onPressed: _carouselController.previousPage,
                ),
                _navigationButton(
                  label: 'NEXT',
                  icon: Icons.arrow_forward_ios,
                  iconAfterLabel: true,
                  onPressed: _carouselController.nextPage,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<dynamic>(
                future: _messagesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Unable to load messages: ${snapshot.error}'),
                    );
                  }

                  final docs = snapshot.data?.docs;
                  if (docs == null || docs.isEmpty) {
                    return const Center(child: Text('No messages available.'));
                  }

                  return carousel.CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: docs.length,
                    itemBuilder: (context, index, realIndex) {
                      final document = docs[index];
                      final data =
                          Map<String, dynamic>.from(document.data() as Map);
                      final createdAt = data['createdAt'];
                      final date = createdAt == null
                          ? ''
                          : DateFormat('dd MMMM yyyy')
                              .format(createdAt.toDate());

                      return MessageWidget(
                        data: document,
                        date: date,
                        imgContent: data['imgContent'] ?? '',
                        imgUrl: _imageUrl(data),
                        para1: data['messageContent'] ?? '',
                        author: data['author'] ?? '',
                      );
                    },
                    options: carousel.CarouselOptions(
                      initialPage: 0,
                      autoPlay: false,
                      height: MediaQuery.sizeOf(context).height * 0.66,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigationButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool iconAfterLabel = false,
  }) {
    final children = <Widget>[
      Icon(icon, size: 15),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w400)),
    ];

    return SizedBox(
      width: 85,
      height: 36,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(17, 112, 114, 1),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconAfterLabel ? children.reversed.toList() : children,
        ),
      ),
    );
  }
}
