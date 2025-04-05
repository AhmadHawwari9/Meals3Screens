import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'MealsScreen.dart';
import 'areaprovider.dart';

class areaScreebdisplay extends StatefulWidget {
  const areaScreebdisplay({super.key});

  @override
  State<areaScreebdisplay> createState() => _areaScreebdisplayState();
}

class _areaScreebdisplayState extends State<areaScreebdisplay> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AreaProvider>(context, listen: false).fetchAreas();
    });
  }


  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Area screen display"),
      ),
      body: areaProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: areaProvider.areas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(areaProvider.areas[index]),
            onTap: () {
              Get.to(mealsScreen(Country: areaProvider.areas[index]));
            },
          );
        },
      ),
    );
  }
}
