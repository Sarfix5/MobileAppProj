import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/data_base.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DatabaseHandler dbHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    dbHandler.dbUpdatesStream.listen((_) {
      if (mounted) {
<<<<<<< HEAD
        setState(() {});
=======
        setState(() {
        });
>>>>>>> 3047af8546cb5a67945fc2e08da46134a2ec1011
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Report Screen'),
      ),
<<<<<<< HEAD
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHandler.getAggregatedExpensesByCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error.toString()}"));
                } else {
                  return Center(
                    child: PieChart(
                      PieChartData(
                        sections: snapshot.data!.map((data) {
                          return PieChartSectionData(
                            value: double.parse(data['totalAmount'].toString()),
                            title:
                                '${data['title']}: \$${data['totalAmount'].toStringAsFixed(2)}',
                            radius: 140,
                            titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff)),
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
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: dbHandler.getAggregatedExpensesByCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()}"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var expense = snapshot.data![index];
                        return ListTile(
                          title: Text(
                              '${expense['title']}: \$${expense['totalAmount'].toStringAsFixed(2)}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
=======
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHandler.getAggregatedExpensesByCategory(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          } else {
            return Center(
              child: PieChart(
                PieChartData(
                  sections: snapshot.data!.map((data) {
                    return PieChartSectionData(
                      value: double.parse(data['totalAmount'].toString()),
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
>>>>>>> 3047af8546cb5a67945fc2e08da46134a2ec1011
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
