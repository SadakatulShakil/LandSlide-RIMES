import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  var selectedImagePath = ''.obs;
  var isConfirmVisible = false.obs; // To show/hide the confirm button

  final ImagePicker picker = ImagePicker();

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

    if (userService.userPhoto != null && userService.userPhoto!.startsWith("https://landslide.bdservers.site/")) {
      // Case 1: Already a full URL, use it as is.
      photo.value = userService.userPhoto!;
    } else if (userService.userPhoto != null && userService.userPhoto!.startsWith("/assets/auth/")) {
      // Case 2: User photo starts with "/assets/auth/", prepend base URL
      photo.value = "${ApiURL.base_url_image}${userService.userPhoto!}";
    } else if (userService.userPhoto != null && !userService.userPhoto!.contains("/assets/auth/")) {
      // Case 3: Only contains image name like "image.png", add "/assets/auth/" and base URL
      photo.value = "${ApiURL.base_url_image}/assets/auth/${userService.userPhoto!}";
    } else {
      // Case 4: Handle null or empty userPhoto (fallback)
      photo.value = "${ApiURL.base_url_image}/assets/auth/default.png"; // Use default image
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

  // 📸 Function to pick image from gallery or camera
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: await _showImagePickerDialog(),
      imageQuality: 80,
    );

    if (image != null) {
      selectedImagePath.value = image.path;
      isConfirmVisible.value = true; // Show confirm button
    }
  }

  // 📋 Show Dialog to choose Camera or Gallery
  Future<ImageSource> _showImagePickerDialog() async {
    return await Get.dialog(
      AlertDialog(
        title: Text("Select Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Camera"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    ) ?? ImageSource.gallery; // Default to gallery if canceled
  }

  Future<void> uploadImage() async {
    if (selectedImagePath.value.isEmpty) return;

    String? token = userService.userToken;
    print("Token: $token");
    print("API URL: ${ApiURL.profile_image}");

    var request = http.MultipartRequest('POST', ApiURL.profile_image);
    request.headers['Authorization'] = "$token"; // Ensure Bearer is used
    request.files.add(await http.MultipartFile.fromPath('file', selectedImagePath.value));

    try {
      var response = await request.send();
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decoded = jsonDecode(responseData);
        print('Response Data: $decoded');

        photo.value = "${decoded['result']['photo']}";
        await userService.updateUserPhoto(photo.value);
        isConfirmVisible.value = false;

        return Get.defaultDialog(
          title: "Success",
          middleText: decoded['message'],
          textCancel: 'Ok',
        );
      } else if (response.statusCode == 401) {
        print('Unauthorized! Possible expired token.');

        bool refreshed = await userService.refreshAccessToken();
        if (refreshed) {
          return uploadImage(); // Retry after refreshing the token
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
          middleText: 'Failed to upload image',
          textCancel: 'Ok',
        );
      }
    } catch (e) {
      print('Error: $e');
      return Get.defaultDialog(
        title: "Error",
        middleText: 'Something went wrong!',
        textCancel: 'Ok',
      );
    }
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