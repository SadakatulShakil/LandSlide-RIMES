import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../page/Mobile.dart';
import '../../services/api_service.dart';
import '../../services/user_pref_service.dart';

class ProfileController extends GetxController with GetSingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 3, vsync: this);

  final userService = UserPrefService(); //User service for replacement of Shared pref

  Future logout() async{
    await userService.clearUserData();
    Get.offAll(Mobile(), transition: Transition.upToDown);
    // var response = await http.post(ApiURL.fcm, headers: { HttpHeaders.authorizationHeader: '${userService.userToken}' } );
    // dynamic decode = jsonDecode(response.body) ;
    //
    // Get.defaultDialog(
    //     title: "Alert",
    //     middleText: decode['message'],
    //     textCancel: 'OK',
    //     onCancel: () async {
    //       await userService.clearUserData();
    //       Get.offAll(Mobile(), transition: Transition.upToDown);
    //     }
    // );
  }

  late var id = "".obs;
  late var name = "".obs;
  late var mobile = "".obs;
  late var email = "".obs;
  late var address = "".obs;
  late var type = "".obs;
  late var photo = "${ApiURL.base_url_image}assets/auth/profile.jpg".obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    getSharedPrefData();
  }

  Future getSharedPrefData() async {
    id.value = userService.userId ?? '';
    name.value = userService.userName ?? '';
    mobile.value = userService.userMobile ?? '';
    email.value = userService.userEmail ?? '';
    address.value = userService.userAddress ?? '';
    type.value = userService.userType ?? '';

    if (userService.userPhoto != null && userService.userPhoto!.contains('/assets/auth/')) {
      photo.value = ApiURL.base_url_image + userService.userPhoto!;
    } else {
      photo.value = ApiURL.base_url_image + '/assets/auth/${userService.userPhoto!}';
    }



    nameController.text = name.value;
    emailController.text = email.value;
    addressController.text = address.value;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future updateProfile() async {
    String? token = userService.userToken; // Get current access token

    var params = jsonEncode({
      "id": "${id.value}",
      "fullname": "${nameController.text}",
      "email": "${emailController.text}",
      "address": "${addressController.text}",
      "type": "${userService.userType}"
    });

    try {
      var response = await http.put(
        ApiURL.profile,
        body: params,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token", // Add token to the header
        },
      );

      dynamic decode = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await userService.updateUserData(
          nameController.text,
          emailController.text,
          addressController.text,
          type.value,
        );

        return Get.defaultDialog(
          title: "Success",
          middleText: decode['message'],
          textCancel: 'Ok',
        );
      } else if (response.statusCode == 401 && decode['code'] == 'token_expired') {
        // Handle token expiration — try refreshing
        bool refreshed = await userService.refreshAccessToken();
        if (refreshed) {
          return updateProfile(); // Retry after refreshing the token
        } else {
          return Get.defaultDialog(
            title: "Session Expired",
            middleText: "Please log in again.",
            textCancel: 'Ok',
          );
        }
      } else {
        return Get.defaultDialog(
          title: "Error",
          middleText: decode['message'],
          textCancel: 'Ok',
        );
      }
    } catch (e) {
      return Get.defaultDialog(
        title: "Error",
        middleText: "Something went wrong!",
        textCancel: 'Ok',
      );
    }
  }


  List<bool> selectedLanguage = [false, true].obs;
  Future changeLanguage(int index) async {
    for (int buttonIndex = 0; buttonIndex < selectedLanguage.length; buttonIndex++) {
      if (buttonIndex == index) {
        selectedLanguage[buttonIndex] = true;
      } else {
        selectedLanguage[buttonIndex] = false;
      }
    }
    if(index == 0) {
      await Get.updateLocale(Locale('en', 'US'));
    } else {
      await Get.updateLocale(Locale('bn', 'BD'));
    }
  }

}