// bindings/community_binding.dart
import 'package:get/get.dart';

import '../../services/db_service.dart';
import 'community_controller.dart';
// import '../services/api_urls.dart';

class CommunityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DBService().init(), fenix: true);
    // Get.lazyPut(() => ApiService(), fenix: true);
    Get.lazyPut(() => CommunityController(), fenix: true);
  }
}