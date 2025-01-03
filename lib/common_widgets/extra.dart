import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/common_widgets/custom_bg.dart';
import 'package:flutter_map/const/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DistrictWellCodeApp2 extends StatefulWidget {
  @override
  _DistrictWellCodeApp2State createState() => _DistrictWellCodeApp2State();
}

class _DistrictWellCodeApp2State extends State<DistrictWellCodeApp2> {
  String? selectedDistrict = 'Agra';
  String? selectedWellCode;
  String? wellCode;
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  double? PredictedValue;
  double? lastPredictedValue;
  List<double> futurePrediction = [];
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
      final url = Uri.parse(AppConstants.predictionUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          futurePrediction = List<double>.from(responseData["Future Predictions"]);

          lastPredictedValue= responseData["Last Predicted Value"];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data sent successfully!")),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send data: ${response.body}")),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while sending data.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final nearestWellName = args['nearestWellName'] ?? 'Unknown';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          custom_bg(),
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Single Dropdown for District
                DropdownButton<String>(
                  hint: const Text(
                    "Select District",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                    ),
                  ),
                  dropdownColor: Colors.transparent,
                  value: selectedDistrict,
                  style: const TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDistrict = newValue;
                      wellCode = nearestWellName;
                      selectedWellCode = null;
                    });
                  },
                  items: ['Agra'].map((district) {
                    return DropdownMenuItem(value: district, child: Text(district));
                  }).toList(),
                ),

                // Dropdown for Well Code
                if (nearestWellName != null && nearestWellName.isNotEmpty)
                  DropdownButton<String>(
                    hint: const Text(
                      "Select Well Code",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    value: selectedWellCode ?? nearestWellName, // Preselect the well code
                    dropdownColor: Colors.transparent,
                    onChanged: (newValue) {
                      setState(() {
                        selectedWellCode = newValue; // Save selection
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: nearestWellName,
                        child: Text(nearestWellName!),
                      ),
                    ],
                  ),

                // Input fields for Month and Year
                TextField(
                  controller: monthController,
                  decoration: const InputDecoration(
                    labelText: "Month",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                  ),
                ),
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(
                    labelText: "Year",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: sendSelectedValues,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                // Loading Indicator or Prediction Graph
                if (isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (futurePrediction.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "Last Predicted Value: $lastPredictedValue",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Prediction Graph:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 200,
                        child: Sparkline(
                          data: futurePrediction,
                          lineColor: Colors.white,
                          pointsMode: PointsMode.all,
                          pointSize: 5.0,
                          pointColor: Colors.red,
                          lineGradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.purple, Colors.purple],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
