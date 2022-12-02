import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/article/model/article.dart';
import 'package:ureport_ecaro/all-screens/home/articles/categories/components/category_card_widget.dart';
import 'package:ureport_ecaro/all-screens/home/articles/categories/components/search_bar_widget.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/title_description_widget.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

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
              content:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In nisi massa, sagittis ut pharetra non, tempus ac eros. Curabitur id dolor quam. Suspendisse potenti. Proin hendrerit dui nec leo cursus pretium. Fusce ac lectus massa. Nunc vestibulum tristique lectus in gravida. Suspendisse condimentum id ligula at pellentesque. Sed blandit est fringilla egestas tincidunt. Aliquam erat volutpat. Vivamus fringilla, ante nec rutrum efficitur, sem felis ornare ante, sed suscipit velit libero non nunc. In hac habitasse platea dictumst.\nIn hac habitasse platea dictumst. Donec nisi purus, posuere ac dui nec, ornare ullamcorper ante. Aliquam quam quam, pellentesque id imperdiet ac, feugiat ut turpis. Integer in feugiat turpis. Suspendisse id congue magna. Phasellus at nibh auctor quam pulvinar volutpat. Nunc convallis enim a nisl sagittis, sed eleifend purus imperdiet. Aenean non dolor commodo, luctus quam a, viverra elit. Nunc fermentum augue at metus ultrices, eu congue nisl venenatis. Ut tincidunt, purus a interdum consectetur, nunc justo maximus massa, eget dictum risus nulla quis tellus. Proin a blandit sapien. Mauris libero purus, molestie vitae tempus rutrum, tempus eu mi. Curabitur a ligula ut dui feugiat pellentesque non a risus. Phasellus lorem purus, ultricies quis convallis sodales, gravida a libero. Phasellus varius aliquet felis, id ultricies mi porta et. Sed maximus justo non mattis euismod.\nSuspendisse pharetra diam nunc, at fermentum elit cursus vel. Aenean porttitor sapien nunc. In quis eleifend turpis, et venenatis arcu. Cras ipsum libero, placerat malesuada volutpat non, elementum eget nisl. Suspendisse erat tortor, auctor at tempor a, elementum a nunc. Nunc lacinia facilisis felis, et tincidunt risus mattis nec. Suspendisse ac ultrices nisi. Suspendisse nulla eros, iaculis vitae justo ut, fringilla rhoncus dui. Sed bibendum sed sapien vitae finibus. Aenean sagittis mauris sed hendrerit varius. Aenean quis leo ex. Fusce porttitor orci justo.\nClass aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nunc tortor urna, laoreet semper metus ut, ultrices elementum libero. Sed hendrerit vulputate magna, in suscipit justo congue et. Nulla eget tincidunt turpis. Duis commodo feugiat libero, sit amet bibendum odio. Donec maximus nec enim vitae porta. Praesent convallis, arcu egestas auctor porta, purus odio aliquam eros, ultrices tincidunt nulla mauris vel turpis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nunc laoreet suscipit arcu id placerat. Maecenas a lacinia odio. Duis ultricies mi ligula, sed convallis lectus iaculis vel.",
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
