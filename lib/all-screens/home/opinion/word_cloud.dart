import 'package:flutter/material.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'model/response_opinions.dart' as questionArray;

import 'model/flutter_hashtags.dart';

class WordCloud{

  static Widget getWordCloud(context,questionArray.Question question){

    List<MaterialColor> colors = [
      Colors.lightBlue,
      Colors.deepOrange,
      Colors.amber,
      Colors.teal
    ];

    List<FlutterHashtag> wordList = [];
    List<Widget> widgets = <Widget>[];

    int colorNumber = 0;
    int textsize = 100;

    if(question.results.categories.length > 0){
      question.results.categories.forEach((element) {
        if(colorNumber >= colors.length){
          colorNumber=0;
        }
        textsize = textsize - 12;
        if(textsize < 30){textsize = 30;}
        wordList.add(FlutterHashtag(element.label, colors[colorNumber++], textsize, false));
      });


      for (var i = 0; i < wordList.length; i++) {
        widgets.add(ScatterItem(wordList[i], i));
      }
    }


    final screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.width / screenSize.height;

    return Center(
      child: FittedBox(
        child: Scatter(
          fillGaps: true,
          delegate: ArchimedeanSpiralScatterDelegate(ratio: ratio),
          children: widgets,
        ),
      ),
    );
  }
}

class ScatterItem extends StatelessWidget {
  ScatterItem(this.hashtag, this.index);
  final FlutterHashtag hashtag;
  final int index;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: hashtag.rotated ? 1 : 0,
      child: Text(
        hashtag.hashtag,
        style: TextStyle(
          fontSize: hashtag.size.toDouble(),
          fontWeight: FontWeight.w700,
          color: hashtag.color,
        ),
      ),
    );
  }
}