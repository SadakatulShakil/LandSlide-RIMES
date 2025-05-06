class ApiURL {
  static String base_url = "https://landslide.bdservers.site/";
  static String base_url_api = "https://landslide.bdservers.site/api/";
  static String base_url_image = "https://landslide.bdservers.site/";

  /// Bamis App Url
  static String bamis_url = "https://bamisapp.bdservers.site/";
  static String bamis_url_api = "https://bamisapp.bdservers.site/api/";

  static Uri login = Uri.parse('${base_url_api}auth/login');
  static Uri mobile = Uri.parse('${base_url_api}auth/mobile');
  static Uri refreshToken = Uri.parse('${base_url_api}auth/refresh');
  static Uri otpcheck = Uri.parse('${base_url_api}auth/otpcheck');

  // Weather
  static Uri locations = Uri.parse('${bamis_url_api}weather/locations');
  static String currentforecast = '${bamis_url_api}weather/currentforecast';
  static String dailyforecast = '${bamis_url_api}weather/dailyforecast';
  static String location_latlon = '${bamis_url_api}weather/location_latlon';
  static String placeholder_auth = "${bamis_url}assets/auth/profile.jpg";

  // Weather Alert
  static String webview_url = '${bamis_url}webview/weather_alert/';
  // Sidebar
  static String sidebar_contact_us = '${bamis_url}sidebar/contact_us';
  static String sidebar_faq = '${bamis_url}sidebar/faq';

  // FCM
  static Uri fcm = Uri.parse('${base_url_api}auth/fcm');

  // Flood Forecast
  static String flood_forecast_url = '${bamis_url}webview/flood_forecast';

  // Profile
  static Uri profile = Uri.parse('${base_url_api}profile');
  static Uri profile_image = Uri.parse('${base_url_image}api/profile/photo');

}