import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/network/network_controller.dart';
class NetworkStatusPage extends StatelessWidget {
  const NetworkStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NetworkController controller = Get.put(NetworkController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Status'),
      ),
      body: Center(
        child: Obx(() {
          return !controller.isNetworkWorking.value ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_internet.png', width: 200,),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.checkNetworkStatus,
                child: const Text('Recheck Network'),
              ),
            ],
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https://static.vecteezy.com/system/resources/previews/046/620/813/non_2x/wi-fi-wireless-internet-network-success-connection-available-access-3d-icon-realistic-vector.jpg'),

              const SizedBox(height: 10),
              Text(
                'Data are used!',
                style: TextStyle(
                  color: controller.isNetworkWorking.value ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        }),
      ),
    );
  }
}