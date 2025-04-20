import 'package:get/get.dart';
import 'package:lanslide_report/controller/weather_forecast/weather_forecast_controller.dart';


class WeatherForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherForecastController>(
      () => WeatherForecastController(),
    );
  }
}
