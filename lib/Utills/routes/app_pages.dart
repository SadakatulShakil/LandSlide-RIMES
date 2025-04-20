import 'package:get/get.dart';

import '../../controller/flood_forecast/flood_forecast_binding.dart';
import '../../controller/weather_alert/weather_alert_binding.dart';
import '../../controller/weather_forecast/weather_forecast_binding.dart';
import '../../controller/webview/webview_binding.dart';
import '../../page/flood_forecast_view.dart';
import '../../page/weather_alert_view.dart';
import '../../page/weather_forecast_view.dart';
import '../../page/webview_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.WEATHER_FORECAST,
      page: () => const WeatherForecastView(),
      binding: WeatherForecastBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_ALERT,
      page: () => const WeatherAlertView(),
      binding: WeatherAlertBinding(),
    ),
    GetPage(
      name: _Paths.FLOOD_FORECAST,
      page: () => const FloodForecastView(),
      binding: FloodForecastBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW,
      page: () => const WebviewView(),
      binding: WebviewBinding(),
    ),
    // GetPage(
    //   name: _Paths.PDFVIEW,
    //   page: () => const PdfviewView(),
    //   binding: PdfviewBinding(),
    // ),
    //
    //
    // GetPage(
    //   name: _Paths.COMMUNITY_POST_DETAIL,
    //   page: () => const CommunityPostDetailView(),
    //   binding: CommunityPostDetailBinding(),
    // ),
    // GetPage(
    //   name: _Paths.NOTIFICATIONS,
    //   page: () => const NotificationsView(),
    //   binding: NotificationsBinding(),
    // ),
    //
    // GetPage(
    //   name: _Paths.IMPORTANT_VIDEO,
    //   page: () => const ImportantVideoView(),
    //   binding: ImportantVideoBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CONTACT_US,
    //   page: () => const ContactUsView(),
    //   binding: ContactUsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.FAQ,
    //   page: () => const FaqView(),
    //   binding: FaqBinding(),
    // ),
    // GetPage(
    //   name: _Paths.ARTICLES,
    //   page: () => const ArticlesView(),
    //   binding: ArticlesBinding(),
    // ),
    // GetPage(
    //   name: _Paths.YTPLAYER,
    //   page: () => const YtplayerView(),
    //   binding: YtplayerBinding(),
    // ),
    // GetPage(
    //   name: _Paths.COMMUNITY_POST_ADD,
    //   page: () => CommunityPostAddView(),
    //   binding: CommunityPostAddBinding(),
    // ),
    // GetPage(
    //   name: _Paths.COMMUNITY_POST_MY,
    //   page: () => const CommunityPostMyView(),
    //   binding: CommunityPostMyBinding(),
    // ),
    // GetPage(
    //   name: _Paths.TASK_REMINDER_DETAIL,
    //   page: () => const TaskReminderDetailView(),
    //   binding: TaskReminderDetailBinding(),
    // ),
  ];
}
