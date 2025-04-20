import 'package:get/get.dart';

import 'flood_forecast_controller.dart';


class FloodForecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FloodForecastController>(
      () => FloodForecastController(),
    );
  }
}
