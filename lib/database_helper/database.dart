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
}

@dao
abstract class LandslideReportDao {
  @Insert()
  Future<void> insertReport(LandslideReport report);

  @Query('SELECT * FROM landslide_reports WHERE isSynced = 0')
  Future<List<LandslideReport>> getUnsyncedReports();

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
