import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:ureport_ecaro/all-screens/home/stories/stories-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/api_constant.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'model/ResponseStoryLocal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'model/searchbar.dart';

FloatingSearchBarController _floatingSearchBarController =
FloatingSearchBarController();
List<DataList> filteredCategoryList = [];
List<DataList> categoryListFull = [];

var isLoaded = true;

class StoryList extends StatefulWidget {
  @override
  _StoryListState createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  @override
  Widget build(BuildContext context) {
    var sp = locator<SPUtil>();
    Provider.of<StoryController>(context, listen: false).initializeDatabase();
    List<ResultLocal>? stories = [];
    Provider.of<StoryController>(context, listen: false).getStoriesFromLocal(sp.getValue(SPUtil.PROGRAMKEY));
    Provider.of<StoryController>(context, listen: false).getStoriesFromRemote(RemoteConfigData.getStoryUrl(sp.getValue(SPUtil.PROGRAMKEY)),sp.getValue(SPUtil.PROGRAMKEY));

    return Consumer<StoryController>(builder: (context, provider, snapshot) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Divider(
                        height: 1.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: FutureBuilder<List<ResultLocal>>(
                            future: provider.getStoriesFromLocal(
                                sp.getValue(SPUtil.PROGRAMKEY)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                stories = List.from(snapshot.data!.reversed);
                              }
                              return stories!.length > 0
                                  ? ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  addAutomaticKeepAlives: true,
                                  itemCount: stories!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        NavUtils.push(
                                            context,
                                            StoryDetails(
                                                stories![index]
                                                    .id
                                                    .toString(),
                                                stories![index]
                                                    .title
                                                    .toString(),
                                                stories![index]
                                                    .images
                                                    .toString()));
                                      },
                                      child: Container(
                                        child: getItem(
                                            stories?[index].images != ''
                                                ? stories![index].images
                                                : "assets/images/default.jpg",
                                            "",
                                            stories![index].title,
                                            stories![index].summary),
                                      ),
                                    );
                                  })
                                  : Center(child: CircularProgressIndicator());
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  left: 20,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Image(
                        fit: BoxFit.fill,
                        height: 30,
                        width: 150,
                        image: AssetImage('assets/images/ureport_logo.png')),
                  )),
              Positioned(
                  top: 45,
                  left: 20,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          "${AppLocalizations.of(context)!.stories}",
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontFamily: 'Dosis'),
                        ),
                      )
                    ],
                  )),
              Positioned(
                  top: 45,
                  right: 10,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                      ),
                      width: 220,
                      height: 460,
                      child: searchBarUI(
                          provider, sp.getValue(SPUtil.PROGRAMKEY)))),
            ],
          ),
        ),
      );
    });
  }

  Widget searchBarUI(StoryController provider, String program) {
    return FutureBuilder<List<DataList>>(
        future: provider.getCategories(program),
        builder: (context, snapshot) {
          if (snapshot.hasData && isLoaded) {
            filteredCategoryList = snapshot.data!;
            categoryListFull.addAll(snapshot.data!);
            isLoaded = false;
          }
          return FloatingSearchBar(
            hint: 'Search',
            leadingActions: [Icon(Icons.search)],
            openAxisAlignment: 0.0,
            controller: _floatingSearchBarController,
            width: 220,
            height: 40.0,
            elevation: 0.0,
            axisAlignment: 0.0,
            scrollPadding: EdgeInsets.only(bottom: 10, top: 5),
            physics: BouncingScrollPhysics(),
            onQueryChanged: (value) {
              setState(() {
                filteredCategoryList.clear();
                for (var item in categoryListFull) {
                  if (item.title.toLowerCase().contains(value.toLowerCase())) {
                    filteredCategoryList.add(item);
                  }
                }
              });
            },
            automaticallyImplyDrawerHamburger: true,
            transitionCurve: Curves.easeInOut,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4)),
            transitionDuration: Duration(milliseconds: 500),
            transition: CircularFloatingSearchBarTransition(),
            debounceDelay: Duration(milliseconds: 500),
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: CircularButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    print('Places Pressed');
                  },
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: Colors.white,
                  child: Container(
                    height: 400.0,
                    color: Colors.white,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          DataPopUp(filteredCategoryList[index]),
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

Widget buildItem(StoryItem item) {
  return Container(
      child: GestureDetector(
          onTap: () {
            _floatingSearchBarController.clear();
            _floatingSearchBarController.close();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(item.title, style: TextStyle(fontSize: 13)),
                padding: EdgeInsets.all(8),
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
  const DataPopUp(this.popup);

  final DataList popup;

  Widget _buildTiles(DataList root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));

    List<Widget> list = [];

    for (var item in root.children) {
      list.add(buildItem(item));
    }

    return ExpansionTile(
        key: PageStorageKey<DataList>(root),
        trailing: Icon(Icons.arrow_drop_down),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              root.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: list);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup);
  }
}

getBackground() {
  return Image(image: AssetImage("assets/images/bg_home.png"));
}

getItem(String image_url, String date, String title, String summery) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.only(top: 10, bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        getItemTitleImage(image_url),
        getItemDate(date),
        getItemTitle(title),
        getItemSummery(summery),
      ],
    ),
  );
}
//test

getItemTitleImage(String image_url) {
  return ClipRRect(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    child: CachedNetworkImage(
      height: 200,
      fit: BoxFit.fill,
      imageUrl: image_url,
      progressIndicatorBuilder: (context, url, downloadProgress) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 40, width: 40, child: CircularProgressIndicator()),
          SizedBox(
            height: 10,
          ),
          Text("Loading")
        ],
      ),
      errorWidget: (context, url, error) => Container(
          color: AppColors.errorWidgetBack,
          child: Center(
              child: Image(
            image: AssetImage("assets/images/ic_no_image.png"),
            height: 50,
            width: 50,
          ))),
    ),
  );
}

getItemDate(String date) {
  return Container(
    padding: EdgeInsets.only(top: 10, left: 10),
    child: Text(
      date,
      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
    ),
  );
}

getItemTitle(String title) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}

getItemSummery(String summery) {
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: Text(
      summery,
      style: TextStyle(fontSize: 14),
    ),
  );
}
