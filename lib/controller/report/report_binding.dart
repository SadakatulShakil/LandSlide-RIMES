import 'package:get/get.dart';
import 'package:lanslide_report/controller/report/report_controller.dart';


class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(
          () => ReportController(),
    );
  }
}
