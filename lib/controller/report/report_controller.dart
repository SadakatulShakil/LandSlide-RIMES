import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../database_helper/database.dart';
import '../../services/user_pref_service.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {
  final userPrefService = UserPrefService();
  final ImagePicker _picker = ImagePicker();

  var currentStep = 0.obs;

  var address = ''.obs;
  var district = ''.obs;
  var upazila = ''.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;

  // Basic Info Manually Entered
  var imagePath = ''.obs;
  var date = ''.obs;
  var time = ''.obs;
  var historicalInfo = ''.obs;
  var remedialAction = ''.obs;
  var area_displaced_mass = ''.obs;
  var households = ''.obs;
  var income_level = ''.obs;
  var injured = ''.obs;
  var displaced = ''.obs;
  var deaths = ''.obs;

  // Landslide Mechanism Variables
  var landslideSetting = ''.obs;
  var classification = ''.obs;
  var materialType = ''.obs;
  var cause_land_slide = ''.obs;
  var failureType = ''.obs;
  var distributionStyle = ''.obs;
  var state_land_slide = ''.obs;
  var landCoverType = ''.obs;
  var landUseType = ''.obs;
  var slopeAngle = ''.obs;
  var rainfallData = ''.obs;
  var water_table_level = ''.obs;
  var soilMoistureContent = ''.obs;

  // Impact Assessment Variables
  var impactInfrastructure = false.obs;
  var damageRoads = false.obs;
  var damageBuildings = false.obs;
  var damageCriticalInfrastructure = false.obs;
  var damageUtilities = false.obs;
  var damageBridges = false.obs;
  var damImpact = false.obs;
  var soilImpact = ''.obs;
  var vegetationImpact = ''.obs;
  var waterwayImpact = ''.obs;
  var economicImpact = ''.obs;
  var distance1 = ''.obs;
  var distance2 = ''.obs;

  final TextEditingController districtController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController historicalInfoController = TextEditingController();
  final TextEditingController upazilaController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController causeOfLandSlide = TextEditingController();
  final TextEditingController waterTableLevel = TextEditingController();
  final TextEditingController damageToRoad = TextEditingController();
  final TextEditingController damageToBridges = TextEditingController();
  final TextEditingController areaDisplacedMass = TextEditingController();
  final TextEditingController numHouseholds = TextEditingController();
  final TextEditingController numInjured = TextEditingController();
  final TextEditingController numDisplaced = TextEditingController();
  final TextEditingController numDeaths = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getSharedPrefData();
  }

  void bindControllers() {
    districtController.text = district.value;
    upazilaController.text = upazila.value;
    latController.text = latitude.value;
    lonController.text = longitude.value;
    causeOfLandSlide.text = cause_land_slide.value;
    waterTableLevel.text = water_table_level.value;
    areaDisplacedMass.text = area_displaced_mass.value;
    numHouseholds.text = households.value;
    numInjured.text = injured.value;
    numDisplaced.text = displaced.value;
    numDeaths.text = deaths.value;
  }

  Future getSharedPrefData() async {
    district.value = userPrefService.locationDistrict ?? '';
    upazila.value = userPrefService.locationUpazila ?? '';
    longitude.value = userPrefService.lon ?? '';
    latitude.value = userPrefService.lat ?? '';
    address.value = userPrefService.locationName ?? '';

    bindControllers();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  Future<void> saveOffline(LandslideReportDao dao) async {
    final report = LandslideReport(
      district: district.value,
      upazila: upazila.value,
      latitude: latitude.value,
      longitude: longitude.value,
      causeOfLandSlide: cause_land_slide.value,
      stateOfLandSlide: state_land_slide.value,
      waterTableLevel: water_table_level.value,
      areaDisplacedMass: area_displaced_mass.value,
      numberOfHouseholds: households.value,
      incomeLevel: income_level.value,
      injured: injured.value,
      displaced: displaced.value,
      deaths: deaths.value,
      imagePath: imagePath.value,
      landslideSetting: landslideSetting.value,
      classification: classification.value,
      materialType: materialType.value,
      failureType: failureType.value,
      distributionStyle: distributionStyle.value,
      landCoverType: landCoverType.value,
      landUseType: landUseType.value,
      slopeAngle: slopeAngle.value,
      rainfallData: rainfallData.value,
      soilMoistureContent: soilMoistureContent.value,
      impactInfrastructure: impactInfrastructure.value,
      damageRoads: damageRoads.value,
      damageBuildings: damageBuildings.value,
      damageCriticalInfrastructure: damageCriticalInfrastructure.value,
      damageUtilities: damageUtilities.value,
      damageBridges: damageBridges.value,
      damImpact: damImpact.value,
      soilImpact: soilImpact.value,
      vegetationImpact: vegetationImpact.value,
      waterwayImpact: waterwayImpact.value,
      economicImpact: economicImpact.value,
      distance1: distance1.value,
      distance2: distance2.value,
    );
    await dao.insertReport(report);
    resetForm();
    Get.snackbar('Success', 'Report saved offline');
  }


  Future<void> saveOnline() async {
    try {
      var token = userPrefService.userToken ?? '';

      var url = "http://192.168.0.68:8000/reports/";

      var reportData = {
        'landslideId': 'LS2468',
        'district': district.value,
        'upazila': upazila.value,
        'latitude': latitude.value,
        'longitude': longitude.value,
        'date': date.value,
        'time': time.value,
        'causeOfLandSlide': cause_land_slide.value,
        'stateOfLandSlide': state_land_slide.value,
        'waterTableLevel': water_table_level.value,
        'areaDisplacedMass': area_displaced_mass.value,
        'numberOfHouseholds': households.value,
        'incomeLevel': income_level.value,
        'injured': injured.value,
        'displaced': displaced.value,
        'deaths': deaths.value,
        'imagePath': imagePath.value,
        'landslideSetting': landslideSetting.value,
        'classification': classification.value,
        'materialType': materialType.value,
        'failureType': failureType.value,
        'distributionStyle': distributionStyle.value,
        'landCoverType': landCoverType.value,
        'landUseType': landUseType.value,
        'slopeAngle': slopeAngle.value,
        'rainfallData': rainfallData.value,
        'soilMoistureContent': soilMoistureContent.value,
        'impactInfrastructure': impactInfrastructure.value.toString(),
        'damageRoads': damageRoads.value.toString(),
        'damageBuildings': damageBuildings.value.toString(),
        'damageCriticalInfrastructure': damageCriticalInfrastructure.value.toString(),
        'damageUtilities': damageUtilities.value.toString(),
        'damageBridges': damageBridges.value.toString(),
        'damImpact': damImpact.value.toString(),
        'soilImpact': soilImpact.value,
        'vegetationImpact': vegetationImpact.value,
        'waterwayImpact': waterwayImpact.value,
        'economicImpact': economicImpact.value,
        'distance1': distance1.value,
        'distance2': distance2.value,
      };

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(reportData),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        var decode = jsonDecode(response.body);
        Get.back();
        Get.snackbar("Success", decode['message'],
            backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
      } else {
        var decode = jsonDecode(response.body);
        Get.snackbar("Warning", decode['message'],
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void resetForm() {
    district.value = '';
    upazila.value = '';
    latitude.value = '';
    longitude.value = '';
    address.value = '';
    cause_land_slide.value = '';
    state_land_slide.value = '';
    water_table_level.value = '';
    imagePath.value = '';
    landslideSetting.value = '';
    classification.value = '';
    materialType.value = '';
    failureType.value = '';
    distributionStyle.value = '';
    landCoverType.value = '';
    landUseType.value = '';
    slopeAngle.value = '';
    rainfallData.value = '';
    soilMoistureContent.value = '';
    impactInfrastructure.value = false;
    damageRoads.value = false;
    damageBuildings.value = false;
    damageCriticalInfrastructure.value = false;
    damageUtilities.value = false;
    damageBridges.value = false;
    damImpact.value = false;
    soilImpact.value = '';
    vegetationImpact.value = '';
    waterwayImpact.value = '';
    economicImpact.value = '';
    distance1.value = '';
    distance2.value = '';
    currentStep.value = 0;
    bindControllers();
  }

  @override
  void onClose() {
    districtController.dispose();
    addressController.dispose();
    historicalInfoController.dispose();
    upazilaController.dispose();
    latController.dispose();
    lonController.dispose();
    causeOfLandSlide.dispose();
    waterTableLevel.dispose();
    damageToRoad.dispose();
    damageToBridges.dispose();
    areaDisplacedMass.dispose();
    numHouseholds.dispose();
    numInjured.dispose();
    numDisplaced.dispose();
    numDeaths.dispose();
    super.onClose();
  }

  void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text('Review'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('District: ${district.value}'),
                Text('Upazila: ${upazila.value}'),
                Text('Latitude: ${latitude.value}'),
                Text('Longitude: ${longitude.value}'),
                Text('Date: ${date.value}'),
                Text('Time: ${time.value}'),
                Text('Cause of Landslide: ${cause_land_slide.value}'),
                Text('State of Landslide: ${state_land_slide.value}'),// check
                Text('Water Table Level: ${water_table_level.value}'),
                Text('Area Displaced Mass: ${area_displaced_mass.value}'),
                Text('Number of Households: ${households.value}'),
                Text('Income Level: ${income_level.value}'),
                Text('Injured: ${injured.value}'),
                Text('Displaced: ${displaced.value}'),
                Text('Deaths: ${deaths.value}'),
                Text('Landslide Setting: ${landslideSetting.value}'),
                Text('Classification: ${classification.value}'),
                Text('Material Type: ${materialType.value}'),
                Text('Failure Type: ${failureType.value}'),
                Text('Distribution Style: ${distributionStyle.value}'),
                Text('Land Cover Type: ${landCoverType.value}'),
                Text('Land Use Type: ${landUseType.value}'),
                Text('Slope Angle: ${slopeAngle.value}'),
                Text('Rainfall Data: ${rainfallData.value}'),
                Text('Soil Moisture Content: ${soilMoistureContent.value}'),
                Text('Impact on Infrastructure: ${impactInfrastructure.value}'),
                Text('Damage to Roads: ${damageRoads.value}'),
                Text('Damage to Buildings: ${damageBuildings.value}'),
                Text('Damage to Critical Infrastructure: ${damageCriticalInfrastructure.value}'),
                Text('Damage to Utilities: ${damageUtilities.value}'),
                Text('Damage to Bridges: ${damageBridges.value}'),
                Text('Dam Impact: ${damImpact.value}'),
                Text('Soil Impact: ${soilImpact.value}'),
                Text('Vegetation Impact: ${vegetationImpact.value}'),
                Text('Waterway Impact: ${waterwayImpact.value}'),
                Text('Economic Impact: ${economicImpact.value}'),
                Text('Distance from Key Location 1: ${distance1.value}'),
                Text('Distance from Key Location 2: ${distance2.value}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save (Offline)'),
              onPressed: () {
                saveOffline(Get.find<LandslideReportDao>());
                // Implement save offline functionality
              },
            ),
            TextButton(
              child: Text('Save (Online)'),
              onPressed: () {
                saveOnline();
                // Implement save online functionality
              },
            ),
          ],
        );
      },
    );
  }
}