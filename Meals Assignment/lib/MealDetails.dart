import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mealsprovider.dart';

class mealsDetails extends StatefulWidget {
  final String mealName;
  final String id;
  const mealsDetails({super.key, required this.mealName, required this.id});

  @override
  State<mealsDetails> createState() => _mealsDetailsState();
}

class _mealsDetailsState extends State<mealsDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).fetchMealDetails(widget.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("${widget.mealName} Details"),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.mealDetails.isEmpty
          ? Center(child: Text("No details found"))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(provider.mealDetails[0]['strMealThumb']),
            SizedBox(height: 20),
            Text(
              provider.mealDetails[0]['strMeal'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Category: ${provider.mealDetails[0]['strCategory']}"),
            Text("Area: ${provider.mealDetails[0]['strArea']}"),
            SizedBox(height: 20),
            Text("Instructions:\n${provider.mealDetails[0]['strInstructions']}"),
            SizedBox(height: 20),
            if (provider.mealDetails[0]['strYoutube'] != null)
              GestureDetector(
                onTap: () => launch(provider.mealDetails[0]['strYoutube']),
                child: Text('Watch on YouTube', style: TextStyle(color: Colors.blue)),
              ),
          ],
        ),
      ),
    );
  }
}
