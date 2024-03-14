import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/data_base.dart'; // Import your DatabaseHandler

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Create an instance of DatabaseHandler
  final DatabaseHandler dbHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Budget'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHandler.getAggregatedExpensesByCategory(), // Fetch the aggregated expenses data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return  Center(child: Text(snapshot.error.toString())); // Show an error message in case of failure
          } else {

            // titles are empty put titles then it will work i tested by putting titles
            return Center(
              child: PieChart(
                PieChartData(
                  // sections: _getSections(snapshot.data!), // Convert data to pie chart sections
                  sections: snapshot.data!.map((data) {
                    return PieChartSectionData(
                      value: data['totalAmount'],
                      title: '${data['title']}: \$${data['totalAmount'].toStringAsFixed(2)}',
                      radius: 140,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
                      titlePositionPercentageOffset: 0.55,
                    );
                  }).toList(),
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                ),
              ),
            );
          }
        },
      ),
    );
  }



  // Helper function to convert aggregated expenses data into pie chart sections
  List<PieChartSectionData> _getSections(List<Map<String, dynamic>> aggregatedExpenses) {
     return aggregatedExpenses.map((data) {
       final double radius = 100; // You can adjust the radius as needed
       final double fontSize = 16; // Adjust the font size as needed
       final double titlePositionPercentageOffset = 0.55; // Adjust the title position as needed
       return PieChartSectionData(
         color: Colors.primaries[aggregatedExpenses.indexOf(data) % Colors.primaries.length],
         // value: data['totalAmount'],
        value: data['totalAmount'],
         title: '${data['title']}: \$${data['totalAmount'].toStringAsFixed(2)}',
         radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        titlePositionPercentageOffset: titlePositionPercentageOffset,
      );
     }).toList();
   }

}

