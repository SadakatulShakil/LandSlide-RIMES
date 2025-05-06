import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/api_urls.dart';

class WebviewController extends GetxController {

  var title = "".obs;
  var isPageLoading = 0.obs;
  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(ApiURL.webview_url)).obs;

  late var url;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    dynamic decode = Get.arguments;
    title.value = decode['title'];

    webViewController
    ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) { isPageLoading.value = 0; print('Progress : ${isPageLoading.value}'); },
        onProgress: (int progress) { isPageLoading.value = progress; print('Progress : ${isPageLoading.value}'); },
        onPageFinished: (url) { isPageLoading.value = 100; print('Progress : ${isPageLoading.value}'); }
    ))
    ..loadRequest(Uri.parse(decode['url']));
  }
}
