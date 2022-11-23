import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/articles_list_view.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/model/article.dart';
import 'package:ureport_ecaro/all-screens/home/articles/categories/components/category_card_widget.dart';
import 'package:ureport_ecaro/all-screens/home/articles/categories/components/search_bar_widget.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/title_description_widget.dart';

import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

import '../article/model/category.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<Category> initCategoryList = [
    Category(
        id: 1,
        title: "Sanatate",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        img: "assets/images/temp/1.png",
        articles: [
          Article(
              id: 1,
              title: "Beneficiile vaccinării împotriva COVID-19",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Studiu"),
          Article(
              id: 2,
              title: "Article 2",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Articol"),
        ]),
    Category(
        id: 2,
        title: "Mediu",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        img: "assets/images/temp/2.png",
        articles: [
          Article(
              id: 1,
              title: "Article 1",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Studiu"),
          Article(
              id: 2,
              title: "Article 2",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Articol"),
        ]),
    Category(
        id: 3,
        title: "Digital",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        img: "assets/images/temp/3.png",
        articles: [
          Article(
              id: 1,
              title: "Article 1",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Studiu"),
          Article(
              id: 2,
              title: "Article 2",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Articol"),
        ]),
    Category(
        id: 4,
        title: "Ocupare",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        img: "assets/images/temp/4.png",
        articles: [
          Article(
              id: 1,
              title: "Article 1",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Studiu"),
          Article(
              id: 2,
              title: "Article 2",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Articol"),
        ]),
    Category(
        id: 5,
        title: "Drepturi si Responsabilitate",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        img: "assets/images/temp/5.png",
        articles: [
          Article(
              id: 1,
              title: "Article 1",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Studiu"),
          Article(
              id: 2,
              title: "Article 2",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img: "",
              type: "Articol"),
        ]),
    Category(
        id: 6,
        title: "Printre spatii",
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        img: "assets/images/temp/6.png",
        articles: [
          Article(
              id: 1,
              title: "Article 1",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Studiu"),
          Article(
              id: 2,
              title: "Article 2",
              content: "Description 1",
              author: 'Admin',
              createdAt: DateTime.now(),
              img:
                  "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
              type: "Articol"),
        ]),
  ];

  List<Category> finalCategoryList = [];

  @override
  void initState() {
    finalCategoryList = initCategoryList;
    super.initState();
  }

  void searchList(String? value) {
    //initCategoryList
    if (value != null && value.isNotEmpty) {
      List<Category> tempList = [];
      for (int i = 0; i < initCategoryList.length; i++) {
        if (initCategoryList[i]
            .title
            .toLowerCase()
            .startsWith(value.toLowerCase())) {
          tempList.add(initCategoryList[i]);
        }
      }
      setState(() {
        finalCategoryList = tempList;
      });
      tempList = [];
    } else {
      setState(() {
        finalCategoryList = initCategoryList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            TopHeaderWidget(title: "Categorii"),
            SearchBarWidget(
              onSearchChanged: searchList,
            ),
            SizedBox(
              height: 20,
            ),
            TitleDescriptionWidget(
              title: "Categorii",
              description:
                  "Navighează prin categoriile de mai jos, alege ce te pasionează și câștigă puncte pentru a deveni cel mai bun!  ",
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: finalCategoryList.length,
                    itemBuilder: (context, index) {
                      return CategoryCardWidget(
                        category: finalCategoryList[index],
                      );
                    }),
              ],
            )
          ],
        )),
      ),
    );
  }
}
