// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PostDao? _postDaoInstance;

  CommentDao? _commentDaoInstance;

  SurveyQuestionDao? _surveyQuestionDaoInstance;

  SurveyDao? _surveyDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `posts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `likes` INTEGER NOT NULL, `is_liked` INTEGER NOT NULL, `comment_count` INTEGER NOT NULL, `created_at` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `comments` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `post_id` INTEGER NOT NULL, `content` TEXT NOT NULL, `createdAt` INTEGER NOT NULL, FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `survey_questions` (`uid` TEXT NOT NULL, `id` TEXT NOT NULL, `surveyId` TEXT, `title` TEXT NOT NULL, `type` TEXT NOT NULL, `group` TEXT NOT NULL, `answer` TEXT, `required` TEXT NOT NULL, `synced` INTEGER NOT NULL, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `surveys` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `status` TEXT NOT NULL, `synced` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PostDao get postDao {
    return _postDaoInstance ??= _$PostDao(database, changeListener);
  }

  @override
  CommentDao get commentDao {
    return _commentDaoInstance ??= _$CommentDao(database, changeListener);
  }

  @override
  SurveyQuestionDao get surveyQuestionDao {
    return _surveyQuestionDaoInstance ??=
        _$SurveyQuestionDao(database, changeListener);
  }

  @override
  SurveyDao get surveyDao {
    return _surveyDaoInstance ??= _$SurveyDao(database, changeListener);
  }
}

class _$PostDao extends PostDao {
  _$PostDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _postEntityInsertionAdapter = InsertionAdapter(
            database,
            'posts',
            (PostEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'imagePath': item.imagePath,
                  'likes': item.likes,
                  'is_liked': item.isLiked,
                  'comment_count': item.commentCount,
                  'created_at': item.createdAt
                }),
        _postEntityUpdateAdapter = UpdateAdapter(
            database,
            'posts',
            ['id'],
            (PostEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'imagePath': item.imagePath,
                  'likes': item.likes,
                  'is_liked': item.isLiked,
                  'comment_count': item.commentCount,
                  'created_at': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PostEntity> _postEntityInsertionAdapter;

  final UpdateAdapter<PostEntity> _postEntityUpdateAdapter;

  @override
  Future<List<PostEntity>> getAllPosts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM posts ORDER BY created_at DESC',
        mapper: (Map<String, Object?> row) => PostEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            imagePath: row['imagePath'] as String,
            likes: row['likes'] as int,
            isLiked: row['is_liked'] as int,
            commentCount: row['comment_count'] as int,
            createdAt: row['created_at'] as int));
  }

  @override
  Future<PostEntity?> getPostById(int id) async {
    return _queryAdapter.query('SELECT * FROM posts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PostEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            imagePath: row['imagePath'] as String,
            likes: row['likes'] as int,
            isLiked: row['is_liked'] as int,
            commentCount: row['comment_count'] as int,
            createdAt: row['created_at'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deletePost(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM posts WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertPost(PostEntity post) async {
    await _postEntityInsertionAdapter.insert(post, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    await _postEntityUpdateAdapter.update(post, OnConflictStrategy.abort);
  }
}

class _$CommentDao extends CommentDao {
  _$CommentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _commentEntityInsertionAdapter = InsertionAdapter(
            database,
            'comments',
            (CommentEntity item) => <String, Object?>{
                  'id': item.id,
                  'post_id': item.postId,
                  'content': item.content,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CommentEntity> _commentEntityInsertionAdapter;

  @override
  Future<List<CommentEntity>> getCommentsForPost(int postId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM comments WHERE post_id = ?1 ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => CommentEntity(
            id: row['id'] as int?,
            postId: row['post_id'] as int,
            content: row['content'] as String,
            createdAt: row['createdAt'] as int),
        arguments: [postId]);
  }

  @override
  Future<void> deleteComment(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM comments WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int?> getCommentCountForPost(int postId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM comments WHERE post_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [postId]);
  }

  @override
  Future<void> updateCommentCount(
    int postId,
    int count,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE posts SET comment_count = ?2 WHERE id = ?1',
        arguments: [postId, count]);
  }

  @override
  Future<void> insertComment(CommentEntity comment) async {
    await _commentEntityInsertionAdapter.insert(
        comment, OnConflictStrategy.replace);
  }
}

class _$SurveyQuestionDao extends SurveyQuestionDao {
  _$SurveyQuestionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _surveyQuestionEntityInsertionAdapter = InsertionAdapter(
            database,
            'survey_questions',
            (SurveyQuestionEntity item) => <String, Object?>{
                  'uid': item.uid,
                  'id': item.id,
                  'surveyId': item.surveyId,
                  'title': item.title,
                  'type': item.type,
                  'group': item.group,
                  'answer': item.answer,
                  'required': item.required,
                  'synced': item.synced
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SurveyQuestionEntity>
      _surveyQuestionEntityInsertionAdapter;

  @override
  Future<List<SurveyQuestionEntity>> getMasterQuestions() async {
    return _queryAdapter.queryList(
        'SELECT * FROM survey_questions WHERE surveyId IS NULL',
        mapper: (Map<String, Object?> row) => SurveyQuestionEntity(
            uid: row['uid'] as String,
            id: row['id'] as String,
            surveyId: row['surveyId'] as String?,
            title: row['title'] as String,
            type: row['type'] as String,
            group: row['group'] as String,
            answer: row['answer'] as String?,
            required: row['required'] as String,
            synced: row['synced'] as int));
  }

  @override
  Future<List<SurveyQuestionEntity>> getQuestionsBySurvey(
      String surveyId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM survey_questions WHERE surveyId = ?1',
        mapper: (Map<String, Object?> row) => SurveyQuestionEntity(
            uid: row['uid'] as String,
            id: row['id'] as String,
            surveyId: row['surveyId'] as String?,
            title: row['title'] as String,
            type: row['type'] as String,
            group: row['group'] as String,
            answer: row['answer'] as String?,
            required: row['required'] as String,
            synced: row['synced'] as int),
        arguments: [surveyId]);
  }

  @override
  Future<void> deleteSurveyQuestions(String surveyId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM survey_questions WHERE surveyId = ?1',
        arguments: [surveyId]);
  }

  @override
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestions() async {
    return _queryAdapter.queryList(
        'SELECT * FROM survey_questions WHERE synced = 0',
        mapper: (Map<String, Object?> row) => SurveyQuestionEntity(
            uid: row['uid'] as String,
            id: row['id'] as String,
            surveyId: row['surveyId'] as String?,
            title: row['title'] as String,
            type: row['type'] as String,
            group: row['group'] as String,
            answer: row['answer'] as String?,
            required: row['required'] as String,
            synced: row['synced'] as int));
  }

  @override
  Future<List<SurveyQuestionEntity>> getUnsyncedQuestionsBySurvey(
      String surveyId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM survey_questions WHERE synced = 0 AND surveyId = ?1',
        mapper: (Map<String, Object?> row) => SurveyQuestionEntity(
            uid: row['uid'] as String,
            id: row['id'] as String,
            surveyId: row['surveyId'] as String?,
            title: row['title'] as String,
            type: row['type'] as String,
            group: row['group'] as String,
            answer: row['answer'] as String?,
            required: row['required'] as String,
            synced: row['synced'] as int),
        arguments: [surveyId]);
  }

  @override
  Future<void> markAsSynced(String uid) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE survey_questions SET synced = 1 WHERE uid = ?1',
        arguments: [uid]);
  }

  @override
  Future<void> clearQuestionsBySurvey(String surveyId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM survey_questions WHERE surveyId = ?1',
        arguments: [surveyId]);
  }

  @override
  Future<void> insertQuestions(List<SurveyQuestionEntity> questions) async {
    await _surveyQuestionEntityInsertionAdapter.insertList(
        questions, OnConflictStrategy.replace);
  }
}

class _$SurveyDao extends SurveyDao {
  _$SurveyDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _surveyEntityInsertionAdapter = InsertionAdapter(
            database,
            'surveys',
            (SurveyEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'status': item.status,
                  'synced': item.synced ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SurveyEntity> _surveyEntityInsertionAdapter;

  @override
  Future<List<SurveyEntity>> getAllSurveys() async {
    return _queryAdapter.queryList('SELECT * FROM surveys',
        mapper: (Map<String, Object?> row) => SurveyEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            status: row['status'] as String,
            synced: (row['synced'] as int) != 0));
  }

  @override
  Future<void> updateSurveyStatus(
    String surveyId,
    String status,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE surveys SET status = ?2 WHERE id = ?1',
        arguments: [surveyId, status]);
  }

  @override
  Future<void> deleteSurvey(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM surveys WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<List<SurveyEntity>> getUnsyncedSurveys() async {
    return _queryAdapter.queryList('SELECT * FROM surveys WHERE synced = 0',
        mapper: (Map<String, Object?> row) => SurveyEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            status: row['status'] as String,
            synced: (row['synced'] as int) != 0));
  }

  @override
  Future<void> insertSurvey(SurveyEntity survey) async {
    await _surveyEntityInsertionAdapter.insert(
        survey, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertSurveys(List<SurveyEntity> surveys) async {
    await _surveyEntityInsertionAdapter.insertList(
        surveys, OnConflictStrategy.replace);
  }
}
