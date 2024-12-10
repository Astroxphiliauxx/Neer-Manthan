import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getSuggestion({
  required String input,
  required String sessionToken,
  required String apiKey,
}) async {
  String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  String request = '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken&components=country:in';

  try {
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['predictions'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  } catch (e) {
    print('Error fetching suggestions: $e');
    return [];
  }
}
