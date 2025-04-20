import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:lanslide_report/page/webview_view.dart';

import '../controller/profile/ProfileController.dart';
import '../controller/webview/webview_binding.dart';
import '../services/api_service.dart';

class Profile extends StatefulWidget {
  bool isBackButton;
  Profile({super.key, required this.isBackButton});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ProfileController());
    // final controller = Get.lazyPut(()=> ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: widget.isBackButton
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        )
            : null, // Hide back button if false
        title: Text("profile_title".tr, style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          Obx(() => controller.isConfirmVisible.value
              ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                color: AppColors().positive_bg,
                borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                onTap: () => controller.uploadImage(),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 20),
                    SizedBox(width: 5),
                    Text("Confirm", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                            ),
                          ),
              )
              : SizedBox.shrink()),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Obx(() {
                        return CircleAvatar(
                          maxRadius: 65,
                          backgroundColor: AppColors().app_primary,
                          child: CircleAvatar(
                            radius: 63,
                            backgroundImage: controller.selectedImagePath.value.isNotEmpty
                                ? FileImage(File(controller.selectedImagePath.value)) // Show preview
                                : (controller.photo.value.isNotEmpty
                                ? NetworkImage(controller.photo.value) // Show saved image
                                : AssetImage("assets/images/default_avatar.png") // Fallback image
                            ) as ImageProvider, // Ensures correct type
                          ),
                        );
                      }),
                      Positioned(
                          child: CircleAvatar(
                            backgroundColor: AppColors().app_alert_severe,
                            foregroundColor: AppColors().app_secondary,
                            radius: 18,
                            child: IconButton(onPressed: () {
                              controller.pickImage();
                            }, icon: Icon(Icons.camera_alt_rounded, size: 20,)),
                          ),
                          bottom: 0,
                          right: 0
                      )
                    ]
                  ),
                  SizedBox(height: 16),
                  Obx(()=> Text(controller.mobile.value)),
                  Obx(()=> Text(controller.name.value, style: TextStyle( fontSize: 18, fontWeight: FontWeight.w700)),)
                ],
              ),
            ),

            SizedBox(height: 16),

            /// TabBar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors().app_primary,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: TabBar(
                            dividerHeight: 0,
                            labelColor: AppColors().app_primary,
                            unselectedLabelColor: AppColors().app_secondary,
                            indicatorWeight: 1,
                            indicatorPadding: EdgeInsets.symmetric(vertical: 4),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: AppColors().app_secondary,
                            indicator: BoxDecoration(
                              color: AppColors().app_secondary,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            controller: controller.tabController,
                            tabs: [
                              Tab(text: "profile_info".tr),
                              Tab(text: "settings".tr),
                              Tab(text: "profile_logout".tr),
                            ]
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.of(context).size.longestSide,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    /// TabBar View 1
                    // Profile View
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: controller.nameController,
                            enabled: true,
                            decoration: InputDecoration(
                              label: Text("profile_info_name".tr, style: TextStyle(color: AppColors().app_primary),),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors().app_primary)
                              ),
                            ),
                            cursorColor: AppColors().app_primary,
                          ),
                        ),

                        SizedBox(height: 16),

                        Container(
                          padding: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: controller.emailController,
                            enabled: true,
                            decoration: InputDecoration(
                              label: Text("profile_info_email".tr, style: TextStyle(color: AppColors().app_primary),),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors().app_primary)
                              ),
                            ),
                            cursorColor: AppColors().app_primary,
                          ),
                        ),

                        SizedBox(height: 16),

                        Container(
                          padding: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: controller.addressController,
                            enabled: true,
                            decoration: InputDecoration(
                              label: Text("profile_info_address".tr, style: TextStyle(color: AppColors().app_primary),),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors().app_primary)
                              ),
                            ),
                            cursorColor: AppColors().app_primary,
                          ),
                        ),

                        SizedBox(height: 16),
                        
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: controller.updateProfile,
                            child: Text("profile_info_update_button".tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors().app_primary,
                              foregroundColor: AppColors().app_secondary,
                              textStyle: TextStyle(fontSize: 16),
                              minimumSize: Size(100, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                            ),
                          )
                        ),

                      ],
                    ),
                    /// TabBar View 2
                    // Language
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("profile_language_select".tr, style: TextStyle(fontSize: 16),),
                        ),
                        SizedBox(height: 10),
                        // Language Toggle Buttons
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(10),
                              fillColor: AppColors().app_primary_bg,
                              selectedColor: AppColors().app_primary,
                              color: Colors.black54,
                              textStyle: TextStyle(fontSize: 16),
                              isSelected: controller.selectedLanguage,
                              onPressed: (int index) { setState(() {
                                controller.changeLanguage(index);
                              }); },
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text('English'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text('বাংলা'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildOptionTile(Icons.lock, 'change_password'.tr, () {
                          print('Password Change Clicked');
                        }),
                        _buildOptionTile(Icons.phone_android, 'help_center'.tr, () {
                          var item = {
                            "title": "help_center".tr,
                            "url": ApiURL.sidebar_contact_us
                          };
                          Get.to(()=> WebviewView(), binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
                        }),
                        _buildOptionTile(Icons.article, 'faq'.tr, () {
                          var item = {
                            "title": "faq".tr,
                            "url": ApiURL.sidebar_faq
                          };
                          Get.to(()=> WebviewView(), binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
                        }),
                      ],
                    ),
                    /// TabBar View 3
                    // Logout
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: CircleAvatar(
                            backgroundColor: AppColors().app_alert_extreme,
                            foregroundColor: Colors.white,
                            radius: 30,
                            child: IconButton(onPressed: () { controller.logout(); }, icon: Icon(Icons.login_rounded, size: 30,)),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("profile_logout".tr, style: TextStyle(color: AppColors().app_alert_extreme, fontWeight: FontWeight.w500)),
                        SizedBox(height: 4),
                        Text("profile_logout_text".tr)
                      ],
                    )
                  ]
                )
              ),
            )

          ],
        ),
      ),
    );
  }
  // Custom ListTile Widget
  Widget _buildOptionTile(IconData icon, String text, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 30, color: AppColors().app_primary),
        title: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors().app_primary),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }

}
