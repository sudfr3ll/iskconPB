// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:typesense/typesense.dart';

class TypeSenseInstance {
  late final config;
  late final client;
  final String apiKey;
  final String host;
  final int port;

  TypeSenseInstance(
      {required this.apiKey, required this.host, required this.port}) {
    config = Configuration(apiKey,
        nodes: {
          Node(
            Protocol.https,
            host,
            port: port,
          )
        },
        connectionTimeout: const Duration(seconds: 2));
    client = Client(config);
  }

  Future<List> searchProductTS(String search) async {
    List searchList = [];

    final searchPerameters = {
      'q': search,
      'query_by': 'keywords',
      'per_page': '20',
      // 'page': '1', m
    };
    try {
      final result = await client
          .collection('bwi-iskon-dev-collections')
          .documents
          .search(searchPerameters);

      // print("\n\nresult = $result\n\n");
      var data = result['hits'];
 
      // print("data = $data");

      data.forEach((value) {
        var element = value['document'];
        print(element);
        searchList.add(element);
      });

      return searchList;
    } catch (e) {
      print("error while searching products");
      print("Error is : $e");

      return searchList;
    }
  }

  // Future<List<Vendors>> searchVender(String vSearch) async {
  //   List<Vendors> vList = [];
  //   String userlat = '28.691711142239868';
  //   String userlog = '77.14981604312834';
  //   final searchPerameters = {
  //     'q': vSearch,
  //     'query_by': 'name',
  //     'filter_by': 'vendorLocation:($userlat, $userlog, 1000 km)',
  //     'sort_by': 'vendorLocation($userlat, $userlog):asc',
  //     // 'page': 1,
  //     // 'per_page': 250
  //   };

  //   print("searchperamerters = $searchPerameters");

  //   try {
  //     final result = await client
  //         .collection('vendorProducts')
  //         .documents
  //         .search(searchPerameters);

  //     print("vendor result = ${result['hits'][0]['document']}");

  //     result['hits'].forEach((element) {
  //       var data = element['document'];

  //       vList.add(Vendors(
  //           id: data['id'],
  //           discount: double.parse('${data['discount']}'),
  //           image_url: data['image_url'],
  //           name: data['name'],
  //           productId: data['productId'],
  //           quantity: data['quantity'],
  //           vendorId: data['vendorId'],
  //           vendorLocation: data['vendorLocation'],
  //           vendorName: data['vendorName'],
  //           vendorPhone: data['vendorPhone']));
  //     });

  //     return vList;
  //   } catch (e) {
  //     print("error while searching vendor");
  //     print("Error : $e");
  //     return vList;
  //   }
  // }
}
