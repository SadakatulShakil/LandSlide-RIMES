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
  final String? imagePaths; // Nullable to prevent errors
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
  final String impactInfrastructure;
  final String damageRoads;
  final String damageBuildings;
  final String damageCriticalInfrastructure;
  final String damageUtilities;
  final String damageBridges;
  final String damImpact;
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
    this.imagePaths,
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

  /// Convert JSON string to List<String>
  List<String> getImagePaths() {
    if (imagePaths == null || imagePaths!.isEmpty) {
      return [];
    }
    try {
      return List<String>.from(jsonDecode(imagePaths!));
    } catch (e) {
      return [];
    }
  }

  /// Convert a LandslideReport object from JSON
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
      imagePaths: json['imagePaths'] != null ? jsonEncode(json['imagePaths']) : null,
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
      impactInfrastructure: json['impactInfrastructure'].toString(), // Convert to String
      damageRoads: json['damageRoads'].toString(),
      damageBuildings: json['damageBuildings'].toString(),
      damageCriticalInfrastructure: json['damageCriticalInfrastructure'].toString(),
      damageUtilities: json['damageUtilities'].toString(),
      damageBridges: json['damageBridges'].toString(),
      damImpact: json['damImpact'].toString(),
      soilImpact: json['soilImpact'] as String,
      vegetationImpact: json['vegetationImpact'] as String,
      waterwayImpact: json['waterwayImpact'] as String,
      economicImpact: json['economicImpact'] as String,
      distance1: json['distance1'] as String,
      distance2: json['distance2'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  /// Convert LandslideReport object to JSON map
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
      'imagePaths': imagePaths ?? jsonEncode([]),
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
      'impactInfrastructure': impactInfrastructure.toString(),
      'damageRoads': damageRoads.toString(),
      'damageBuildings': damageBuildings.toString(),
      'damageCriticalInfrastructure': damageCriticalInfrastructure.toString(),
      'damageUtilities': damageUtilities.toString(),
      'damageBridges': damageBridges.toString(),
      'damImpact': damImpact.toString(),
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
  return await $FloorAppDatabase.databaseBuilder('landslide_app.db').build();
}