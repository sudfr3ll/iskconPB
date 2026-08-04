// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:iskcon/constants/databaseService.dart';
import 'package:iskcon/models/cityModel.dart';
import 'package:iskcon/models/stateModel.dart';

class ApiConstant {
  Dio dio = Dio();
  var isLoading = false;
  Future<void> dioUse() async {
    try {
      Response response = await dio.get(
        'https://api.countrystatecity.in/v1/countries/IN/states',
        options: Options(headers: {
          "X-CSCAPI-KEY":
              "dmRQYzNHR216WmdxcUpIbzI1VEI2VUtGeHZuVFVZM0xlaDlhTTA3OA=="
        }),
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
      print(response);
    } catch (e) {
      print(e);
    }
  }

  Future<List<States>> getStates() async {
    final response = await http.get(
        Uri.parse('https://api.countrystatecity.in/v1/countries/IN/states'),
        headers: {
          "X-CSCAPI-KEY":
              "dmRQYzNHR216WmdxcUpIbzI1VEI2VUtGeHZuVFVZM0xlaDlhTTA3OA=="
        });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List.generate(jsonResponse.length, (index) {});
      return jsonResponse.map((data) => States.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<List<Cities>> getCities(String stateCode) async {
    final response = await http.get(
        Uri.parse(
            'https://api.countrystatecity.in/v1/countries/IN/states/$stateCode/cities'),
        headers: {
          "X-CSCAPI-KEY":
              "dmRQYzNHR216WmdxcUpIbzI1VEI2VUtGeHZuVFVZM0xlaDlhTTA3OA=="
        });
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      return jsonResponse.map((data) => Cities.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future youtubeLiveApi() async {
    var apiKey;
    // print('List is : ${reponse.data['items']}');
    // print('a;sdjf;lsajd;flals;d;fjsl;d');
    // for (int i = 0; i <= jsonResponse.length; i++) {
    //   print(jsonResponse[i]);
    // // }
    // print('Youtube Data : $jsonResponse');

    await DataBaseSerice()
        .getYoutubekey()
        .then((DocumentSnapshot documentSnapshot) async {
      apiKey = documentSnapshot.get('apiKey');
      print('Api key is : $apiKey');
    });
    print('Api is Running......');
    var response = await http.get(Uri.parse(apiKey));
    dynamic jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = response;
      return response;
    } else {
      print('Erorrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      return response;
    }
  }
}
