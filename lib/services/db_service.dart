// services/db_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lanslide_report/services/user_pref_service.dart';
import 'package:uuid/uuid.dart';
import '../database_helper/database.dart';
import '../database_helper/entities/comment_entities.dart';
import '../database_helper/entities/post_entities.dart';
import '../database_helper/entities/report_entities.dart';
import '../database_helper/entities/survey_questions_entities.dart';
import '../models/community_post_model.dart';
import '../models/comment_model.dart';
import '../models/question_model.dart';
import '../models/survey_list_model.dart';

class DBService extends GetxService {
  late AppDatabase _database;

  Future<DBService> init() async {
    _database = await $FloorAppDatabase
        .databaseBuilder('landslide_offline.db')
        .build();
    return this;
  }
  final userPrefService = UserPrefService();


  ///  ...................Survey and Questions Part.............................///

  // Fetch survey questions from API
  Future<void> fetchAndSaveMasterQuestions() async {
    print('Fetching master questions from API...');
    // Check if master questions already exist
    final existing = await _database.surveyQuestionDao.getQuestionsBySurvey('master');
    if (existing.isNotEmpty) return print('Master questions already exist, skipping fetch.');

    // Fetch from API
    final response = await http.get(
      Uri.parse('https://landslide.bdservers.site/api/question'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userPrefService.userToken ?? '',
      },
    );

    print('Fetching master questions from API: ${response.statusCode}');
    if (response.statusCode == 200) {
      final decode = json.decode(response.body);
      final List data = decode['result'];

      print('Fetched master questions: ${data.length}');
      print('Master questions data: $data');
      final questions = data.map((item) => SurveyQuestion.fromJson(item)).toList();
      final entities = questions.map((q) =>
          SurveyQuestionEntity.fromModel(q, surveyId: 'master')
      ).toList();

      await _database.surveyQuestionDao.insertQuestions(entities);
    } else {
      throw Exception('Failed to fetch master questions'+
          ' - Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
  //  Duplicate master questions for a new survey
  Future<void> createSurveyQuestionSet(String surveyId) async {
    final masterQuestions = await _database.surveyQuestionDao.getQuestionsBySurvey('master');

    final duplicated = masterQuestions.map((e) {
      return SurveyQuestionEntity(
        uid: '${surveyId}_${e.id}',    // ✅ Unique per question per survey
        id: e.id,
        title: e.title,
        type: e.type,
        group: e.group,
        required: e.required,
        answer: e.answer,
        surveyId: surveyId,
        synced: 0,
      );
    }).toList();

    await _database.surveyQuestionDao.insertQuestions(duplicated); // will replace duplicates
  }

  // Save survey questions for a given surveyId
  Future<void> saveSurveyQuestions(List<SurveyQuestionEntity> entities) async {
    //await _database.surveyQuestionDao.clearQuestionsBySurvey(); // optional: clear before insert
    await _database.surveyQuestionDao.insertQuestions(entities);
  }

  //  Save/update answers for a given survey
  Future<void> saveSurveyAnswers(String surveyId, entities) async {
    await _database.surveyQuestionDao.insertQuestions(entities);
  }

  //  Get questions for a specific survey
  Future<List<SurveyQuestion>> getQuestionsForSurvey(String surveyId) async {
    final entities = await _database.surveyQuestionDao.getQuestionsBySurvey(surveyId);
    return entities.map((e) => e.toModel()).toList();
  }

  //  Get unsynced answers for syncing
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestions() async {
    return await _database.surveyQuestionDao.getUnsyncedQuestions();
  }

  //  Get unsynced questions for a specific survey
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestionsBySurvey(String surveyId) async {
    return await _database.surveyQuestionDao.getUnsyncedQuestionsBySurvey(surveyId);
  }

  //  Save surveys
  Future<void> saveSurvey(Survey survey) async {
    await _database.surveyDao.insertSurvey(SurveyEntity.fromModel(survey));
  }

  //  Get all surveys
  Future<List<Survey>> getSurveysOffline() async {
    final entities = await _database.surveyDao.getAllSurveys();
    return entities.map((e) => e.toModel()).toList();
  }

  //delete survey by id
  Future<void> deleteSurveyLocally(String id) async {
    await _database.surveyDao.deleteSurvey(id);
  }

  // marked Questions
  Future<void> markQuestionAsSynced(String id) async {
    await _database.surveyQuestionDao.markAsSynced(id);
  }

  // update survey status
  Future<void> updateSurveyStatus(String surveyId, String status) async {
    await _database.surveyDao.updateSurveyStatus(surveyId, status);
  }


  /// ...................Community Part.............................///

  // Post methods
  Future<List<CommunityPost>> getPosts() async {
    final entities = await _database.postDao.getAllPosts();
    return entities.map((e) => _postFromEntity(e)).toList();
  }

  Future<void> savePost(CommunityPost post) async {
    await _database.postDao.insertPost(_postToEntity(post));
  }

  Future<void> updatePost(CommunityPost post) async {
    await _database.postDao.updatePost(_postToEntity(post));
  }

  Future<CommunityPost?> getPost(int id) async {
    final entity = await _database.postDao.getPostById(id);
    return entity != null ? _postFromEntity(entity) : null;
  }

  Future<void> deletePost(int id) async {
    await _database.postDao.deletePost(id);
  }


  Future<List<Comment>> getCommentsForPost(int postId) async {
    final entities = await _database.commentDao.getCommentsForPost(postId);
    return entities.map((e) => _commentFromEntity(e)).toList();
  }

  Future<void> addComment(Comment comment) async {
    await _database.commentDao.insertComment(_commentToEntity(comment));

    // Update comment count
    final count = await _database.commentDao.getCommentCountForPost(comment.postId) ?? 0;
    await _database.commentDao.updateCommentCount(comment.postId, count);

    // Also update the post in memory
    final posts = await getPosts();
    final postIndex = posts.indexWhere((p) => p.id == comment.postId);
    if (postIndex != -1) {
      final post = posts[postIndex];
      posts[postIndex] = post.copyWith(commentCount: count);
    }
  }

  Future<void> deleteComment(int id) async {
    await _database.commentDao.deleteComment(id);
  }

  // Helper methods
  CommunityPost _postFromEntity(PostEntity entity) {
    return CommunityPost(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
      likes: entity.likes,
      isLiked: entity.isLiked == 1, // Convert to boolean
      commentCount: entity.commentCount,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entity.createdAt),
    );
  }

  PostEntity _postToEntity(CommunityPost post) {
    return PostEntity(
      id: post.id,
      title: post.title,
      description: post.description,
      imagePath: post.imagePath,
      likes: post.likes,
      isLiked: post.isLiked ? 1 : 0, // Convert to int
      commentCount: post.commentCount,
      createdAt: post.createdAt.millisecondsSinceEpoch,
    );
  }

  CommentEntity _commentToEntity(Comment comment) {
    return CommentEntity(
      id: comment.id,
      postId: comment.postId,
      content: comment.content,
      createdAt: comment.createdAt.millisecondsSinceEpoch,
    );
  }

  Comment _commentFromEntity(CommentEntity entity) {
    return Comment(
      id: entity.id,
      postId: entity.postId,
      content: entity.content,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entity.createdAt),
    );
  }

}