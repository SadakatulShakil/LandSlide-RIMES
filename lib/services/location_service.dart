import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'api_urls.dart';
import 'user_pref_service.dart';

class LocationService {
  /// Ask for location permission and get current position
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Get.defaultDialog(
        title: "Location Disabled",
        content: const Text("Please enable location services."),
        textConfirm: "Open Settings",
        textCancel: "Cancel",
        onConfirm: () async {
          await Geolocator.openLocationSettings();
          Get.back();
        },
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Get.defaultDialog(
          title: "Permission Needed",
          content: const Text("Location permission is required to proceed."),
          textConfirm: "Try Again",
          textCancel: "Cancel",
          onConfirm: () async {
            Get.back();
            await getCurrentLocation(); // Try again
          },
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Get.defaultDialog(
        title: "Permission Blocked",
        content: const Text(
            "Location permission is permanently denied. Please enable it from App Info > Permissions."),
        textConfirm: "Open App Settings",
        textCancel: "Cancel",
        onConfirm: () async {
          await openAppSettings();
          Get.back();
        },
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  /// Get location, resolve address and store in shared prefs
  Future<void> getLocation() async {
    try {
      final position = await getCurrentLocation();

      if (position == null) {
        getLocation();
        debugPrint("❌ Location permission not granted. Aborting.");
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiURL.location_latlon}?lat=${position.latitude}&lon=${position.longitude}"),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch location name.");
      }

      final decode = jsonDecode(response.body);

      await UserPrefService().saveLocationData(
        position.latitude.toStringAsFixed(5),
        position.longitude.toStringAsFixed(5),
        decode['result']['id'],
        decode['result']['name'],
        decode['result']['upazila'],
        decode['result']['district'],
      );

      debugPrint("✅ Location saved.");
    } catch (e) {
      debugPrint("❌ Location error: $e");
    }
  }

}