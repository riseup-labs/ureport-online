import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class StorageUtil {

  static Future<String> readStory(String fileName) async {

    String content = "";

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = await directory.path;
      final file = await File('$path/$fileName.txt');

      // Read the file
      if(file.existsSync()){
        content = await file.readAsString();
      }else{
        content  = "No file found";
      }

      return content;

    } catch (e) {
      // If encountering an error, return 0
      return "error";
    }
  }

  static writeStory(String content, String fileName) async {

    final directory = await getApplicationDocumentsDirectory();
    final path = await directory.path;
    final file = await File('$path/$fileName.txt');
    if(!file.existsSync()){
      file.writeAsString('$content');
    }
  }
}