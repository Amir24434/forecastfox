import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:forecastfox/constants/constant.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Get current location coordinates
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> getLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location permissions are permanently denied, we cannot request permissions",
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  // et latitude and longitude
  Future<Map<String, dynamic>> printCurrentCoordinates() async {
    try {
      Position position = await getLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;
      if (kDebugMode) {
        print('Latitude: $latitude');
      }
      if (kDebugMode) {
        print('Longitude: $longitude');
      }

      final url =
          "$baseUrl?key=$apiKey&q=$latitude,$longitude&days=1&aqi=no&alerts=no";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        return data;
        // Process the data
      } else {
        // Handle the error
        if (kDebugMode) {
          print('Failed to load weather data');
        }
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error fetching data");
    }
  }

  // // Get the city name from the coordinates
  // Future<String> getCityNameFromCoordinates(
  //     double latitude, double longitude) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         latitude, longitude); // Corrected order: latitude, longitude
  //     Placemark place = placemarks[0];
  //     return place.locality ?? "Unknown City";
  //   } catch (e) {
  //     return "Unable to get city name";
  //   }
  // }

  // Get current location and then the city name
  // Future<String> getCurrentLocationCityName() async {
  //   try {
  //     String cityName = await printCurrentCoordinates();
  //     return cityName;
  //   } catch (e) {
  //     return "Error retrieving city name";
  //   }
  // }
}
