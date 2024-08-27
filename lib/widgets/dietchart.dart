// @dart=2.17
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dietchart extends StatelessWidget {
  final double caloriesConsumed;
  final double maxCalories;

  const Dietchart({
    Key? key,
    required this.caloriesConsumed,
    required this.maxCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentConsumed = caloriesConsumed / maxCalories;
    Color progressColor = percentConsumed > 1.0 ? Colors.red : Colors.deepPurple.withOpacity(0.6); // Change color if exceeded

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 40.0, // Increased height
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentConsumed.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${(percentConsumed * 100).toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
            SizedBox(
              height:60 ,
              child: Card(
                color: Colors.white,
                elevation: 0, // Remove shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Calories Consumed Today",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${caloriesConsumed.toStringAsFixed(1)} cal",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
       
      ],
    );
  }
}
