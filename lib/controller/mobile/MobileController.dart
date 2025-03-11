import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lanslide_report/controller/navigation/navigation_binding.dart';
import 'package:lanslide_report/page/dashboard.dart';

import '../../page/navigation_view.dart';
import '../../services/api_service.dart';
import '../../services/user_pref_service.dart';

class MobileController extends GetxController{
  final TextEditingController mobile = TextEditingController();
  final userPrefService = UserPrefService();
  var isChecking = true.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  Future checkLogin() async {
    print('shakil token: ${userPrefService.userToken}');
    if(userPrefService.userToken != null && userPrefService.userToken!.isNotEmpty) {
      Get.offAll(NavigationView(), transition: Transition.downToUp, binding: NavigationBinding());
    }else {
      isChecking.value = false; // Stop loading, show login page
    }
  }

  // goToDashBoard() async {
  //   Get.offAll(NavigationView(), arguments: {'mobile': mobile.value.text}, transition: Transition.leftToRight);
  // }

  // gotoOTP() async {
  //   var params = jsonEncode({ "mobile": "${mobile.value.text}" });
  //   var response = await http.post(ApiURL.mobile, body: params);
  //   dynamic decode = jsonDecode(response.body) ;
  //   if(response.statusCode != 200) {
  //     return Get.defaultDialog(
  //         title: "Alert",
  //         middleText: decode['message'],
  //         textCancel: 'Ok'
  //     );
  //   } else {
  //     Get.to(Otp(), arguments: {'mobile': mobile.value.text}, transition: Transition.leftToRight);
  //   }
  // }

  Future loginClick() async{
    // var params = jsonEncode({
    //   "mobile": "${mobile.value.text}",
    //   "device": "android"
    // });
    // var response = await http.post(ApiURL.login, body: params);
    // dynamic decode = jsonDecode(response.body) ;
    // print(decode);
    // if(response.statusCode != 200) {
    //   return Get.defaultDialog(
    //       title: "Alert",
    //       middleText: decode['message'],
    //       textCancel: 'Ok'
    //   );
    // }
    await UserPrefService().saveUserData(
        'ackjsdkdvncjnjcdfwfjdhfgjhgfjhfjhgfjhgjfg',
        'LS3456',
        'Shakil Ajam',
        'shakil@rimes.int',
        '01751330394',
        'Mohammadpur, Dhaka',
        ''
    );

    Get.offAll(NavigationView(), transition: Transition.downToUp, binding: NavigationBinding());
  }
}