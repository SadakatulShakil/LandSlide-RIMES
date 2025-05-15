import 'package:floor/floor.dart';

import '../entities/survey_questions_entities.dart';

@dao
abstract class SurveyQuestionDao {
  @Query('SELECT * FROM survey_questions WHERE surveyId = :surveyId')
  Future<List<SurveyQuestionEntity>> getQuestionsBySurveyId(int surveyId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllQuestions(List<SurveyQuestionEntity> questions);

  @Query('DELETE FROM survey_questions WHERE surveyId = :surveyId')
  Future<void> deleteBySurveyId(int surveyId);


  @Query('UPDATE SurveyQuestionEntity SET answer = :answer WHERE id = :id')
  Future<void> updateAnswerById(String id, String answer);

  @Query('SELECT * FROM survey_questions WHERE synced = 0')
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestions();
}

