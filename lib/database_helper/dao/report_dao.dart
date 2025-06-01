import 'package:floor/floor.dart';

import '../database.dart';
import '../entities/report_entities.dart';

@dao
abstract class SurveyDao {
  @Query('SELECT * FROM surveys')
  Future<List<SurveyEntity>> getAllSurveys();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSurvey(SurveyEntity survey);

  @Query('UPDATE surveys SET status = :status WHERE id = :surveyId')
  Future<void> updateSurveyStatus(String surveyId, String status);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSurveys(List<SurveyEntity> surveys);

  @Query('DELETE FROM surveys WHERE id = :id')
  Future<void> deleteSurvey(String id);

  @Query('SELECT * FROM surveys WHERE synced = 0')
  Future<List<SurveyEntity>> getUnsyncedSurveys();
}
