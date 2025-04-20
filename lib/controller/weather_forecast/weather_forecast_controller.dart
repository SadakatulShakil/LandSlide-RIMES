import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utills/AppColors.dart';
import '../../models/ModelLocation.dart';
import '../../services/api_service.dart';
import '../../services/user_pref_service.dart';

class WeatherForecastController extends GetxController {
  //TODO: Implement WeatherForecastController

  final count = 0.obs;
  var locationId = 1.obs;
  var locationName = "".obs;
  List<ModelLocation> locations = [];
  dynamic forecast = [].obs;
  final userPrefService = UserPrefService();

  @override
  void onInit() {
    super.onInit();
    getLocations();
    getCurrentLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getCurrentLocation() async {
    locationId.value = int.parse(userPrefService.locationId ?? '');
    locationName.value = userPrefService.locationName ?? '';
    getForecast(locationId.value);
  }

  Future getLocations() async {
    var response = await http.get(ApiURL.locations);
    dynamic decode = jsonDecode(response.body);
    decode['result'].forEach((item) {
      ModelLocation modelLocation = new ModelLocation(int.parse(item['id']),
          item['district'], item['upazila'], item['location']);
      locations.add(modelLocation);
    });
  }

  Future getForecast(locationId) async {
    var token = userPrefService.userToken ?? '';
    var lang = Get.locale?.languageCode;

    Map<String, String> requestHeaders = {
      'Authorization': token.toString(),
      'Accept-Language': lang.toString()
    };
    var response = await http.get(Uri.parse(ApiURL.dailyforecast + "?location=$locationId"), headers: requestHeaders);
    dynamic decode = jsonDecode(response.body);
    forecast.value = decode['result'];

    return decode['result'];
  }

  static String _displayStringForOption(ModelLocation option) =>
      option.location;

  void increment() => count.value++;

  Future<void> changeLocation() async {
    return await (showDialog<void>(
      context: Get.overlayContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: AppColors().app_primary,
              width: 1.0,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select you location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text('The data will show according to your location', style: TextStyle(fontSize: 14))
            ],
          ),
          content: SingleChildScrollView(
              child: Autocomplete<ModelLocation>(
                displayStringForOption: _displayStringForOption,
                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "Enter location name",
                      label: Text("Location"),
                      border: OutlineInputBorder(),
                    ),
                    focusNode: focusNode,
                  );
                },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<ModelLocation>.empty();
              }
              return locations.where((ModelLocation option) {
                return option
                    .toString()
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (ModelLocation selection) {
              locationId.value = selection.id;
              locationName.value = selection.location;
              getForecast(locationId.value);
              Navigator.of(context).pop();
            },
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ));
  }
}
