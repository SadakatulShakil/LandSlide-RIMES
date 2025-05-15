import 'package:floor/floor.dart';
import 'package:lanslide_report/database_helper/dao/post_dao.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/comment_dao.dart';
import 'dao/report_dao.dart';
import 'dao/survey_questions_dao.dart';
import 'entities/comment_entities.dart';
import 'entities/post_entities.dart';
import 'entities/report_entities.dart';
import 'entities/survey_questions_entities.dart';

part 'database.g.dart';

@Database(version: 1, entities: [LandslideReport, PostEntity, CommentEntity, SurveyQuestionEntity])
abstract class AppDatabase extends FloorDatabase {
  LandslideReportDao get landslideReportDao;
  PostDao get postDao;
  CommentDao get commentDao;
  SurveyQuestionDao get surveyQuestionDao;
}