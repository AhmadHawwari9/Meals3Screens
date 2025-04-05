import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AreaProvider with ChangeNotifier {
  List<String> _areas = [];
  bool _isLoading = true;

  List<String> get areas => _areas;
  bool get isLoading => _isLoading;

  Future<void> fetchAreas() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/list.php?a=list"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      _areas = (data['meals'] as List).map((area) => area['strArea'].toString()).toList();
    } else {
      throw Exception("Failed to load areas");
    }

    _isLoading = false;
    notifyListeners();
  }
}
