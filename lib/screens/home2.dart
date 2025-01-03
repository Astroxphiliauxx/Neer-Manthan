import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/const/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../common_widgets/custom_bg.dart';

class DistrictWellCodeApp extends StatefulWidget {
  @override
  _DistrictWellCodeAppState createState() => _DistrictWellCodeAppState();
}

class _DistrictWellCodeAppState extends State<DistrictWellCodeApp> {
  final Map<String, List<String>> districtData = {
    "Alappuzha": [
      "W23134", "W23142", "W23143", "W23147", "W23148", "W23151", "W23157",
      "W23125", "W23128", "W23133", "W23137", "W23138", "W23139", "W23140",
      "W23152", "W23146", "W23167", "W23177", "W23199", "W23201", "W23202",
      "W23204", "W23184", "W23189", "W23162", "W23176", "W23185", "W23219",
      "W23223", "W30871", "W30875", "W30882", "W30868", "W03604", "W02962",
      "W03001", "W02997", "W02988", "W02977", "W02990", "W02950", "W02949",
      "W02945", "W02948", "W02944", "W02947", "W02983", "W02978", "W02979",
      "W02981", "W02982", "W02956", "W02961", "W02963", "W02935", "W02936",
      "W02934", "W02930", "W21531", "W02953", "W02951", "W02952", "W21530",
      "W02940", "W02976", "W03000", "W02998", "W02975", "W23226", "W23241",
      "W23246", "W23249", "W23254", "W23263", "W23265", "W23283", "W23296",
      "W23309", "W23273", "W23295", "W23303", "W23306", "W23330", "W23331",
      "W23113", "W23115", "W23126", "W23099", "W23100", "W23105", "W23097",
      "W23101", "W23102", "W23124", "W23127", "W23131", "W23132", "W23123",
      "W23141", "W23150", "W23200", "W23188", "W02993", "W02969", "W23233",
      "W30870", "W30889", "W02971", "W02938", "W02937", "W02939", "W30881",
      "W30877", "W30890", "W02984", "W02987", "W02959", "W21865", "W03002",
      "W02927", "W02999", "W02960", "W02957", "W02954", "W02974", "W02996",
      "W03003", "W02925", "W02929", "W02991", "W02958", "W03004", "W02985",
      "W02994", "W02943", "W02928", "W02972", "W02955"
    ],
    "Ernakulam": [
      "W23397", "W23400", "W23401", "W23409", "W23340", "W23347", "W23327",
      "W23358", "W23355", "W23356", "W23357", "W03699", "W23456", "W23458",
      "W23359", "W23361", "W23362", "W23364", "W23365", "W23373", "W23376",
      "W23382", "W23388", "W23414", "W23411", "W23420", "W23403", "W23408"
    ],
    // Add more districts and their well codes as needed
  };


  String? selectedDistrict;
  String? selectedWellCode;
  List<String> wellCodes = [];
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  List<double> futurePrediction = [];
  double? lastPredictedValue;
  bool isLoading = false;

  Future<void> sendSelectedValues() async {
    if (selectedDistrict == null ||
        selectedWellCode == null ||
        monthController.text.isEmpty ||
        yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    final data = {
      "district": selectedDistrict,
      "WLCODE": selectedWellCode,
      "months": monthController.text,
      "years": yearController.text,
    };

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(AppConstants.predictionUrl2);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          futurePrediction = List<double>.from(responseData["Future Predictions"]);
          lastPredictedValue = responseData["Last Predicted Value"];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data processed successfully!")),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to process data: ${response.body}")),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while processing data.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            custom_bg(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Select District"),
                              value: selectedDistrict,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDistrict = newValue;
                                  wellCodes = districtData[newValue] ?? [];
                                  selectedWellCode = null;
                                });
                              },
                              items: districtData.keys.map((district) {
                                return DropdownMenuItem(
                                  value: district,
                                  child: Text(district),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            if (wellCodes.isNotEmpty)
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text("Select Well Code"),
                                value: selectedWellCode,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedWellCode = newValue;
                                  });
                                },
                                items: wellCodes.map((code) {
                                  return DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: monthController,
                              decoration: const InputDecoration(
                                labelText: "Month",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: yearController,
                              decoration: const InputDecoration(
                                labelText: "Year",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: sendSelectedValues,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Submit"),
                    ),
                    const SizedBox(height: 16),
                    if (lastPredictedValue != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "Last Predicted Value: $lastPredictedValue",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (futurePrediction.isNotEmpty)

                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: futurePrediction
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(
                                  entry.key.toDouble(),
                                  entry.value,
                                ))
                                    .toList(),
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                barWidth: 4,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}