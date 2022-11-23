import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/article_view.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/model/article.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class ArticleItemWidget extends StatelessWidget {
  ArticleItemWidget({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => NavUtils.push(context, ArticleView(article: article)),
      child: Container(
          height: 300,
          width: width,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(8, 8),
                  spreadRadius: 2,
                  blurRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                ),
              ]),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  width: width,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(20)),
                  ),
                  child: Image.network(
                    article.img,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: Color.fromRGBO(201, 13, 182, 1),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      article.type,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  article.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  "CITEȘTE MAI MULT",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(49, 32, 242, 0.6)),
                ),
              ),
            ],
          )),
    );
  }
}
