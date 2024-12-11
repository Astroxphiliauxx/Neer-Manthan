// Future<void> _loadUserId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   setState(() {
//     userId = prefs.getInt('userId'); // Retrieve as int
//   });
// }
// Future<void> verifyOtp() async {
//   if (userId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please sign up again.")),
//     );
//     return;
//   }
//
//   if (otpCode.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please enter the OTP.")),
//     );
//     return;
//   }
//
//   setState(() {
//     isLoading = true;
//   });
//
//   try {
//     final url = Uri.parse("http://10.0.2.2:8000/user/$userId/verify_otp/");
//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'otp': otpCode}),
//     );
//
//     // Debugging output
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("OTP Verified Successfully!")),
//       );
//       Navigator.pushReplacementNamed(context, '/login');
//     } else if (response.statusCode == 400) {
//       final responseData = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to verify OTP: ${responseData['error'] ?? "Invalid OTP!"}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to verify OTP: ${response.body}')),
//       );
//     }
//   } catch (error) {
//     print('Error occurred: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("An error occurred during verification!")),
//     );
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }
// Future<void> verifyOtp() async {
//   if (userId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please sign up again.")),
//     );
//     return;
//   }
//
//   if (otpCode == null || otpCode!.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please enter the OTP.")),
//     );
//     return;
//   }
//
//   setState(() {
//     isLoading = true;
//   });
//
//   try {
//     final url = Uri.parse("http://10.0.2.2:8000/user/$userId/verify_otp/");
//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'verify_otp': otpCode}),
//     );
//
//     // Log the response details for debugging
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//
//     // Check if the response is a valid JSON
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("OTP Verified Successfully!")),
//       );
//       Navigator.pushReplacementNamed(context, '/login');
//     } else if (response.statusCode == 400) {
//       final responseData = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to verify OTP: ${responseData['error'] ?? "Invalid OTP!"}')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to verify OTP: ${response.body}')),
//       );
//     }
//   } catch (error) {
//     print('Error occurred: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("An error occurred during verification!")),
//     );
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }