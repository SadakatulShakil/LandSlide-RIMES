import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lanslide_report/services/user_pref_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'api_service.dart';

class LocationService {
  final Location location = Location();

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          if (kDebugMode) print("Location service not enabled.");
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          if (kDebugMode) print("Location permission denied.");
          return;
        }
      }

      // Enable background mode for location updates (if needed)
      bool backgroundEnabled = await location.enableBackgroundMode(enable: true);
      if (kDebugMode) print("Background mode enabled: $backgroundEnabled");

      // Get current location
      LocationData position = await location.getLocation();
      if (kDebugMode) print('Current Position: $position');

      // Fetch location details from API
      var response = await http.get(Uri.parse(
          "${ApiURL.location_latlon}?lat=${position.latitude}&lon=${position.longitude}"));

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        if (kDebugMode) print('API Response: $decode');

        await UserPrefService().saveLocationData(
          position.latitude.toString(),
          position.longitude.toString(),
          decode['result']['id'],
          decode['result']['name'],
          decode['result']['upazila'],
          decode['result']['district'],
        );
      } else {
        if (kDebugMode) print("API request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) print("Error in getLocation: ${e.toString()}");
    }
  }
}
