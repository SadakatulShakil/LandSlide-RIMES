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

  LandslideReportDao? _landslideReportDaoInstance;

  PostDao? _postDaoInstance;

  CommentDao? _commentDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `landslide_reports` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `district` TEXT NOT NULL, `upazila` TEXT NOT NULL, `latitude` TEXT NOT NULL, `longitude` TEXT NOT NULL, `causeOfLandSlide` TEXT NOT NULL, `stateOfLandSlide` TEXT NOT NULL, `waterTableLevel` TEXT NOT NULL, `areaDisplacedMass` TEXT NOT NULL, `numberOfHouseholds` TEXT NOT NULL, `incomeLevel` TEXT NOT NULL, `injured` TEXT NOT NULL, `displaced` TEXT NOT NULL, `deaths` TEXT NOT NULL, `imagePaths` TEXT, `landslideSetting` TEXT NOT NULL, `classification` TEXT NOT NULL, `materialType` TEXT NOT NULL, `failureType` TEXT NOT NULL, `distributionStyle` TEXT NOT NULL, `landCoverType` TEXT NOT NULL, `landUseType` TEXT NOT NULL, `slopeAngle` TEXT NOT NULL, `rainfallData` TEXT NOT NULL, `soilMoistureContent` TEXT NOT NULL, `impactInfrastructure` TEXT NOT NULL, `damageRoads` TEXT NOT NULL, `damageBuildings` TEXT NOT NULL, `damageCriticalInfrastructure` TEXT NOT NULL, `damageUtilities` TEXT NOT NULL, `damageBridges` TEXT NOT NULL, `damImpact` TEXT NOT NULL, `soilImpact` TEXT NOT NULL, `vegetationImpact` TEXT NOT NULL, `waterwayImpact` TEXT NOT NULL, `economicImpact` TEXT NOT NULL, `distance1` TEXT NOT NULL, `distance2` TEXT NOT NULL, `isSynced` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `posts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `imagePath` TEXT NOT NULL, `likes` INTEGER NOT NULL, `is_liked` INTEGER NOT NULL, `comment_count` INTEGER NOT NULL, `created_at` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `comments` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `post_id` INTEGER NOT NULL, `content` TEXT NOT NULL, `createdAt` INTEGER NOT NULL, FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LandslideReportDao get landslideReportDao {
    return _landslideReportDaoInstance ??=
        _$LandslideReportDao(database, changeListener);
  }

  @override
  PostDao get postDao {
    return _postDaoInstance ??= _$PostDao(database, changeListener);
  }

  @override
  CommentDao get commentDao {
    return _commentDaoInstance ??= _$CommentDao(database, changeListener);
  }
}

class _$LandslideReportDao extends LandslideReportDao {
  _$LandslideReportDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _landslideReportInsertionAdapter = InsertionAdapter(
            database,
            'landslide_reports',
            (LandslideReport item) => <String, Object?>{
                  'id': item.id,
                  'district': item.district,
                  'upazila': item.upazila,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'causeOfLandSlide': item.causeOfLandSlide,
                  'stateOfLandSlide': item.stateOfLandSlide,
                  'waterTableLevel': item.waterTableLevel,
                  'areaDisplacedMass': item.areaDisplacedMass,
                  'numberOfHouseholds': item.numberOfHouseholds,
                  'incomeLevel': item.incomeLevel,
                  'injured': item.injured,
                  'displaced': item.displaced,
                  'deaths': item.deaths,
                  'imagePaths': item.imagePaths,
                  'landslideSetting': item.landslideSetting,
                  'classification': item.classification,
                  'materialType': item.materialType,
                  'failureType': item.failureType,
                  'distributionStyle': item.distributionStyle,
                  'landCoverType': item.landCoverType,
                  'landUseType': item.landUseType,
                  'slopeAngle': item.slopeAngle,
                  'rainfallData': item.rainfallData,
                  'soilMoistureContent': item.soilMoistureContent,
                  'impactInfrastructure': item.impactInfrastructure,
                  'damageRoads': item.damageRoads,
                  'damageBuildings': item.damageBuildings,
                  'damageCriticalInfrastructure':
                      item.damageCriticalInfrastructure,
                  'damageUtilities': item.damageUtilities,
                  'damageBridges': item.damageBridges,
                  'damImpact': item.damImpact,
                  'soilImpact': item.soilImpact,
                  'vegetationImpact': item.vegetationImpact,
                  'waterwayImpact': item.waterwayImpact,
                  'economicImpact': item.economicImpact,
                  'distance1': item.distance1,
                  'distance2': item.distance2,
                  'isSynced': item.isSynced ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LandslideReport> _landslideReportInsertionAdapter;

  @override
  Future<List<LandslideReport>> getUnsyncedReports() async {
    return _queryAdapter.queryList(
        'SELECT * FROM landslide_reports WHERE isSynced = 0',
        mapper: (Map<String, Object?> row) => LandslideReport(
            id: row['id'] as int?,
            district: row['district'] as String,
            upazila: row['upazila'] as String,
            latitude: row['latitude'] as String,
            longitude: row['longitude'] as String,
            causeOfLandSlide: row['causeOfLandSlide'] as String,
            stateOfLandSlide: row['stateOfLandSlide'] as String,
            waterTableLevel: row['waterTableLevel'] as String,
            areaDisplacedMass: row['areaDisplacedMass'] as String,
            numberOfHouseholds: row['numberOfHouseholds'] as String,
            incomeLevel: row['incomeLevel'] as String,
            injured: row['injured'] as String,
            displaced: row['displaced'] as String,
            deaths: row['deaths'] as String,
            imagePaths: row['imagePaths'] as String?,
            landslideSetting: row['landslideSetting'] as String,
            classification: row['classification'] as String,
            materialType: row['materialType'] as String,
            failureType: row['failureType'] as String,
            distributionStyle: row['distributionStyle'] as String,
            landCoverType: row['landCoverType'] as String,
            landUseType: row['landUseType'] as String,
            slopeAngle: row['slopeAngle'] as String,
            rainfallData: row['rainfallData'] as String,
            soilMoistureContent: row['soilMoistureContent'] as String,
            impactInfrastructure: row['impactInfrastructure'] as String,
            damageRoads: row['damageRoads'] as String,
            damageBuildings: row['damageBuildings'] as String,
            damageCriticalInfrastructure:
                row['damageCriticalInfrastructure'] as String,
            damageUtilities: row['damageUtilities'] as String,
            damageBridges: row['damageBridges'] as String,
            damImpact: row['damImpact'] as String,
            soilImpact: row['soilImpact'] as String,
            vegetationImpact: row['vegetationImpact'] as String,
            waterwayImpact: row['waterwayImpact'] as String,
            economicImpact: row['economicImpact'] as String,
            distance1: row['distance1'] as String,
            distance2: row['distance2'] as String,
            isSynced: (row['isSynced'] as int) != 0));
  }

  @override
  Future<List<LandslideReport>> getSyncedReports() async {
    return _queryAdapter.queryList(
        'SELECT * FROM landslide_reports WHERE isSynced = 1',
        mapper: (Map<String, Object?> row) => LandslideReport(
            id: row['id'] as int?,
            district: row['district'] as String,
            upazila: row['upazila'] as String,
            latitude: row['latitude'] as String,
            longitude: row['longitude'] as String,
            causeOfLandSlide: row['causeOfLandSlide'] as String,
            stateOfLandSlide: row['stateOfLandSlide'] as String,
            waterTableLevel: row['waterTableLevel'] as String,
            areaDisplacedMass: row['areaDisplacedMass'] as String,
            numberOfHouseholds: row['numberOfHouseholds'] as String,
            incomeLevel: row['incomeLevel'] as String,
            injured: row['injured'] as String,
            displaced: row['displaced'] as String,
            deaths: row['deaths'] as String,
            imagePaths: row['imagePaths'] as String?,
            landslideSetting: row['landslideSetting'] as String,
            classification: row['classification'] as String,
            materialType: row['materialType'] as String,
            failureType: row['failureType'] as String,
            distributionStyle: row['distributionStyle'] as String,
            landCoverType: row['landCoverType'] as String,
            landUseType: row['landUseType'] as String,
            slopeAngle: row['slopeAngle'] as String,
            rainfallData: row['rainfallData'] as String,
            soilMoistureContent: row['soilMoistureContent'] as String,
            impactInfrastructure: row['impactInfrastructure'] as String,
            damageRoads: row['damageRoads'] as String,
            damageBuildings: row['damageBuildings'] as String,
            damageCriticalInfrastructure:
                row['damageCriticalInfrastructure'] as String,
            damageUtilities: row['damageUtilities'] as String,
            damageBridges: row['damageBridges'] as String,
            damImpact: row['damImpact'] as String,
            soilImpact: row['soilImpact'] as String,
            vegetationImpact: row['vegetationImpact'] as String,
            waterwayImpact: row['waterwayImpact'] as String,
            economicImpact: row['economicImpact'] as String,
            distance1: row['distance1'] as String,
            distance2: row['distance2'] as String,
            isSynced: (row['isSynced'] as int) != 0));
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE landslide_reports SET isSynced = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertReport(LandslideReport report) async {
    await _landslideReportInsertionAdapter.insert(
        report, OnConflictStrategy.replace);
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
