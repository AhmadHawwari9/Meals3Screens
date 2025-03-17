import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class mealsDetails extends StatefulWidget {
  String? mealName;
  String? id;
  mealsDetails({super.key, required this.mealName, required this.id});

  @override
  State<mealsDetails> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<mealsDetails> {
  List<Map<String, dynamic>> MealDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.id}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        MealDetails = (data['meals'] as List)
            .map((meal) => {
          'strMeal': meal['strMeal'],
          'strMealThumb': meal['strMealThumb'],
          'strCategory': meal['strCategory'],
          'strInstructions': meal['strInstructions'],
          'strArea': meal['strArea'],
          'strYoutube': meal['strYoutube'],
        })
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load ${widget.mealName} details");
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("${widget.mealName} Details"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  MealDetails[0]['strMealThumb'],
                  fit: BoxFit.cover,
                  width: screenWidth,
                  height: screenHeight * 0.3,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              MealDetails[0]['strMeal'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Category: ${MealDetails[0]['strCategory']}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Area: ${MealDetails[0]['strArea']}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Instructions:\n${MealDetails[0]['strInstructions']}",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            MealDetails[0]['strYoutube'] != null
                ? GestureDetector(
              onTap: () {
                launch(MealDetails[0]['strYoutube']);
              },
              child: Text(
                'Watch on YouTube',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
