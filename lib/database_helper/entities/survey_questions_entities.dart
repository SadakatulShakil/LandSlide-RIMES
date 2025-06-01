import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

import '../../models/question_model.dart';

@Entity(tableName: 'survey_questions')
class SurveyQuestionEntity {
  @primaryKey
  final String uid; // true unique ID for DB record
  final String id; // server-side ID for the question
  final String? surveyId; // null = master, otherwise per survey
  final String title;
  final String type;
  final String group;
  String? answer;
  final String required;
  final int synced; // 0 = not synced, 1 = synced

  SurveyQuestionEntity({
    required this.uid,
    required this.id,
    this.surveyId,
    required this.title,
    required this.type,
    required this.group,
    this.answer,
    required this.required,
    this.synced = 0,
  });

  factory SurveyQuestionEntity.fromModel(
      SurveyQuestion model,
      {required String surveyId, bool isSynced = false}
      ) {
    return SurveyQuestionEntity(
      uid: '${surveyId}_${model.id}', // fixed unique ID per question per survey
      id: model.id,
      surveyId: surveyId,
      title: model.title,
      type: model.type,
      group: model.group,
      required: model.required,
      answer: model.answer?.toString(),
      synced: isSynced ? 1 : 0,
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