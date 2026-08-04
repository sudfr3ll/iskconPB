import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iskcon/constants/provider.dart';
import 'package:iskcon/models/typeSense.dart';
import 'package:iskcon/screens/Videos/videoPlayer.dart';
import 'package:iskcon/screens/audio/newAudioPlayer.dart';
import 'package:iskcon/widgets/customAppBar.dart';
import 'package:provider/provider.dart';

class SerachPage extends StatefulWidget {
  const SerachPage({super.key});

  @override
  State<SerachPage> createState() => _SerachPageState();
}

class _SerachPageState extends State<SerachPage> {
  final TextEditingController _editingController = TextEditingController();
  bool isLoading = false;
  List listofName = [];
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).getTypsenseCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: 'Search')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _editingController,
              onChanged: (value) async {
                setState(() {
                  isLoading = true;
                });
                await TypeSenseInstance(
                        apiKey: provider.apiKye!,
                        host: provider.host!,
                        port: provider.port!)
                    .searchProductTS(value)
                    .then((value1) {
                  setState(() {
                    listofName.addAll(value1);
                    listofName = value1;
                    isLoading = false;
                  });
                });
              },
              validator: (value) {
                if (value!.isEmpty || value.isEmpty) {
                  return 'Enter the name';
                } else {
                  return null;
                }
              },
              enabled: true,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: 'Search here',
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(10))),
            ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       hintText: 'Search', suffixIcon: Icon(Icons.search)
            //       // suffix: Icon(Icons.search,color: Colors.black,)
            //       ),
            //   onChanged: (value) async {
            //     setState(() {
            //       isLoading = true;
            //     });
            //     await TypeSenseInstance().searchProductTS(value).then((value1) {
            //       setState(() {
            //         listofName.addAll(value1);
            //         listofName = value1;
            //         isLoading = false;
            //       });
            //     });
            //   },
            // ),
            Expanded(
              flex: 8,
              child: isLoading == true
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.purple,
                        ),
                        SizedBox(height: 4),
                        Text('Loading...')
                      ],
                    ))
                  : listofName.isEmpty
                      ? Center(
                          child: Text('No Data Found..'),
                        )
                      : _editingController.text.isEmpty
                          ? Center(
                              child: Text('No Data Found..'),
                            )
                          : ListView.builder(
                              itemCount: listofName.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = listofName[index];
                                return ListTile(
                                  onTap: () {
                                    String newId = '';

                                    print(data['url']);

                                    if (data['type'] == 'Videos') {
                                      newId = data['url'].toString().replaceAll(
                                            'https://www.youtube.com/watch?v=',
                                            '',
                                          );
                                    }

                                    FocusScope.of(context).unfocus();

                                    data['type'] == 'Videos'
                                        ? Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  MyVideoPlayer(
                                                data: data,
                                                topTitle: data['title'],
                                                videoLink: newId,
                                              ),
                                            ),
                                          )
                                        : data['type'] == 'Audios'
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return MyAudioApp(
                                                      index: index,
                                                      title: data['title'],
                                                      audioLink: data['url'],
                                                      id: data['id'],
                                                      data: listofName
                                                          .where(
                                                            (element) =>
                                                                element[
                                                                    'type'] ==
                                                                'Audios',
                                                          )
                                                          .toList(),
                                                      imageLink:
                                                          'assets/images/musicimage.jpg',
                                                    );
                                                  },
                                                ),
                                              )
                                            : null;
                                  },
                                  leading: data['type'] == 'Videos'
                                      ? SvgPicture.asset(
                                          'assets/svg/003-video-camera.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        )
                                      : data['type'] == 'Audios'
                                          ? SvgPicture.asset(
                                              'assets/svg/010-musical-note.svg',
                                              color: Colors.black,
                                              height: 20,
                                            )
                                          : data['type'] == 'Blogs'
                                              ? SvgPicture.asset(
                                                  'assets/svg/008-eye.svg',
                                                  color: Colors.black,
                                                  height: 20,
                                                )
                                              : data['type'] == 'Events'
                                                  ? SvgPicture.asset(
                                                      'assets/svg/005-calendars.svg',
                                                      color: Colors.black,
                                                      height: 20,
                                                    )
                                                  : data['type'] == 'News'
                                                      ? SvgPicture.asset(
                                                          'assets/svg/009-newspaper.svg',
                                                          color: Colors.black,
                                                          height: 20,
                                                        )
                                                      : data['type'] ==
                                                              'Pictures'
                                                          ? SvgPicture.asset(
                                                              'assets/svg/004-picture.svg',
                                                              color:
                                                                  Colors.black,
                                                              height: 20,
                                                            )
                                                          : null,
                                  title: data['type'] == 'Pictures'
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: data['image']['mob']
                                                  .toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 100,
                                                // width: 100,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    // fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      // Image.network(
                                      //     data['image']['mob'].toString(),
                                      //     height: 100,
                                      //     fit: BoxFit.cover,

                                      //     errorBuilder:
                                      //         (context, error, stackTrace) {return},

                                      //   )
                                      : Text(data['title']),
                                );
                              }),
            ),
          ],
        ),
      ),
    );
  }
}
