import 'package:flutter/material.dart';
import 'package:forecastfox/constants/app_colors.dart';
import 'package:forecastfox/screens/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  final _destinations = const [
    NavigationDestination(
      icon: (Icon(
        Icons.home_outlined,
        color: Colors.white,
      )),
      label: '',
      selectedIcon: Icon(
        Icons.home,
        color: Colors.white,
      ),
    ),
    NavigationDestination(
      icon: (Icon(
        Icons.search_outlined,
        color: Colors.white,
      )),
      label: '',
      selectedIcon: Icon(
        Icons.search,
        color: Colors.white,
      ),
    ),
    NavigationDestination(
      icon: (Icon(
        Icons.wb_sunny_outlined,
        color: Colors.white,
      )),
      label: '',
      selectedIcon: Icon(
        Icons.wb_sunny,
        color: Colors.white,
      ),
    ),
    NavigationDestination(
      icon: (Icon(
        Icons.settings_outlined,
        color: Colors.white,
      )),
      label: '',
      selectedIcon: Icon(
        Icons.settings,
        color: Colors.white,
      ),
    ),
  ];

  final _screens = [
    const WeatherScreen(),
    const Center(
      child: Text("Search Screen"),
    ),
    const Center(
      child: Text("Weather Screen"),
    ),
    const Center(
      child: Text("Settings Screen"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: AppColors.secondaryBlack,
        ),
        child: NavigationBar(
          destinations: _destinations,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _currentPageIndex,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (value) {
            setState(() {
              _currentPageIndex = value;
            });
          },
        ),
      ),
    );
  }
}
