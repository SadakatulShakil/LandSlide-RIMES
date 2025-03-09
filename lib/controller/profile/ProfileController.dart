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
  var photo = "assets/images/profile.png".obs;
  // late var photo = "${ApiURL.base_url_image}assets/auth/profile.jpg".obs;

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
    //photo.value = ApiURL.base_url_image + (userService.userPhoto ?? '');


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
    // var params = jsonEncode({
    //   "id": "${id.value}",
    //   "fullname": "${nameController.text}",
    //   "email": "${emailController.text}",
    //   "address": "${addressController.text}"
    // });
    // var response = await http.put(ApiURL.profile, body: params);
    // dynamic decode = jsonDecode(response.body) ;
    //
    // if(response.statusCode == 200) {
    //
    //   await userService.updateUserData(
    //       nameController.text,
    //       emailController.text,
    //       addressController.text
    //   );
    // }
    //
    // return Get.defaultDialog(
    //     title: "Alert",
    //     middleText: decode['message'],
    //     textCancel: 'Ok'
    // );
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