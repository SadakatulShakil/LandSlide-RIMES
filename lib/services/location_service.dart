import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lanslide_report/services/user_pref_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'api_service.dart';

class LocationService {


  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      throw Exception('Location services are disables.');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        throw Exception('Location permissions are denied.');
      }
    }

    if(permission == LocationPermission.deniedForever){
      throw Exception('Location permissions are permanently denied, we cannot request permissions');
    }

    return await Geolocator.getCurrentPosition();

  }



  Future<void> getLocation() async {

    final position = await getCurrentLocation();

    try {
      var response = await http.get(Uri.parse(ApiURL.location_latlon + "?lat=" + position.latitude.toString() + "&lon=" + position.longitude.toString()));
      var decode = jsonDecode(response.body);
      print('shakil ${decode}');
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