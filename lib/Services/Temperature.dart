import 'dart:convert';
import 'package:http/http.dart' as http;

class TemperatureService {
  final String apiKey = '48535983e4c6661ebf19a73aae9d9b04';

  Future<double> fetchCurrentTemperature(String location) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double temperature = data['main']['temp'];
        return temperature;
      } else {
        print(
            'Failed to fetch temperature. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching temperature: $e');
    }
    return 0.0;
  }
}
