import 'package:floor/floor.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // Generated code

@Entity(tableName: 'landslide_reports')
class LandslideReport {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String district;
  final String upazila;
  final String latitude;
  final String longitude;
  final String causeOfLandSlide;
  final String stateOfLandSlide;
  final String waterTableLevel;
  final String areaDisplacedMass;
  final String numberOfHouseholds;
  final String incomeLevel;
  final String injured;
  final String displaced;
  final String deaths;
  final String imagePaths; // Now stores multiple image paths as JSON
  final String landslideSetting;
  final String classification;
  final String materialType;
  final String failureType;
  final String distributionStyle;
  final String landCoverType;
  final String landUseType;
  final String slopeAngle;
  final String rainfallData;
  final String soilMoistureContent;
  final bool impactInfrastructure;
  final bool damageRoads;
  final bool damageBuildings;
  final bool damageCriticalInfrastructure;
  final bool damageUtilities;
  final bool damageBridges;
  final bool damImpact;
  final String soilImpact;
  final String vegetationImpact;
  final String waterwayImpact;
  final String economicImpact;
  final String distance1;
  final String distance2;
  final bool isSynced;

  LandslideReport({
    this.id,
    required this.district,
    required this.upazila,
    required this.latitude,
    required this.longitude,
    required this.causeOfLandSlide,
    required this.stateOfLandSlide,
    required this.waterTableLevel,
    required this.areaDisplacedMass,
    required this.numberOfHouseholds,
    required this.incomeLevel,
    required this.injured,
    required this.displaced,
    required this.deaths,
    required this.imagePaths, // Updated field
    required this.landslideSetting,
    required this.classification,
    required this.materialType,
    required this.failureType,
    required this.distributionStyle,
    required this.landCoverType,
    required this.landUseType,
    required this.slopeAngle,
    required this.rainfallData,
    required this.soilMoistureContent,
    required this.impactInfrastructure,
    required this.damageRoads,
    required this.damageBuildings,
    required this.damageCriticalInfrastructure,
    required this.damageUtilities,
    required this.damageBridges,
    required this.damImpact,
    required this.soilImpact,
    required this.vegetationImpact,
    required this.waterwayImpact,
    required this.economicImpact,
    required this.distance1,
    required this.distance2,
    this.isSynced = false,
  });

  // Convert JSON string to List<String>
  List<String> getImagePaths() {
    return jsonDecode(imagePaths).cast<String>();
  }

  // Convert a JSON map to a LandslideReport object
  factory LandslideReport.fromJson(Map<String, dynamic> json) {
    return LandslideReport(
      id: json['id'] as int?,
      district: json['district'] as String,
      upazila: json['upazila'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      causeOfLandSlide: json['causeOfLandSlide'] as String,
      stateOfLandSlide: json['stateOfLandSlide'] as String,
      waterTableLevel: json['waterTableLevel'] as String,
      areaDisplacedMass: json['areaDisplacedMass'] as String,
      numberOfHouseholds: json['numberOfHouseholds'] as String,
      incomeLevel: json['incomeLevel'] as String,
      injured: json['injured'] as String,
      displaced: json['displaced'] as String,
      deaths: json['deaths'] as String,
      imagePaths: json['imagePaths'] as String, // Make sure imagePaths is a String
      landslideSetting: json['landslideSetting'] as String,
      classification: json['classification'] as String,
      materialType: json['materialType'] as String,
      failureType: json['failureType'] as String,
      distributionStyle: json['distributionStyle'] as String,
      landCoverType: json['landCoverType'] as String,
      landUseType: json['landUseType'] as String,
      slopeAngle: json['slopeAngle'] as String,
      rainfallData: json['rainfallData'] as String,
      soilMoistureContent: json['soilMoistureContent'] as String,
      impactInfrastructure: json['impactInfrastructure'] as bool,
      damageRoads: json['damageRoads'] as bool,
      damageBuildings: json['damageBuildings'] as bool,
      damageCriticalInfrastructure: json['damageCriticalInfrastructure'] as bool,
      damageUtilities: json['damageUtilities'] as bool,
      damageBridges: json['damageBridges'] as bool,
      damImpact: json['damImpact'] as bool,
      soilImpact: json['soilImpact'] as String,
      vegetationImpact: json['vegetationImpact'] as String,
      waterwayImpact: json['waterwayImpact'] as String,
      economicImpact: json['economicImpact'] as String,
      distance1: json['distance1'] as String,
      distance2: json['distance2'] as String,
      isSynced: json['isSynced'] as bool? ?? false, // Default to false if not provided
    );
  }

  // Convert LandslideReport object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'upazila': upazila,
      'latitude': latitude,
      'longitude': longitude,
      'causeOfLandSlide': causeOfLandSlide,
      'stateOfLandSlide': stateOfLandSlide,
      'waterTableLevel': waterTableLevel,
      'areaDisplacedMass': areaDisplacedMass,
      'numberOfHouseholds': numberOfHouseholds,
      'incomeLevel': incomeLevel,
      'injured': injured,
      'displaced': displaced,
      'deaths': deaths,
      'imagePaths': imagePaths,
      'landslideSetting': landslideSetting,
      'classification': classification,
      'materialType': materialType,
      'failureType': failureType,
      'distributionStyle': distributionStyle,
      'landCoverType': landCoverType,
      'landUseType': landUseType,
      'slopeAngle': slopeAngle,
      'rainfallData': rainfallData,
      'soilMoistureContent': soilMoistureContent,
      'impactInfrastructure': impactInfrastructure,
      'damageRoads': damageRoads,
      'damageBuildings': damageBuildings,
      'damageCriticalInfrastructure': damageCriticalInfrastructure,
      'damageUtilities': damageUtilities,
      'damageBridges': damageBridges,
      'damImpact': damImpact,
      'soilImpact': soilImpact,
      'vegetationImpact': vegetationImpact,
      'waterwayImpact': waterwayImpact,
      'economicImpact': economicImpact,
      'distance1': distance1,
      'distance2': distance2,
      'isSynced': isSynced,
    };
  }
}

@dao
abstract class LandslideReportDao {
  @Insert()
  Future<void> insertReport(LandslideReport report);

  @Query('SELECT * FROM landslide_reports WHERE isSynced = 0')
  Future<List<LandslideReport>> getUnsyncedReports();

  @Query('SELECT * FROM landslide_reports WHERE isSynced = 1')
  Future<List<LandslideReport>> getSyncedReports();

  @Query('UPDATE landslide_reports SET isSynced = 1 WHERE id = :id')
  Future<void> markAsSynced(int id);
}

@Database(version: 1, entities: [LandslideReport])
abstract class AppDatabase extends FloorDatabase {
  LandslideReportDao get landslideReportDao;
}

Future<AppDatabase> initializeDatabase() async {
  final database = await $FloorAppDatabase.databaseBuilder('landslide_app.db').build();
  return database;
}
