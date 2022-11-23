import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/components/article_item.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/model/category.dart';

import 'package:ureport_ecaro/all-screens/home/articles/shared/title_description_widget.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

class ArticlesListView extends StatelessWidget {
  ArticlesListView({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopHeaderWidget(title: category.title),
              Image.asset(
                category.img,
                width: MediaQuery.of(context).size.width,
                height: 180,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              TitleDescriptionWidget(
                title: category.title,
                description: category.description,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: category.articles.length,
                      itemBuilder: (context, index) {
                        return ArticleItemWidget(
                          article: category.articles[index],
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
