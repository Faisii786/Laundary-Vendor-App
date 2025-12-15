import 'dart:convert';
import 'package:flutter/services.dart';

class LocationService {
  static List<Map<String, dynamic>> _countries = [];
  static List<Map<String, dynamic>> _states = [];
  static List<Map<String, dynamic>> _cities = [];

  static Future<void> initialize() async {
    // Load countries
    final countriesString = await rootBundle.loadString('data/countries.json');
    _countries = List<Map<String, dynamic>>.from(json.decode(countriesString));

    // Load states
    final statesString = await rootBundle.loadString('data/states.json');
    _states = List<Map<String, dynamic>>.from(json.decode(statesString));

    // Load cities
    final citiesString = await rootBundle.loadString('data/cities.json');
    _cities = List<Map<String, dynamic>>.from(json.decode(citiesString));
  }

  static List<Map<String, dynamic>> getCountries() {
    return _countries;
  }

  static List<Map<String, dynamic>> getStatesByCountry(String countryId) {
    return _states.where((state) => state['country_id'].toString() == countryId).toList();
  }

  static List<Map<String, dynamic>> getCitiesByState(String stateId) {
    return _cities.where((city) => city['state_id'].toString() == stateId).toList();
  }

  static String? getCountryName(String id) {
    try {
      return _countries.firstWhere((country) => country['id'].toString() == id)['name'];
    } catch (e) {
      return null;
    }
  }

  static String? getStateName(String id) {
    try {
      return _states.firstWhere((state) => state['id'].toString() == id)['name'];
    } catch (e) {
      return null;
    }
  }

  static String? getCityName(String id) {
    try {
      return _cities.firstWhere((city) => city['id'].toString() == id)['name'];
    } catch (e) {
      return null;
    }
  }
}