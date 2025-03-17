
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'MealDetails.dart';

class mealsScreen extends StatefulWidget {
  String? Country;
  mealsScreen({super.key,required this.Country});



  @override
  State<mealsScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<mealsScreen> {
  List<Map<String, dynamic>> Meals = [];
  bool isLoading=true;



  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals()async{
    final response =await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?a=${widget.Country}"));
    if(response.statusCode==200){
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        Meals = (data['meals'] as List)
            .map((meal) => {
          'strMeal': meal['strMeal'],
          'strMealThumb': meal['strMealThumb'],
          'idMeal': meal['idMeal']
        })
            .toList();
        isLoading = false;
      });
    }
    else{
      throw Exception("faild to load meals");
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,

        title: Text("${widget.Country}"),
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),):
      ListView.builder(
          itemCount: Meals.length,
          itemBuilder: (context,index){
            final meal=Meals[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Container(
                height: screenHeight * 0.09,
                child: ListTile(
                  leading: Container(
                    width: screenWidth*0.4,
                      height: screenHeight * 0.15,
                      child: Image.network(meal['strMealThumb'],fit: BoxFit.cover,)),
                  title: Text(meal['strMeal']),
                  onTap: (){
                    print(meal['idMeal']);
                    Get.to(mealsDetails(mealName: meal['strMeal'], id: meal['idMeal'],));
                  },
                ),
              ),
            );
          })
      ,
    );
  }
}
