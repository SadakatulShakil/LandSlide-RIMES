// dao/survey_questions_dao.dart
import 'package:floor/floor.dart';
import '../entities/survey_questions_entities.dart';

@dao
abstract class SurveyQuestionDao {
  @Query('SELECT * FROM survey_questions WHERE surveyId IS NULL')
  Future<List<SurveyQuestionEntity>> getMasterQuestions();

  @Query('SELECT * FROM survey_questions WHERE surveyId = :surveyId')
  Future<List<SurveyQuestionEntity>> getQuestionsBySurvey(String surveyId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertQuestions(List<SurveyQuestionEntity> questions);

  @Query('DELETE FROM survey_questions WHERE surveyId = :surveyId')
  Future<void> deleteSurveyQuestions(String surveyId);

  @Query('SELECT * FROM survey_questions WHERE synced = 0')
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestions();

  @Query('SELECT * FROM survey_questions WHERE synced = 0 AND surveyId = :surveyId')
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestionsBySurvey(String surveyId);

  @Query('UPDATE survey_questions SET synced = 1 WHERE uid = :uid')
  Future<void> markAsSynced(String uid);

  @Query('DELETE FROM survey_questions WHERE surveyId = :surveyId')
  Future<void> clearQuestionsBySurvey(String surveyId);
}


