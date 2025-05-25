// location_gate_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/mobile.dart';
import 'package:lanslide_report/services/location_service.dart';

import '../../controller/mobile/MobileController.dart';

class LocationGatePage extends StatefulWidget {
  @override
  State<LocationGatePage> createState() => _LocationGatePageState();
}

class _LocationGatePageState extends State<LocationGatePage> {
  bool isLoading = true;
  final MobileController mobileController = Get.put(MobileController());

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    try {
      await LocationService().getLocation(); // your real location + API call

      mobileController.isChecking.value?
      Scaffold(
                  body: Center(
                    child: Image.asset('assets/logo/app_logo.png', height: 96),
                  ))
          : Get.offAll(() => Mobile(), transition: Transition.downToUp);//
    } catch (e) {
      // Already handled inside LocationService, just log
      print('Location error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo/app_logo.png', height: 96),
            SizedBox(height: 12),
            Text("Powered by RIMES"),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Location required to proceed."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                initLocation(); // Try again
              },
              child: Text("Try Again"),
            )
          ],
        ),
      ),
    );
  }
}
