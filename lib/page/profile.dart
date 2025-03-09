import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile/ProfileController.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

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
        titleSpacing: 0,
        title: Text("profile".tr, style: TextStyle(fontWeight: FontWeight.w700)),
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
                      Obx(
                        ()=> CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(controller.photo.value),
                          //backgroundImage: NetworkImage(controller.photo.value),
                        )
                      ),
                      Positioned(
                          child: CircleAvatar(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            radius: 18,
                            child: IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_rounded, size: 20,)),
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

            // Tabbar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: TabBar(
                            dividerHeight: 0,
                            unselectedLabelColor: Colors.white,
                            indicatorWeight: 1,
                            indicatorPadding: EdgeInsets.symmetric(vertical: 4),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.white,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            controller: controller.tabController,
                            tabs: [
                              Tab(text: "profile_info".tr),
                              Tab(text: "profile_language".tr),
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
                              labelText: "profile_info_name".tr,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)
                              ),
                            ),
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
                              labelText: "profile_info_email".tr,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)
                              ),
                            ),
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
                              labelText: "profile_info_address".tr,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                        
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: controller.updateProfile,
                            child: Text("profile_info_update_button".tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(fontSize: 16),
                              minimumSize: Size(100, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                            ),
                          )
                        ),

                      ],
                    ),

                    // Language
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("profile_language_select".tr),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ToggleButtons(
                            isSelected: controller.selectedLanguage,
                            onPressed: (int index) { setState(() {
                              controller.changeLanguage(index);
                            }); },
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text('English'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text('বাংলা'),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

                    // Logout
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            radius: 30,
                            child: IconButton(onPressed: () { controller.logout(); }, icon: Icon(Icons.login_rounded, size: 30,)),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("profile_logout".tr, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
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
}
