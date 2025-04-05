import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'MealDetails.dart';
import 'mealsprovider.dart';

class mealsScreen extends StatefulWidget {
  final String Country;
  const mealsScreen({super.key, required this.Country});

  @override
  State<mealsScreen> createState() => _mealsScreenState();
}

class _mealsScreenState extends State<mealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).fetchMeals(widget.Country);
    });
  }


  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.Country),
      ),
      body: mealProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: mealProvider.meals.length,
        itemBuilder: (context, index) {
          final meal = mealProvider.meals[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: ListTile(
              leading: Image.network(meal['strMealThumb'], width: 100),
              title: Text(meal['strMeal']),
              onTap: () {
                Get.to(mealsDetails(
                  mealName: meal['strMeal'],
                  id: meal['idMeal'],
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
