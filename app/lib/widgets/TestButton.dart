import 'package:flutter/material.dart';
import 'package:iskcon/constants/apiConstant.dart';

class TestApi extends StatefulWidget {
  const TestApi({super.key});

  @override
  State<TestApi> createState() => _TestApiState();
}

class _TestApiState extends State<TestApi> {
  dynamic data;

  Future<void> getData() async {
    data = await ApiConstant().youtubeLiveApi();
    print(data.body);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: TextButton(onPressed: () {}, child: Text('Hit Api Here...'))),
    );
  }
}
