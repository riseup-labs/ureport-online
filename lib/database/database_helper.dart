import 'package:sqflite/sqflite.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/ResponseStoryLocal.dart';
import 'package:ureport_ecaro/database/database_constant.dart';
import '/all-screens/home/stories/model/response-story-data.dart' as storyarray;

class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "database.db";
    print(path);

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table ${DatabaseConstant.tableName} ( 
          ${DatabaseConstant.columnID} integer primary key, 
          ${DatabaseConstant.columnTitle} text,
          ${DatabaseConstant.columnFeatured} text,
          ${DatabaseConstant.columnSummary} text,
          ${DatabaseConstant.columnContent} text,
          ${DatabaseConstant.columnVideoId} text,
          ${DatabaseConstant.columnAudioLink} text,
          ${DatabaseConstant.columnTags} text,
          ${DatabaseConstant.columnImages} text,
          ${DatabaseConstant.columnCategory} text,
          ${DatabaseConstant.columnCreated_on} text)
        ''');
      },
    );
    return database;
  }

  void insertStory(List<storyarray.Result> list) async {
    var db = await this.database;
    list.forEach((element) async {
      // var result = await db.insert(DatabaseConstant.tableName, element.toJson());
      var result = await db.insert(DatabaseConstant.tableName, {
        DatabaseConstant.columnID : element.id,
        DatabaseConstant.columnTitle : element.title,
        DatabaseConstant.columnFeatured : element.featured.toString(),
        DatabaseConstant.columnSummary : element.summary,
        DatabaseConstant.columnContent : '',
        DatabaseConstant.columnVideoId : '',
        DatabaseConstant.columnAudioLink : '',
        DatabaseConstant.columnTags : '',
        DatabaseConstant.columnImages : element.images.length>0?element.images[0]:'',
        DatabaseConstant.columnCategory : element.category.name,
        DatabaseConstant.columnCreated_on : element.createdOn.toString(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      print("$result");
    });

    print("done");
  }

  Future<List<ResultLocal>> getStories() async {
    List<ResultLocal> _stories = [];
    var db = await this.database;
    var result = await db.query(DatabaseConstant.tableName,where: "featured == 'true'");
    result.forEach((element) {
      var list = ResultLocal.fromJson(element);
      _stories.add(list);
    });
    return _stories;
  }

  // Future<int> delete(int id) async {
  //   var db = await this.database;
  //   return await db.delete(tableStory, where: '$columnId = ?', whereArgs: [id]);
  // }
}
