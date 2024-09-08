import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:forecastfox/services/api.dart';
import 'package:forecastfox/services/geolocate.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  Map<String, dynamic>? _currentWeather;
  final TextEditingController _typeAheadController = TextEditingController();

  String _cityName = 'Fetching city name...';

  @override
  void initState() {
    super.initState();
    _fetchCityName();
  }

  Future<void> _fetchCityName() async {
    LocationService locationService = LocationService();
    try {
      final cityName = await locationService.printCurrentCoordinates();
      setState(() {
        _currentWeather = cityName;
        _cityName = _currentWeather?['location']['name'] ?? 'Unknown';
      });
    } catch (e) {
      setState(() {
        _cityName = 'Error retrieving city name';
      });
    }
  }

  Future<void> _fetchWeather([String? city]) async {
    try {
      if (city != null) {
        _cityName = city;
      } else {
        await _fetchCityName();
      }
      final weatherData = await _weatherApi.fetchCurrentWeather(_cityName);
      setState(() {
        _currentWeather = weatherData;
        _cityName = _currentWeather?['location']['name'] ?? 'Unknown';
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _currentWeather == null
            ? Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A2344),
                      Color.fromARGB(255, 125, 32, 142),
                      Colors.purple,
                      Color.fromARGB(255, 151, 44, 170),
                    ],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A2344),
                      Color.fromARGB(255, 125, 32, 142),
                      Colors.purple,
                      Color.fromARGB(255, 151, 44, 170),
                    ],
                  ),
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _cityName,
                          style: GoogleFonts.lato(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _showCitySelectionDialog,
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Image.network(
                            'http:${_currentWeather!['current']['condition']['icon']}',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            '${_currentWeather!['current']['temp_c'].round()}°C',
                            style: GoogleFonts.lato(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_currentWeather!['current']['condition']['text']}',
                            style: GoogleFonts.lato(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Max: ${_currentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Min: ${_currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherDetail(
                          "Sunrise",
                          Icons.wb_sunny,
                          _currentWeather!['forecast']['forecastday'][0]
                              ['astro']['sunrise'],
                        ),
                        _buildWeatherDetail(
                          'Local Time',
                          Icons.brightness_1_rounded,
                          _currentWeather!['location']['localtime']
                              .split(" ")
                              .last,
                        ),
                        _buildWeatherDetail(
                          'Sunset',
                          Icons.brightness_1_rounded,
                          _currentWeather!['forecast']['forecastday'][0]
                              ['astro']['sunset'],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherDetail(
                          "Humidity",
                          Icons.opacity,
                          _currentWeather!['current']['humidity'],
                        ),
                        _buildWeatherDetail(
                          'Date',
                          Icons.brightness_1_rounded,
                          _currentWeather!['location']['localtime']
                              .split(" ")
                              .first,
                        ),
                        _buildWeatherDetail(
                          'Wind (KPH)',
                          Icons.wind_power,
                          _currentWeather!['current']['wind_kph'],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, IconData icon, dynamic value) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: const EdgeInsets.all(5),
            width: size.width * 0.25,
            height: size.height * 0.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  const Color(0xFF1A2344).withOpacity(0.5),
                  const Color(0xFF1A2344).withOpacity(0.2),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value is String ? value : value.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCitySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter City Name"),
          content: TypeAheadField(
            controller: _typeAheadController,
            suggestionsCallback: (pattern) async {
              return await _weatherApi.fetchCitySuggestions(pattern);
            },
            itemBuilder: (BuildContext context, suggestion) {
              return ListTile(
                title: Text(suggestion['name']),
              );
            },
            showOnFocus: true,
            onSelected: (suggestion) {
              _typeAheadController.text = suggestion['name'];
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Get the city name from the typeahead controller and fetch weather
                final city = _typeAheadController.text;
                _fetchWeather(city);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
