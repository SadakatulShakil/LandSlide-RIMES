import 'package:get/get.dart';
import 'package:lanslide_report/controller/weather_alert/weather_alert_controller.dart';

class WeatherAlertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherAlertController>(
      () => WeatherAlertController(),
    );
  }
}
