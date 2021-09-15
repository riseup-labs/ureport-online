import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/stories-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'model/searchbar.dart';

FloatingSearchBarController _floatingSearchBarController =
    FloatingSearchBarController();
List<DataList> filteredCategoryList = [];
List<DataList> categoryListFull = [];
var isLoaded = true;

class StorySearch extends StatefulWidget {
  const StorySearch({Key? key}) : super(key: key);

  @override
  _StorySearchState createState() => _StorySearchState();
}

class _StorySearchState extends State<StorySearch> {
  var sp = locator<SPUtil>();

  @override
  Widget build(BuildContext context) {
    Provider.of<StoryController>(context, listen: false)
        .getCategories(sp.getValue(SPUtil.PROGRAMKEY));

    return Consumer<StoryController>(builder: (context, provider, snapshot) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            color: Colors.black,
            onPressed: () {},
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Search",
            style: TextStyle(color: Colors.black),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_home.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColors.bluelight,
              height: 86,
              padding: EdgeInsets.all(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  searchBarUI(provider, sp.getValue(SPUtil.PROGRAMKEY)),
                  Container(
                    margin: EdgeInsets.only(top: 66),
                    child: FutureBuilder<List<DataList>>(
                        future: provider
                            .getCategories(sp.getValue(SPUtil.PROGRAMKEY)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && isLoaded) {
                            filteredCategoryList = snapshot.data!;
                            categoryListFull.addAll(snapshot.data!);
                            isLoaded = false;
                          }
                          return Container(
                            color: AppColors.white,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) =>
                                  DataPopUp(
                                      filteredCategoryList[index], provider),
                              itemCount: filteredCategoryList.length,
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget searchBarUI(StoryController provider, String program) {
    return FutureBuilder<List<DataList>>(
        future: provider.getCategories(program),
        builder: (context, snapshot) {
          return FloatingSearchBar(
            hint: 'Search',
            leadingActions: [Icon(Icons.search)],
            openAxisAlignment: 0.0,
            backdropColor: Colors.transparent,
            backgroundColor: AppColors.white,
            controller: _floatingSearchBarController,
            height: 40.0,
            elevation: 0.0,
            axisAlignment: 0.0,
            automaticallyImplyBackButton: false,
            scrollPadding: EdgeInsets.only(bottom: 10, top: 5),
            physics: BouncingScrollPhysics(),
            onQueryChanged: (value) {
              if(value == ""){
                provider.setExpanded(false);
              }else{
                provider.setExpanded(true);
              }
              setState(() {
                filteredCategoryList.clear();
                for (var item in categoryListFull) {
                  for (var child in item.children) {
                    if (child.title
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      filteredCategoryList.add(item);
                      break;
                    }
                  }
                }
              });
            },
            automaticallyImplyDrawerHamburger: false,
            transitionCurve: Curves.easeInOut,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
            transitionDuration: Duration(milliseconds: 500),
            transition: CircularFloatingSearchBarTransition(),
            debounceDelay: Duration(milliseconds: 500),
            actions: [],
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: Colors.white,
                  child: Container(
                    height: 1.0,
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          DataPopUp(filteredCategoryList[index], provider),
                      itemCount: filteredCategoryList.length,
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

Widget buildItem(StoryItem item, BuildContext context) {
  return Container(
      child: GestureDetector(
          onTap: () {
            _floatingSearchBarController.clear();
            _floatingSearchBarController.close();
            NavUtils.push(
                context,
                StoryDetails(item.id.toString(), item.title.toString(),
                    item.image,
                    item.date
                ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 16),
                ),
                padding:
                    EdgeInsets.only(top: 8, left: 15, bottom: 8, right: 15),
              ),
              SizedBox(
                height: 3,
              ),
              Divider(
                height: 1,
                color: AppColors.gray7E,
              )
            ],
          )));
}

class DataPopUp extends StatelessWidget {
  const DataPopUp(this.popup, this.provider);

  final DataList popup;

  final StoryController provider;

  Widget _buildTiles(DataList root, BuildContext context) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));

    List<Widget> list = [];

    for (var item in root.children) {
      list.add(buildItem(item, context));
    }

    return ExpansionTile(
      key: PageStorageKey<DataList>(root),
      textColor: Colors.black,
      collapsedTextColor: Colors.black,
      trailing: Icon(Icons.arrow_drop_down),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            root.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          DottedLine(
            dashColor: AppColors.primary,
            dashLength: 2,
          )
        ],
      ),
      children: list,
      initiallyExpanded: provider.isExpanded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup, context);
  }
}
