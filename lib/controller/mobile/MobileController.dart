import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lanslide_report/page/dashboard.dart';

import '../../services/api_service.dart';
import '../../services/user_pref_service.dart';

class MobileController extends GetxController{
  final TextEditingController mobile = TextEditingController();


  goToDashBoard() async {
    Get.offAll(DashboardPage(), arguments: {'mobile': mobile.value.text}, transition: Transition.leftToRight);
  }

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

  // Future loginClick() async{
  //   var params = jsonEncode({
  //     "mobile": "${mobile.value.text}",
  //     "device": "android"
  //   });
  //   var response = await http.post(ApiURL.login, body: params);
  //   dynamic decode = jsonDecode(response.body) ;
  //   print(decode);
  //   if(response.statusCode != 200) {
  //     return Get.defaultDialog(
  //         title: "Alert",
  //         middleText: decode['message'],
  //         textCancel: 'Ok'
  //     );
  //   }
  //   await UserPrefService().saveUserData(
  //       decode['token'],
  //       decode['result']['id'],
  //       decode['result']['fullname'],
  //       decode['result']['email'],
  //       decode['result']['mobile'],
  //       decode['result']['address'],
  //       decode['result']['photo']
  //   );
  //
  //   Get.offAll(HomeView(), transition: Transition.downToUp, binding: HomeBinding());
  // }
}