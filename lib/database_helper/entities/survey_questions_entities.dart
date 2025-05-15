import 'package:floor/floor.dart';
import 'package:lanslide_report/models/question_model.dart';

@Entity(tableName: 'survey_questions')
class SurveyQuestionEntity {
  @primaryKey
  final String id;

  final String surveyId;
  final String title;
  final String type;
  final String group;
  final String? answer;
  final String required;
  final bool synced;

  SurveyQuestionEntity({
    required this.id,
    required this.surveyId,
    required this.title,
    required this.type,
    required this.group,
    this.answer,
    required this.required,
    this.synced = false,
  });

  factory SurveyQuestionEntity.fromModel(SurveyQuestion model, String surveyId) {
    return SurveyQuestionEntity(
      id: model.id,
      surveyId: surveyId,
      title: model.title,
      type: model.type,
      group: model.group,
      required: model.required,
      answer: model.answer?.toString(),
      synced: false,
    );
  }

  SurveyQuestion toModel() {
    return SurveyQuestion(
      id: id,
      group: group,
      title: title,
      type: type,
      required: required,
      answer: answer,
    );
  }
}
