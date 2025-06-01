import 'package:floor/floor.dart';

import '../../models/survey_list_model.dart';

@Entity(tableName: 'surveys')
class SurveyEntity {
  @primaryKey
  final String id;
  final String title;
  final String status; //   final String createdAt;
  final bool synced;

  SurveyEntity({
    required this.id,
    required this.title,
    required this.status,
    this.synced = false,
  });

  factory SurveyEntity.fromModel(Survey model) {
    return SurveyEntity(
      id: model.id,
      title: model.title,
      status: model.status,
      synced: false,
    );
  }

  Survey toModel() {
    return Survey(
      id: id,
      title: title,
      status: status,
    );
  }
}
