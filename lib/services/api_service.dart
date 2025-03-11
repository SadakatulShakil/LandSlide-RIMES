
class ApiURL {
  static String base_url = "https://bamisapp.bdservers.site/";
  static String base_url_api = "https://bamisapp.bdservers.site/api/";
  static String base_url_image = "https://bamisapp.bdservers.site/";

  // Weather
  static Uri locations = Uri.parse('${base_url_api}weather/locations');
  static String dailyforecast = '${base_url_api}weather/dailyforecast';
  static String currentforecast = '${base_url_api}weather/currentforecast';
  static String location_latlon = '${base_url_api}weather/location_latlon';

  // Weather Alert
  static String webview_url = '${base_url}webview/weather_alert';
  // Sidebar
  static String sidebar_contact_us = '${base_url}sidebar/contact_us';
  static String sidebar_faq = '${base_url}sidebar/faq';

  // FCM
  static Uri fcm = Uri.parse('${base_url_api}auth/fcm');

}