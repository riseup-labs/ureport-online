import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/searchbar.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/loading_bar.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'opinion_controller.dart';

FloatingSearchBarController _floatingSearchBarController =
FloatingSearchBarController();
List<OpinionSearchList> filteredCategoryList = [];
List<OpinionSearchList> categoryListFull = [];
var isLoaded = true;

class OpinionSearch extends StatefulWidget {
  const OpinionSearch({Key? key}) : super(key: key);

  @override
  _OpinionSearchState createState() => _OpinionSearchState();
}

class _OpinionSearchState extends State<OpinionSearch> {
  var sp = locator<SPUtil>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<OpinionController>(context, listen: false).isExpanded = false;
    filteredCategoryList.clear();
    categoryListFull.clear();
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OpinionController>(context, listen: false)
        .getCategories(sp.getValue(SPUtil.PROGRAMKEY));

    return Consumer<OpinionController>(builder: (context, provider, snapshot) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              color: Colors.white,
              height: 86,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 12,
                    left: 10,
                    child: Container(
                      width: 40,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          ClickSound.buttonClickYes();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 70,
                          child: Image(
                            height: 35,
                            width: 35,
                            image: AssetImage("assets/images/v2_ic_back.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 11,right: 12,top: 80),
                      child: searchBarUI(provider, sp.getValue(SPUtil.PROGRAMKEY))),
                  Container(
                    margin: EdgeInsets.only(top: 136),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FutureBuilder<List<OpinionSearchList>>(
                        future: provider
                            .getCategories(sp.getValue(SPUtil.PROGRAMKEY)),
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
                              child: Center(child: LoadingBar.spinkit));
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

  Widget searchBarUI(OpinionController provider, String program) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FutureBuilder<List<OpinionSearchList>>(
          future: provider.getCategories(program),
          builder: (context, snapshot) {
            return FloatingSearchBar(
              hint: AppLocalizations.of(context)!.search,
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
          }),
    );
  }
}

Widget buildItem(OpinionController provider, OpinionSearchItem item, BuildContext context) {

  final dateTime = DateTime.parse(item.date);
  final format = DateFormat('dd MMMM, yyyy');
  final titleDate = format.format(dateTime);

  return Container(
      child: GestureDetector(
          onTap: () {
            ClickSound.buttonClickYes();
            _floatingSearchBarController.clear();
            _floatingSearchBarController.close();
            provider.opinionID = item.id;
            NavUtils.pushAndRemoveUntil(context, NavigationScreen(2));
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
                          fontSize: 16.0,
                          color: Colors.black,
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

  final OpinionSearchList popup;

  final OpinionController provider;

  Widget _buildTiles(OpinionSearchList root, BuildContext context) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));

    List<Widget> list = [];

    for (var item in root.children) {
      list.add(buildItem(provider,item, context));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 3),
          child: Theme(
              data:  ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: PageStorageKey<OpinionSearchList>(root),
                textColor: Colors.black,
                maintainState: true,

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
              ))
          ,
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