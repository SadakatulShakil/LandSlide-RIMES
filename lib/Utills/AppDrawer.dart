import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/report_data_list.dart';
import 'package:lanslide_report/services/user_pref_service.dart';

import '../controller/webview/webview_binding.dart';
import '../page/Mobile.dart';
import '../page/webview_view.dart';
import '../services/api_service.dart';
import 'AppColors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final userPrefService = UserPrefService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors().app_secondary
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset('assets/images/profile.png', fit: BoxFit.cover),
              ),
            ),
            accountName: Text( userPrefService.userName!.isEmpty ? userPrefService.userMobile ?? '' : userPrefService.userName ?? '' ),
            accountEmail: Text(userPrefService.userAddress ?? ''),
            decoration: BoxDecoration(
              color: AppColors().app_primary
            ),
          ),

          ListTile(
            leading: Icon(Icons.storage),
            title: Text("Report Data".tr),
            onTap: () {
              Get.to(()=> ReportDataList(), transition: Transition.rightToLeft);
            },
          ),
          ListTile(
            leading: Icon(Icons.video_file_outlined),
            title: Text("dashboard_sidebar_important_video".tr),
            onTap: () { },
          ),
          GestureDetector(
            onTap: () {
              var item = {
                "title": "dashboard_sidebar_about_us".tr,
                "url": ApiURL.sidebar_contact_us
              };
              Get.to(()=> WebviewView(), binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
            },
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text("dashboard_sidebar_about_us".tr),
            ),
          ),
          GestureDetector(
            onTap: () {
              var item = {
                "title": "dashboard_sidebar_privacy_policy".tr,
                "url": ApiURL.sidebar_faq
              };
              Get.to(()=> WebviewView(), binding: WebviewBinding(), arguments: item, transition: Transition.rightToLeft);
            },
            child: ListTile(
              leading: Icon(Icons.forum_outlined),
              title: Text("dashboard_sidebar_privacy_policy".tr),
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () async {
              userPrefService.clearUserData();
              Get.offAll(Mobile(), transition: Transition.upToDown);
              // var response = await http.post(ApiURL.fcm, headers: { HttpHeaders.authorizationHeader: '${userPrefService.userToken ?? ''}' } );
              // dynamic decode = jsonDecode(response.body) ;
              //
              // Get.defaultDialog(
              //     title: "Alert",
              //     middleText: decode['message'],
              //     textCancel: 'OK',
              //     onCancel: () async {
              //       userPrefService.clearUserData();
              //       Get.offAll(Mobile(), transition: Transition.upToDown);
              //     }
              //);
            },
            child: ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text("profile_logout".tr),
            ),
          )
        ],
      ),
    );
  }
}
