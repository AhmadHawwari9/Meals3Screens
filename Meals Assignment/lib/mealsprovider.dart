import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealProvider with ChangeNotifier {
  List<Map<String, dynamic>> _meals = [];
  List<Map<String, dynamic>> _mealDetails = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get meals => _meals;
  List<Map<String, dynamic>> get mealDetails => _mealDetails;
  bool get isLoading => _isLoading;

  Future<void> fetchMeals(String country) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?a=$country"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _meals = (data['meals'] as List).map((meal) => {
        'strMeal': meal['strMeal'],
        'strMealThumb': meal['strMealThumb'],
        'idMeal': meal['idMeal'],
      }).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMealDetails(String id) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _mealDetails = (data['meals'] as List).map((meal) => {
        'strMeal': meal['strMeal'],
        'strMealThumb': meal['strMealThumb'],
        'strCategory': meal['strCategory'],
        'strInstructions': meal['strInstructions'],
        'strArea': meal['strArea'],
        'strYoutube': meal['strYoutube'],
      }).toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
