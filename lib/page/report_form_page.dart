import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lanslide_report/Utills/AppColors.dart';

import '../controller/report/report_controller.dart';
import '../database_helper/dao/report_dao.dart';
import '../database_helper/database.dart';
import '../services/user_pref_service.dart';
import 'map_page.dart';

class ReportFormPage extends StatefulWidget {
  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final controller = Get.find<ReportController>();
  TextEditingController locationController = TextEditingController();
  //final dao = Get.find<LandslideReportDao>();
  final userPrefService = UserPrefService();
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (controller.imagePaths.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can upload up to 3 images only.")),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.imagePaths.add(pickedFile.path);
    }
  }

  void _removeImage(int index) {
    controller.imagePaths.removeAt(index);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.date.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.time.value = picked.format(context);
    }
  }

  void _showSummaryDialog() {
    controller.showReportDialog(context);
  }

  void _showCommonSummaryDialog(){
    controller.showCommonReportDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    print('userType: ${userPrefService.userType}');
    return Scaffold(
      appBar: AppBar(title: Text('Inventory Report')),
      body: userPrefService.userType == 'common'?
      Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      colorScheme: ColorScheme.light(primary: AppColors().app_primary),
                    ),
                    child: Stepper(
                      elevation: 0,
                      currentStep: controller.currentStep.value,
                      type: StepperType.horizontal,
                      onStepTapped: (step) {
                        bool canJump = true;
                        for (int i = 0; i < step; i++) {
                          if (!_formKeys[i].currentState!.validate()) {
                            canJump = false;
                            break;
                          }
                        }
                        if (canJump) controller.currentStep.value = step;
                      },
                      onStepContinue: () {
                        if (_formKeys[controller.currentStep.value]
                            .currentState!
                            .validate()) {
                          if (controller.currentStep.value < 1) {
                            controller.currentStep++;
                          } else {
                            _showCommonSummaryDialog();
                          }
                        }
                      },
                      onStepCancel: () {
                        if (controller.currentStep.value > 0)
                          controller.currentStep--;
                      },
                      controlsBuilder: (context, details) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (controller.currentStep.value > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('Previous', style: TextStyle(color: AppColors().app_primary),),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text(controller.currentStep.value == 1
                                    ? 'Submit'
                                    : 'Next', style: TextStyle(color: AppColors().app_primary),),
                              ),
                            ),
                          ],
                        );
                      },
                      steps: [
                        // Step 1: Basic Information (Auto-Filled)
                        Step(
                          state: controller.currentStep.value > 0
                              ? StepState.complete
                              : StepState.indexed,
                          title: SizedBox.shrink(),
                          content: Form(
                            key: _formKeys[0],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Auto-Filled Info",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  //_buildReadOnlyField("Landslide ID", controller.id.value),
                                  _buildReadOnlyField("District",
                                      controller.district.value),
                                  _buildReadOnlyField("Upazila",
                                      controller.upazila.value),
                                  _buildReadOnlyField("Location", controller.latAndLon.value),
                                ]),
                          ),
                          isActive: controller.currentStep.value >= 0,
                        ),
                        // Step 2: Basic Information (Manually Input)
                        Step(
                          state: controller.currentStep.value > 1
                              ? StepState.complete
                              : StepState.indexed,
                          title: SizedBox.shrink(),
                          content: Form(
                            key: _formKeys[1],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Basic Info',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Show uploaded images
                                      Obx(() => Row(
                                        children: controller.imagePaths.asMap().entries.map((entry) {
                                          int index = entry.key;
                                          String path = entry.value;
                                          return Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 8),
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: FileImage(File(path)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: GestureDetector(
                                                  onTap: () => _removeImage(index),
                                                  child: Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors().app_alert_extreme,
                                                    ),
                                                    child: Icon(Icons.close, color: AppColors().app_secondary, size: 16),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      )),
                                      // Upload button (hidden if 3 images already added)
                                      if (controller.imagePaths.length < 3)
                                        ElevatedButton(
                                          onPressed: _pickImage,
                                          child: Text("Upload Image", style: TextStyle(color: AppColors().black_font_color),),
                                        ),
                                    ],
                                  ),

                                  //_buildTextField("Landslide Location"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Card(
                                    child: Column(
                                      children: [
                                        _buildDatePicker(context, "Date"),
                                        _buildTimePicker(context, "Time"),
                                      ],
                                    ),
                                  ),
                                  _buildNumberField("Injured"),
                                  _buildNumberField("Deaths"),
                                  _buildYesNoOption(
                                      "Damage to Roads", controller.damageRoads),
                                  _buildYesNoOption("Damage to Buildings",
                                      controller.damageBuildings),
                                ]),
                          ),
                          isActive: controller.currentStep.value >= 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black45, // Dark overlay
                  child: Center(
                      child: CircularProgressIndicator()), // Loading spinner
                ),
              ),
          ],
        );
      }):
      Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      colorScheme: ColorScheme.light(primary: AppColors().app_primary),
                    ),
                    child: Stepper(
                      elevation: 0,
                      currentStep: controller.currentStep.value,
                      type: StepperType.horizontal,
                      onStepTapped: (step) {
                        bool canJump = true;
                        for (int i = 0; i < step; i++) {
                          if (!_formKeys[i].currentState!.validate()) {
                            canJump = false;
                            break;
                          }
                        }
                        if (canJump) controller.currentStep.value = step;
                      },
                      onStepContinue: () {
                        if (_formKeys[controller.currentStep.value]
                            .currentState!
                            .validate()) {
                          if (controller.currentStep.value < 3) {
                            controller.currentStep++;
                          } else {
                            _showSummaryDialog();
                          }
                        }
                      },
                      onStepCancel: () {
                        if (controller.currentStep.value > 0)
                          controller.currentStep--;
                      },
                      controlsBuilder: (context, details) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (controller.currentStep.value > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('Previous', style: TextStyle(color: AppColors().app_primary),),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text(controller.currentStep.value == 3
                                    ? 'Submit'
                                    : 'Next', style: TextStyle(color: AppColors().app_primary),),
                              ),
                            ),
                          ],
                        );
                      },
                      steps: [
                        // Step 1: Basic Information (Auto-Filled)
                        Step(
                          state: controller.currentStep.value > 0
                              ? StepState.complete
                              : StepState.indexed,
                          title: SizedBox.shrink(),
                          content: Form(
                            key: _formKeys[0],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Auto-Filled Info",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  _buildReadOnlyField("Landslide ID", controller.id.value),
                                  _buildReadOnlyField("District",
                                      controller.district.value),
                                  _buildReadOnlyField("Upazila",
                                      controller.upazila.value),
                                  _buildReadOnlyField("Location", controller.latAndLon.value),
                                ]),
                          ),
                          isActive: controller.currentStep.value >= 0,
                        ),
                        // Step 2: Basic Information (Manually Input)
                        Step(
                          state: controller.currentStep.value > 1
                              ? StepState.complete
                              : StepState.indexed,
                          title: SizedBox.shrink(),
                          content: Form(
                            key: _formKeys[1],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Basic Info',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Show uploaded images
                                      Obx(() => Row(
                                        children: controller.imagePaths.asMap().entries.map((entry) {
                                          int index = entry.key;
                                          String path = entry.value;
                                          return Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 8),
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: FileImage(File(path)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: GestureDetector(
                                                  onTap: () => _removeImage(index),
                                                  child: Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors().app_alert_extreme,
                                                    ),
                                                    child: Icon(Icons.close, color: AppColors().app_secondary, size: 16),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      )),
                                      // Upload button (hidden if 3 images already added)
                                      if (controller.imagePaths.length < 3)
                                        ElevatedButton(
                                          onPressed: _pickImage,
                                          child: Text("Upload Image", style: TextStyle(color: AppColors().black_font_color),),
                                        ),
                                    ],
                                  ),

                                  //_buildTextField("Landslide Location"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Card(
                                    child: Column(
                                      children: [
                                        _buildDatePicker(context, "Date"),
                                        _buildTimePicker(context, "Time"),
                                      ],
                                    ),
                                  ),
                                  _buildTextField("Historical Info", maxLines: 1),
                                  _buildTextField("Remedial Measures",
                                      maxLines: 1),
                                  _buildNumberField(
                                      "Area of Displaced Mass (sqm)"),
                                  _buildNumberField("Number of Households"),
                                  _buildDropdown(
                                      "Income Levels", ["Low", "Medium", "High"]),
                                  _buildNumberField("Injured"),
                                  _buildNumberField("Displaced"),
                                  _buildNumberField("Deaths"),
                                ]),
                          ),
                          isActive: controller.currentStep.value >= 1,
                        ),
                        // Step 3: Landslide Mechanism
                        Step(
                          state: controller.currentStep.value > 2
                              ? StepState.complete
                              : StepState.indexed,
                          title: SizedBox.shrink(),
                          content: Form(
                            key: _formKeys[2],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Landslide Mechanism',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  _buildDropdown(
                                      "Landslide Setting", ["Urban", "Rural"]),
                                  _buildDropdown("Classification of Landslide",
                                      ["Type 1", "Type 2"]),
                                  _buildDropdown(
                                      "Material Type", ["Soil", "Rock"]),
                                  _buildTextField("Cause of Landslide"),
                                  _buildDropdown("Failure Type",
                                      ["Rotational", "Translational"]),
                                  _buildDropdown("Distribution Style",
                                      ["Scattered", "Concentrated"]),
                                  _buildDropdown("State of Landslide",
                                      ["Active", "Dormant"]),
                                  _buildDropdown("Land Cover Type",
                                      ["Forested", "Non-forested"]),
                                  _buildDropdown(
                                      "Land Use Type", ["Agricultural", "Urban"]),
                                  _buildNumberField("Slope Angle (°)"),
                                  _buildNumberField("Rainfall Data"),
                                  _buildNumberField("Water Table Level (m)"),
                                  _buildNumberField("Soil Moisture Content"),
                                ]),
                          ),
                          isActive: controller.currentStep.value >= 2,
                        ),
                        // Step 4: Impact Assessment
                        Step(
                          state: controller.currentStep.value > 3
                              ? StepState.complete
                              : StepState.indexed,
                          title: SizedBox.shrink(),
                          content: Form(
                            key: _formKeys[3],
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Impact Assessment',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  _buildYesNoOption("Impact on Infrastructure",
                                      controller.impactInfrastructure),
                                  _buildYesNoOption(
                                      "Damage to Roads", controller.damageRoads),
                                  _buildYesNoOption("Damage to Buildings",
                                      controller.damageBuildings),
                                  _buildYesNoOption(
                                      "Damage to Critical Infrastructure",
                                      controller.damageCriticalInfrastructure),
                                  _buildYesNoOption("Damage to Utilities",
                                      controller.damageUtilities),
                                  _buildYesNoOption("Damage to Bridges",
                                      controller.damageBridges),
                                  _buildYesNoOption("Dam Infrastructure Impact",
                                      controller.damImpact),
                                  _buildTextField("Soil Impact"),
                                  _buildTextField("Vegetation Cover Impact"),
                                  _buildTextField("Waterway Impact"),
                                  _buildTextField("Economic Impact"),
                                  _buildNumberField(
                                      "Distance from Key Location 1"),
                                  _buildNumberField(
                                      "Distance from Key Location 2"),
                                ]),
                          ),
                          isActive: controller.currentStep.value >= 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black45, // Dark overlay
                  child: Center(
                      child: CircularProgressIndicator()), // Loading spinner
                ),
              ),
          ],
        );
      })
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: label == "Location"
            ? IconButton(
          icon: Icon(Icons.map, color: AppColors().app_primary,),
          onPressed: () async {
            controller.isLoading.value = true;
            LatLng? location = await Get.to(() => MapPage(controller.latitude.value, controller.longitude.value));
            if (location != null) {
              // Start loading when the location is selected
              print('check: ====> Lat: ${location.latitude}, Lon: ${location.longitude}');
              controller.updateLocation(location);
              setState(() {

              });
            }
            controller.isLoading.value = false;
          },
        )
            : null,
      ),
      controller: label == "Location"
          ? controller.latAndLonController
          : label == "District"
              ? controller.districtController
              : label == "Upazila"
                  ? controller.upazilaController
                  : controller.idController,
      //initialValue: value,
      readOnly: true,
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextFormField(
      onChanged: (value) {
        switch (label) {
          case "Landslide Location":
            controller.address.value = value;
            break;
          case "Historical Info":
            controller.historicalInfo.value = value;
            break;
          case "Remedial Measures":
            controller.remedialAction.value = value;
            break;
          case "Cause of Landslide":
            controller.cause_land_slide.value = value;
            break;
          case "Soil Impact":
            controller.soilImpact.value = value;
            break;
          case "Vegetation Cover Impact":
            controller.vegetationImpact.value = value;
            break;
          case "Waterway Impact":
            controller.waterwayImpact.value = value;
            break;
          case "Economic Impact":
            controller.economicImpact.value = value;
            break;
        }
      },
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
    );
  }

  Widget _buildNumberField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        switch (label) {
          case "Area of Displaced Mass (sqm)":
            controller.area_displaced_mass.value = value;
            break;
          case "Number of Households":
            controller.households.value = value;
            break;
          case "Injured":
            controller.injured.value = value;
            break;
          case "Displaced":
            controller.displaced.value = value;
            break;
          case "Deaths":
            controller.deaths.value = value;
            break;
          case "Slope Angle (°)":
            controller.slopeAngle.value = value;
            break;
          case "Rainfall Data":
            controller.rainfallData.value = value;
            break;
          case "Water Table Level (m)":
            controller.water_table_level.value = value;
            break;
          case "Soil Moisture Content":
            controller.soilMoistureContent.value = value;
            break;
          case "Economic Impact":
            controller.economicImpact.value = value;
            break;
          case "Distance from Key Location 1":
            controller.distance1.value = value;
            break;
          case "Distance from Key Location 2":
            controller.distance2.value = value;
            break;
        }
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label),
      items:
          items.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
      onChanged: (value) {
        switch (label) {
          case "Income Levels":
            controller.income_level.value = value.toString();
            break;
          case "State of Landslide":
            controller.state_land_slide.value = value.toString();
            break;
          case "Landslide Setting":
            controller.landslideSetting.value = value.toString();
            break;
          case "Classification of Landslide":
            controller.classification.value = value.toString();
            break;
          case "Material Type":
            controller.materialType.value = value.toString();
            break;
          case "Failure Type":
            controller.failureType.value = value.toString();
            break;
          case "Distribution Style":
            controller.distributionStyle.value = value.toString();
            break;
          case "Land Cover Type":
            controller.landCoverType.value = value.toString();
            break;
          case "Land Use Type":
            controller.landUseType.value = value.toString();
            break;
        }
      },
    );
  }

  Widget _buildYesNoOption(String label, RxBool value) {
    return Obx(() => SwitchListTile(
          title: Text(label),
          value: value.value,
          onChanged: (newValue) {
            value.value = newValue;
          },
        ));
  }

  Widget _buildDatePicker(BuildContext context, String label) {
    return ListTile(
      title: Text(label),
      subtitle: Obx(() => Text(controller.date.value.isEmpty
          ? 'Select Date'
          : controller.date.value)),
      trailing: Icon(Icons.calendar_today, color: AppColors().app_primary,),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label) {
    return ListTile(
      title: Text(label),
      subtitle: Obx(() => Text(controller.time.value.isEmpty
          ? 'Select Time'
          : controller.time.value)),
      trailing: Icon(Icons.access_time, color: AppColors().app_primary,),
      onTap: () => _selectTime(context),
    );
  }
}
