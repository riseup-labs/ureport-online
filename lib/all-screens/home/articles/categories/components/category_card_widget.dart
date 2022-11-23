import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/articles_list_view.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/model/category.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    Key? key,
    required this.category,
  }) : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          NavUtils.push(context, ArticlesListView(category: category));
        },
        child: Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Image.asset(
            category.img,
            fit: BoxFit.contain,
          ),
        ));
  }
}
