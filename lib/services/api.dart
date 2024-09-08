import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:forecastfox/constants/constant.dart';
import 'package:http/http.dart' as http;

// import 'package:geolocator/geolocator.dart';

class WeatherApi {
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = "$baseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load weather data: ${response.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>> fetch7DayForecast(String city) async {
    final url = "$baseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load forecast data");
    }
  }

  Future<List<dynamic>?> fetchCitySuggestions(String query) async {
    final url = "$searchBaseUrl?key=$apiKey&q=$query";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
