import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/model/article.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';
import 'package:intl/intl.dart';

class ArticleView extends StatelessWidget {
  ArticleView({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            TopHeaderWidget(title: "Categorii"),
            Image.network(
              article.img,
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 20,
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
              margin: EdgeInsets.only(top: 10, left: 20, right: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Autor",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(article.author)
                    ],
                  ),
                  Column(
                    children: [
                      Text("Data",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(formatter.format(article.createdAt))
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
