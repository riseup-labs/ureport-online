import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:ureport_ecaro/all-screens/home/chat/model/response-local-chat-parsing.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/model/response-opinion-localdb.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/ResponseStoryLocal.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/searchbar.dart';
import 'package:ureport_ecaro/database/database_constant.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';
import '/all-screens/home/stories/model/response-story-data.dart' as storyArray;
import 'package:ureport_ecaro/all-screens/home/opinion/model/response_opinions.dart'
    as opinionArray;
import 'package:path/path.dart' as p;

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
    // var dir = await getDatabasesPath();
    // var path = dir + "database.db";
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'ureport_online_db.db');

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

        db.execute('''
          create table ${DatabaseConstant.tableNameMessage} ( 
          ${DatabaseConstant.columnIDmessage} integer primary key AUTOINCREMENT NOT NULL, 
          ${DatabaseConstant.message} text,
          ${DatabaseConstant.sender} text,
          ${DatabaseConstant.status} text,
          ${DatabaseConstant.columnPROGRAM} text,
          ${DatabaseConstant.quicktypest} text,
          ${DatabaseConstant.time} text)
         
        ''');
      },
    );
    return database;
  }

  //Story section

  Future<bool> insertStory(List<storyArray.Result> list, String program) async {
    var db = await this.database;
    list.forEach((element) async {
      // var result = await db.insert(DatabaseConstant.tableName, element.toJson());
      var result = await db.insert(
          DatabaseConstant.tableName,
          {
            DatabaseConstant.columnID: element.id,
            DatabaseConstant.columnPROGRAM: program,
            DatabaseConstant.columnTitle: element.title,
            DatabaseConstant.columnFeatured: element.featured.toString(),
            DatabaseConstant.columnSummary: element.summary,
            DatabaseConstant.columnContent: '',
            DatabaseConstant.columnVideoId: '',
            DatabaseConstant.columnAudioLink: '',
            DatabaseConstant.columnTags: '',
            DatabaseConstant.columnImages: element.images.length > 0
                ? element.images[0]
                : element.category.imageUrl,
            DatabaseConstant.columnCategory: element.category.name,
            DatabaseConstant.columnCreated_on: element.createdOn.toString(),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    return true;
  }

  Future<List<ResultLocal>> getStories(String program) async {
    List<ResultLocal> _stories = [];
    var db = await this.database;
    var result = await db.rawQuery(
        "SELECT id,title,created_on,images,featured,summary FROM ${DatabaseConstant.tableName} WHERE program = '$program'");
    result.forEach((element) {
      var list = ResultLocal.fromJson(element);
      _stories.add(list);
    });
    return _stories;
  }

  Future<List<ResultLocal>> getRecentStory(String program) async {
    List<ResultLocal> _stories = [];
    var db = await this.database;
    var result = await db.rawQuery(
        "SELECT id FROM ${DatabaseConstant.tableName} WHERE  program = '$program' ORDER BY id DESC LIMIT 1 ");
    result.forEach((element) {
      var list = ResultLocal.fromJson(element);
      _stories.add(list);
    });
    return _stories;
  }

  Future<int> getStoryCount(String program) async {
    Database db = await this.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM ${DatabaseConstant.tableName} WHERE program = '$program'"));
    return count!;
  }

  Future<List<StorySearchList>> getStoryCategories(String program) async {
    List<StorySearchList> StoryCategory = [];

    var db = await this.database;

    var result = await db.rawQuery(
        "SELECT DISTINCT category FROM ${DatabaseConstant.tableName} WHERE program = '$program' ORDER BY LOWER(category) ASC");
    var resultTitle = await db.rawQuery(
        "SELECT id,title,category,created_on,images FROM ${DatabaseConstant.tableName} WHERE program = '$program' ORDER by id DESC");

    result.forEach((element) {
      List<StorySearchItem> titles = [];
      String img = "";
      var item = ResultLocal.fromJson(element);
      img = item.images ?? "";
      resultTitle.forEach((element) {
        var itemTitle = ResultLocal.fromJson(element);
        if (itemTitle.category == item.category) {
          titles.add(new StorySearchItem(itemTitle.id!, itemTitle.title!,
              itemTitle.images!, itemTitle.createdOn!));
        }
      });
      StoryCategory.add(StorySearchList(item.category!, img, titles));
    });
    return StoryCategory;
  }

  Future<int> deleteStoryTable() async {
    var db = await this.database;
    return await db.delete(DatabaseConstant.tableName);
  }

  //Opinion section

  Future<bool> insertOpinion(
      List<opinionArray.Result?> list, String program) async {
    var db = await this.database;

    list.forEach((element) async {
      var result = await db.insert(
          DatabaseConstant.tableNameOpinion,
          {
            DatabaseConstant.columnIDOpinion: element!.id,
            DatabaseConstant.columnTitleOpinion: element.title,
            DatabaseConstant.columnCategoryOpinion: element.category.name,
            DatabaseConstant.columnOrganizationOpinion: element.org,
            DatabaseConstant.columnPollDateOpinion: element.pollDate.toString(),
            DatabaseConstant.columnProgramOpinion: program,
            DatabaseConstant.columnQuestionOpinion:
                jsonEncode(element.questions),
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    return true;
  }

  Future<List<OpinionSearchList>> getOpinionCategories(String program) async {
    List<OpinionSearchList> opinionCategory = [];

    var db = await this.database;

    var result = await db.rawQuery(
        "SELECT DISTINCT category FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' ORDER BY LOWER(category) ASC");
    var resultTitle = await db.rawQuery(
        "SELECT id,title,poll_date,category FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' ORDER by id DESC");
    result.forEach((element) {
      List<OpinionSearchItem> titles = [];
      var category = ResultOpinionLocal.fromJson(element);
      resultTitle.forEach((element) {
        var title = ResultOpinionLocal.fromJson(element);
        if (title.category == category.category) {
          titles.add(
              new OpinionSearchItem(title.id, title.title, title.polldate));
        }
      });
      opinionCategory.add(new OpinionSearchList(category.category, titles));
    });
    return opinionCategory;
  }

  Future<List<ResultOpinionLocal>> getOpinions(String program, int id) async {
    List<ResultOpinionLocal> opinion = [];
    var db = await this.database;
    var result;
    if (id == 0) {
      result = await db.rawQuery(
          "SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE program = '$program' order by ${DatabaseConstant.columnIDOpinion} DESC limit 1");
    } else {
      result = await db.rawQuery(
          "SELECT * FROM ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnIDOpinion} = $id order by ${DatabaseConstant.columnIDOpinion} DESC limit 1");
    }
    result.forEach((element) {
      var list = ResultOpinionLocal.fromJson(element);
      opinion.add(list);
    });

    return opinion;
  }

  Future<int> getOpinionCount(String program) async {
    Database db = await this.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM ${DatabaseConstant.tableNameOpinion} WHERE ${DatabaseConstant.columnProgramOpinion} = '$program'"));
    print("Opinion count: $count");
    print("Opinion count: $program");
    return count!;
  }

  //Chat section

  Future<bool> insertConversation(
      List<MessageModel> list, String program) async {
    var db = await this.database;
    list.forEach((element) async {
      // var result = await db.insert(DatabaseConstant.tableName, element.toJson());
      var result = await db.insert(
          DatabaseConstant.tableNameMessage,
          {
            DatabaseConstant.message: element.message,
            DatabaseConstant.sender: element.sender,
            DatabaseConstant.status: element.status,
            DatabaseConstant.quicktypest: jsonEncode(element.quicktypest),
            DatabaseConstant.time: element.time,
            DatabaseConstant.columnPROGRAM: program,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    return true;
  }

  Future<List<MessageModelLocal>> getConversation(String program) async {
    List<MessageModelLocal> _conversation = [];
    var db = await this.database;
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    var result = await db.rawQuery(
        "SELECT * FROM ${DatabaseConstant.tableNameMessage} WHERE program = '$program'");
    result.forEach((element) {
      var list = MessageModelLocal.fromJson(element);
      _conversation.add(list);
    });
    return _conversation;
  }

  Future<bool> deleteConversation(String program) async {
    var db = await this.database;
    db.transaction((txn) async {
      var batch = txn.batch();

      batch.delete(DatabaseConstant.tableNameMessage,
          where: "program = '$program'");
      await batch.commit();
    });
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    // await db.rawDelete("delete FROM ${DatabaseConstant.tableNameMessage}");
    print("message deleted");
    return true;
  }

  deleteSingelMessage(time, String program) async {
    var db = await this.database;
    // var result = await db.query(DatabaseConstant.tableName,where: "featured = 'true' && 'program' = 'Global'");
    await db.rawDelete(
        "delete  FROM ${DatabaseConstant.tableNameMessage} where ${DatabaseConstant.time}='${time}'");
    return true;
  }

  Future<bool> updateSingleMessage(MessageModelLocal msg) async {
    var db = await this.database;
    await db
        .rawQuery(
            "UPDATE  ${DatabaseConstant.tableNameMessage} SET ${DatabaseConstant.message} ='${msg.message}', ${DatabaseConstant.quicktypest}='null' where ${DatabaseConstant.time}='${msg.time}'")
        .then((value) {
      return true;
    });
    return false;
  }

  Future<bool> updateQuicktypeMessage(time, data) async {
    var db = await this.database;
    await db
        .rawDelete(
            "UPDATE  ${DatabaseConstant.tableNameMessage} SET ${DatabaseConstant.quicktypest} ='${jsonEncode(data)}' where ${DatabaseConstant.time}='${time}'")
        .then((value) {
      return true;
    });

    return false;
  }

  Future<int> getMessageCount(String program) async {
    Database db = await this.database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM ${DatabaseConstant.tableNameMessage} WHERE program = '$program'"));
    return count!;
  }
}
