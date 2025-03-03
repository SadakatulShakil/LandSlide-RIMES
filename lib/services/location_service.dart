import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lanslide_report/services/user_pref_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'api_service.dart';

class LocationService{

  Future<void> getLocation() async {
    Location location = new Location();
    bool _serviceEnabled = await location.serviceEnabled();
    PermissionStatus _permissionGranted = await location.hasPermission();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    //location.enableBackgroundMode(enable: true);
    var position = await location.getLocation();
    print('shakil: $position');

    try {
      var response = await http.get(Uri.parse(ApiURL.location_latlon + "?lat=" + position.latitude.toString() + "&lon=" + position.longitude.toString()));
      var decode = jsonDecode(response.body);
      print('shakil response:  $decode');
      await UserPrefService().saveLocationData(
          position.latitude.toString(),
          position.longitude.toString(),
          decode['result']['id'],
          decode['result']['name'],
          decode['result']['upazila'],
          decode['result']['district']
      );
    } catch (e) {
      print(e.toString());
    }
  }
}