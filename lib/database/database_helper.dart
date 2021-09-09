import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:ureport_ecaro/all-screens/home/opinions/model/response-opinion-localdb.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/ResponseStoryLocal.dart';
import 'package:ureport_ecaro/database/database_constant.dart';
import '/all-screens/home/stories/model/response-story-data.dart' as storyArray;
import 'package:ureport_ecaro/all-screens/home/opinions/model/Response_opinions.dart' as opinionArray;
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
          ${DatabaseConstant.columnPROGRAM} text,
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
        db.execute('''
          create table ${DatabaseConstant.tableNameOpinion} ( 
          ${DatabaseConstant.columnIDOpinion} integer primary key, 
          ${DatabaseConstant.columnTitleOpinion} text,
          ${DatabaseConstant.columnCategoryOpinion} text,
          ${DatabaseConstant.columnOrganizationOpinion} text,
          ${DatabaseConstant.columnProgramOpinion} text,
          ${DatabaseConstant.columnQuestionOpinion} text)
          
        ''');


      },
    );
    return database;
  }






  Future<bool> insertStory(List<storyArray.Result> list, String program) async {
    var db = await this.database;
    list.forEach((element) async {
      // var result = await db.insert(DatabaseConstant.tableName, element.toJson());
      var result = await db.insert(DatabaseConstant.tableName, {
        DatabaseConstant.columnID : element.id,
        DatabaseConstant.columnPROGRAM : program,
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

    return true;

  }

  Future<bool> insertOpinion(List<opinionArray.Result?> list,String program) async {
    var db = await this.database;

    list.forEach((element) async {
      // var result = await db.insert(DatabaseConstant.tableName, element.toJson());

      var result = await db.insert(DatabaseConstant.tableNameOpinion, {
        DatabaseConstant.columnIDOpinion : element!.id,
        DatabaseConstant.columnTitleOpinion : element.title,
        DatabaseConstant.columnCategoryOpinion : element.category.name,
        DatabaseConstant.columnOrganizationOpinion : element.org,
        DatabaseConstant.columnProgramOpinion : program,
        DatabaseConstant.columnQuestionOpinion : jsonEncode(element.questions),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      print("$result");
    });

    print("done");

    return true;

  }

  Future<List<ResultLocal>> getStories(String program) async {
    List<ResultLocal> _stories = [];
    var db = await this.database;
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    var result = await db.rawQuery("SELECT * FROM ${DatabaseConstant.tableName} WHERE featured = 'true' AND program = '$program'");
    result.forEach((element) {
      var list = ResultLocal.fromJson(element);
      _stories.add(list);
    });
    return _stories;
  }

  Future<List<ResultOpinionLocal>> getOpinions(String program) async {
    List<ResultOpinionLocal> opinion = [];
    var db = await this.database;
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    var result = await db.rawQuery("SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program'");
    result.forEach((element) {
      var list = ResultOpinionLocal.fromJson(element);
      opinion.add(list);
    });
    return opinion;
  }

  Future<List<String>> getOpinionCategory(String program)async{
    List<String> category =[];
    var db = await this.database;
    var result = await db.rawQuery("SELECT DISTINCT ${DatabaseConstant.columnCategoryOpinion} FROM  ${DatabaseConstant.tableNameOpinion} WHERE program = '$program'");
    result.forEach((element) {
      var list =ResultOpinionLocal.fromJson(element);
      category.add(list.category);
    });
    return category;
  }

  Future<List<String>> getOpinionTitle(String category) async {

    List<String> titles =[];
    var db = await this.database;
    var result = await db.rawQuery("SELECT DISTINCT ${DatabaseConstant.columnTitleOpinion} FROM  ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnCategoryOpinion} = '$category'");
    result.forEach((element) {

      var list =ResultOpinionLocal.fromJson(element);
      titles.add(list.title);

    });
    return titles;

  }


  Future<List<String>> getOpinionQuestion(String title) async {

    List<String> Question =[];
    var db = await this.database;
    var result = await db.rawQuery("SELECT  ${DatabaseConstant.columnQuestionOpinion} FROM  ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnTitleOpinion} = '$title'");
    result.forEach((element) {
      var list =ResultOpinionLocal.fromJson(element);
      Question.add(list.questions);
    });
    return Question;
  }
  // get opinion category according to program ==select distinct  category From tablenameOpinion where program = $program
  // get opinion title according to category  select distinct title from tablenameopoinion where category = $category
  // get opinoin question according to title  select quistion from tablenameopinion where title = $title
  Future<int> deleteStoryTable() async {
    var db = await this.database;
    return await db.delete(DatabaseConstant.tableName);
  }
}
