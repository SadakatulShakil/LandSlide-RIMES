import 'package:floor/floor.dart';

import '../database.dart';
import '../entities/report_entities.dart';

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