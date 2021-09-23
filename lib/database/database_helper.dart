import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/model/response-opinion-localdb.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/ResponseStoryLocal.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/searchbar.dart';
import 'package:ureport_ecaro/database/database_constant.dart';
import '/all-screens/home/stories/model/response-story-data.dart' as storyArray;
import 'package:ureport_ecaro/all-screens/home/opinion/model/response_opinions.dart' as opinionArray;
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
          ${DatabaseConstant.columnQuestionOpinion} text,
          ${DatabaseConstant.columnPollDateOpinion} text)
   
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
        DatabaseConstant.columnImages : element.images.length>0?element.images[0]:element.category.imageUrl,
        DatabaseConstant.columnCategory : element.category.name,
        DatabaseConstant.columnCreated_on : element.createdOn.toString(),

      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    return true;

  }

  Future<bool> insertOpinion(List<opinionArray.Result?> list,String program) async {
    var db = await this.database;

    list.forEach((element) async {
      var result = await db.insert(DatabaseConstant.tableNameOpinion, {
        DatabaseConstant.columnIDOpinion : element!.id,
        DatabaseConstant.columnTitleOpinion : element.title,
        DatabaseConstant.columnCategoryOpinion : element.category.name,
        DatabaseConstant.columnOrganizationOpinion : element.org,
        DatabaseConstant.columnPollDateOpinion : element.pollDate.toString(),
        DatabaseConstant.columnProgramOpinion : program,
        DatabaseConstant.columnQuestionOpinion : jsonEncode(element.questions),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<List<StorySearchList>> getStoryCategories(String program) async {
    List<StorySearchList> StoryCategory = [];

    var db = await this.database;

    var result = await db.rawQuery("SELECT DISTINCT category FROM ${DatabaseConstant.tableName} WHERE program = '$program' ORDER BY LOWER(category) ASC");
    var resultTitle = await db.rawQuery("SELECT * FROM ${DatabaseConstant.tableName} WHERE program = '$program' ORDER by id DESC");

    result.forEach((element) {
      List<StorySearchItem> titles = [];
      var item = ResultLocal.fromJson(element);
      resultTitle.forEach((element) {
        var itemTitle = ResultLocal.fromJson(element);
        if(itemTitle.category == item.category){
          titles.add(new StorySearchItem(itemTitle.id,itemTitle.title, itemTitle.images, itemTitle.createdOn));
        }
      });
      StoryCategory.add(new StorySearchList(item.category,titles));
    });
    return StoryCategory;
  }

  Future<List<OpinionSearchList>> getOpinionCategories(String program) async {
    List<OpinionSearchList> opinionCategory = [];

    var db = await this.database;

    var result = await db.rawQuery("SELECT DISTINCT category FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' ORDER BY LOWER(category) ASC");
    var resultTitle = await db.rawQuery("SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' ORDER by id DESC");

    result.forEach((element) {
      List<OpinionSearchItem> titles = [];
      var item = ResultOpinionLocal.fromJson(element);
      resultTitle.forEach((element) {
        var itemTitle = ResultOpinionLocal.fromJson(element);
        if(itemTitle.category == item.category){
          titles.add(new OpinionSearchItem(itemTitle.id,itemTitle.title, itemTitle.polldate));
        }
      });
      opinionCategory.add(new OpinionSearchList(item.category,titles));
    });
    return opinionCategory;
  }

  Future<List<ResultOpinionLocal>> getOpinions(String program,int id) async {
    List<ResultOpinionLocal> opinion = [];
    var db = await this.database;
    var result;
    if(id == 0){
      result = await db.rawQuery("SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' order by ${DatabaseConstant.columnIDOpinion} DESC");
    }else{
      result = await db.rawQuery("SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnIDOpinion} = $id order by ${DatabaseConstant.columnIDOpinion} DESC");
    }
    result.forEach((element) {
      var list = ResultOpinionLocal.fromJson(element);
      opinion.add(list);
    });

    return opinion;
  }

  Future<int> deleteStoryTable() async {
    var db = await this.database;
    return await db.delete(DatabaseConstant.tableName);
  }
}
