import 'dart:convert';

import 'package:bloodlife/models/healthchannelheadlinesmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<healthchannelsmodels> fetchnewschannelheadlinesapi() async {
    String url =
        "https://newsapi.org/v2/everything?q=health&apiKey=be9a7bed1cc345a682c6cf105e760f8d";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return healthchannelsmodels.fromJson(body);
    }
    throw Exception('error');
  }
}
