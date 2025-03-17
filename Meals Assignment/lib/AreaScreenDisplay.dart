import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'MealsScreen.dart';
class areaScreebdisplay extends StatefulWidget {
  areaScreebdisplay({super.key});



  @override
  State<areaScreebdisplay> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<areaScreebdisplay> {

  @override
  void initState() {
    super.initState();
    fetchAreas();
  }

  List<String> areas=[];
  bool isLoading=true;

  Future<void> fetchAreas() async {
    final response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/list.php?a=list"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        areas = (data['meals'] as List)
            .map((area) => area['strArea'].toString())
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load areas");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,

        title: Text("Area screen display"),
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),)
          :ListView.builder(
        itemCount: areas.length,
      itemBuilder:(context,index){
          return ListTile(
            title: Text(areas[index]),
            onTap: (){
              print(areas[index]);
              Get.to(mealsScreen(Country: areas[index],));
            },
          );
      }
      ),
    );
  }
}
