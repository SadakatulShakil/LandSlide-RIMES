import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NetworkController extends GetxController {
  var networkStatus = 'Checking network...'.obs;
  var isNetworkWorking = false.obs;
  var networkIcon = Icons.wifi_off.obs;
  var networkMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkNetworkStatus();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateStatus(result);
    });
  }

  Future<void> checkNetworkStatus() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  Future<void> _updateStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi) {
      networkStatus.value = 'Wi-Fi is connected';
      networkIcon.value = Icons.wifi;
    } else if (result == ConnectivityResult.mobile) {
      networkStatus.value = 'Cellular data is connected';
      networkIcon.value = Icons.network_cell;
    } else if (result == ConnectivityResult.ethernet) {
      networkStatus.value = 'Ethernet is connected';
      networkIcon.value = Icons.settings_ethernet;
    } else {
      networkStatus.value = 'No network connection';
      networkIcon.value = Icons.wifi_off;
      isNetworkWorking.value = false;
      return;
    }
    await _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    try {
      final response = await http.get(Uri.parse('http://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 5)); // 5s timeout for quick feedback

      if (response.statusCode == 204) {
        isNetworkWorking.value = true;
        networkMessage.value = 'Network is working';
      } else {
        _handleNoInternetAccess();
      }
    } catch (e) {
      _handleNoInternetAccess();
    }
  }

  void _handleNoInternetAccess() {
    isNetworkWorking.value = false;
    networkMessage.value = 'Out of internet data';
  }


}