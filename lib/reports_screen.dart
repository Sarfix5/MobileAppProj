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
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color pieChartTextColor = Colors.white;
    Color appBarColor = Colors.black;

    List<Color> monotoneColors = [
      Colors.black,
      Colors.grey[900]!,
      Colors.grey[800]!,
      Colors.grey[700]!,
      Colors.grey[600]!,
      Colors.grey[500]!,
      Colors.grey[400]!,
      Colors.grey[300]!,
      Colors.grey[200]!,
      Colors.grey[100]!,
      Colors.white,
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('REPORT SCREEN',
         style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
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
                  return Center(child: Text("Error: ${snapshot.error.toString()}"));
                } else {
                  final totalAmount = snapshot.data!.fold<double>(0, (sum, item) => sum + double.parse(item['totalAmount'].toString()));
                  int colorIndex = 0;

                  
                  List<PieChartSectionData> sections = snapshot.data!.asMap().entries.map((entry) {
                    int idx = entry.key;
                    Map<String, dynamic> data = entry.value;
                    final color = monotoneColors[idx % monotoneColors.length];
                    final value = double.parse(data['totalAmount'].toString());
                    final percentage = (value / totalAmount * 100).toStringAsFixed(1);

                    return PieChartSectionData(
                      color: color,
                      value: value,
                      title: '$percentage%',
                      radius: 140,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: pieChartTextColor,
                      ),
                      titlePositionPercentageOffset: 0.55,
                    );
                  }).toList();

                  return Center(
                    child: PieChart(
                      PieChartData(
                        sections: sections,
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
                    return Center(child: Text("Error: ${snapshot.error.toString()}"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var expense = snapshot.data![index];
                        final color = monotoneColors[index % monotoneColors.length];

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: ListTile(
                            leading: Icon(Icons.circle, color: color),
                            title: Text(
                              '${expense['title']}: \$${expense['totalAmount'].toStringAsFixed(2)}',
                              style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color ?? Colors.black),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
