import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/otp/OtpController.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {

  OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP VERIFICATION"),
        titleSpacing: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset( 'assets/logo/bmd_logo.png', height: 96 ),
              SizedBox(height: 16),
              Text("OTP VERIFICATION", style: TextStyle( fontSize: 20, fontWeight: FontWeight.w700, ) ),
              Text("Enter the OTP sent to: ${controller.mobile}" ),
              SizedBox(height: 16),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: TextField(
                        controller: controller.otp1,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: TextField(
                        controller: controller.otp2,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: TextField(
                        controller: controller.otp3,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: TextField(
                        controller: controller.otp4,
                        onChanged: (value){ if(value.length == 1) { FocusScope.of(context).nextFocus(); } },
                        style: Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
                  child: ElevatedButton(
                    onPressed: controller.loginClick,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004A03),
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text("Login", style: TextStyle(color: Colors.amber, fontSize: 16)),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Obx(()=> Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Wait ${controller.second.value} seconds to send new code."),
                    controller.second == 0 ?
                    InkWell(
                      onTap: () { controller.resendOTP(); },
                      child: Text("RESEND CODE", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue)),
                    ) : Text("RESEND CODE")
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
