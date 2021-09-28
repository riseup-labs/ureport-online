import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/save_story.dart';
import 'package:ureport_ecaro/all-screens/home/stories/stories-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'model/searchbar.dart';

FloatingSearchBarController _floatingSearchBarController =
    FloatingSearchBarController();
List<StorySearchList> filteredCategoryList = [];
List<StorySearchList> categoryListFull = [];
var isLoaded = true;

class StorySearch extends StatefulWidget {
  const StorySearch({Key? key}) : super(key: key);

  @override
  _StorySearchState createState() => _StorySearchState();
}

class _StorySearchState extends State<StorySearch> {
  var sp = locator<SPUtil>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StoryController>(context, listen: false).isExpanded = false;
    filteredCategoryList.clear();
    categoryListFull.clear();
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StoryController>(context, listen: false)
        .getCategories(sp.getValue(SPUtil.PROGRAMKEY));

    return Consumer<StoryController>(builder: (context, provider, snapshot) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              color: AppColors.white,
              height: 86,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 12,
                    left: 10,
                    child: Container(
                      width: 40,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40,right: 12,top: 10),
                      child: searchBarUI(provider, sp.getValue(SPUtil.PROGRAMKEY))),
                  Container(
                    margin: EdgeInsets.only(top: 66),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FutureBuilder<List<StorySearchList>>(
                        future: provider.getCategories(sp.getValue(SPUtil.PROGRAMKEY)),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && isLoaded) {
                            filteredCategoryList = snapshot.data!;
                            categoryListFull.addAll(snapshot.data!);
                            isLoaded = false;
                          }
                          return filteredCategoryList.length != 0 ?  Container(
                            color: AppColors.white,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) =>
                                  DataPopUp(filteredCategoryList[index], provider),
                              itemCount: filteredCategoryList.length,
                            ),
                          ):Container(
                              margin: EdgeInsets.only(top: 66),
                              child: Center(child: CircularProgressIndicator()));
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
    return FutureBuilder<List<StorySearchList>>(
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
            width: double.infinity,
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
            transitionDuration: Duration(milliseconds: 100),
            transition: CircularFloatingSearchBarTransition(),
            debounceDelay: Duration(milliseconds: 100),
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

Widget buildItem(StorySearchItem item, BuildContext context) {

  final dateTime = DateTime.parse(item.date);
  final format = DateFormat('dd MMMM, yyyy');
  final titleDate = format.format(dateTime);

  return Container(
      child: GestureDetector(
          onTap: () {
            _floatingSearchBarController.clear();
            _floatingSearchBarController.close();
            NavUtils.pushReplacement(
                context,
                StoryDetails(item.id.toString(), item.title.toString(),
                    item.image,
                    item.date
                ));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 17, bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right, size: 20,),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Dosis"
                      ),
                      children: <TextSpan>[
                        TextSpan(text: item.title),
                        TextSpan(text: "  "),
                        TextSpan(text: titleDate, style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
      ));
}

class DataPopUp extends StatelessWidget {
  const DataPopUp(this.popup, this.provider);

  final StorySearchList popup;

  final StoryController provider;

  Widget _buildTiles(StorySearchList root, BuildContext context) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));

    List<Widget> list = [];

    for (var item in root.children) {
      list.add(buildItem(item, context));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 3),
          child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: PageStorageKey<StorySearchList>(root),
            textColor: Colors.black,
            collapsedTextColor: Colors.black,
            trailing: Icon(Icons.arrow_drop_down),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  root.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),

            children: list,
            initiallyExpanded: provider.isExpanded,
            onExpansionChanged: (value){

            },
          ),)

        ),
        Container(
          margin: EdgeInsets.only(left: 17, right: 17),
          child: DottedLine(
            dashColor: AppColors.primary,
            dashLength: 2,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup, context);
  }
}
