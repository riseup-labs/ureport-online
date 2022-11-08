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
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'opinion_controller.dart';
import 'opinion_screen.dart';
import 'opinion_screen_from_search.dart';

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

bool isExpanded = false;

class _OpinionSearchState extends State<OpinionSearch> {
  var sp = locator<SPUtil>();

  @override
  void initState() {
    super.initState();
    Provider.of<OpinionController>(context, listen: false).isExpanded = false;
    filteredCategoryList.clear();
    categoryListFull.clear();
    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OpinionController>(context, listen: false)
        .getCategories(sp.getValue(SPUtil.PROGRAMKEY)!);

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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ClickSound.soundClose();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        height: 70,
                        child: Image(
                          height: 55,
                          width: 55,
                          image: AssetImage("assets/images/v2_ic_back.png"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 11, right: 12, top: 80),
                      child: searchBarUI(
                          provider, sp.getValue(SPUtil.PROGRAMKEY)!)),
                  Container(
                    margin: EdgeInsets.only(top: 136),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: FutureBuilder<List<OpinionSearchList>>(
                        future: provider
                            .getCategories(sp.getValue(SPUtil.PROGRAMKEY)!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && isLoaded) {
                            filteredCategoryList = snapshot.data!;
                            categoryListFull.addAll(snapshot.data!);
                            isLoaded = false;
                          }
                          return filteredCategoryList.length != 0
                              ? Container(
                                  color: AppColors.white,
                                  child: ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            getItem(filteredCategoryList[index],
                                                provider),
                                    itemCount: filteredCategoryList.length,
                                  ),
                                )
                              : !provider.noResultFound
                                  ? Container(
                                      child: Center(child: LoadingBar.spinkit))
                                  : Column(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            height: 40,
                                            color: Colors.white,
                                            child: Center(
                                                child: Text(
                                              AppLocalizations.of(context)!
                                                  .no_result_found,
                                              style: TextStyle(fontSize: 15),
                                            ))),
                                      ],
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
                filteredCategoryList.clear();
                for (int i = 0; i < categoryListFull.length; i++) {
                  OpinionSearchList category =
                      OpinionSearchList(categoryListFull[i].title, []);
                  for (int j = 0;
                      j < categoryListFull[i].children.length;
                      j++) {
                    var titleObj = categoryListFull[i].children[j];
                    var title = categoryListFull[i].children[j].title;

                    if (title.toLowerCase().contains(value.toLowerCase())) {
                      titleObj.value = value;
                      category.children.add(titleObj);
                    }
                  }
                  if (category.children.length > 0) {
                    filteredCategoryList.add(category);
                    setState(() {});
                  }
                }

                if (value.isEmpty) {
                  isExpanded = false;
                } else {
                  isExpanded = true;
                }
                if (filteredCategoryList.isEmpty) {
                  provider.noResultFound = true;
                } else {
                  provider.noResultFound = false;
                }
                setState(() {});
              },
              automaticallyImplyDrawerHamburger: false,
              transitionCurve: Curves.easeInOut,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4)),
              transitionDuration: Duration(milliseconds: 100),
              transition: CircularFloatingSearchBarTransition(),
              debounceDelay: Duration(milliseconds: 100),
              actions: [
                isExpanded
                    ? GestureDetector(
                        onTap: () {
                          ClickSound.soundClose();
                          _floatingSearchBarController.clear();
                        },
                        child: Icon(Icons.clear))
                    : SizedBox()
              ],
              builder: (context, transition) {
                return Container();
              },
            );
          }),
    );
  }

  getItem(OpinionSearchList popup, OpinionController provider) {
    if (popup.children.isEmpty) return ListTile(title: Text(popup.title));

    List<Widget> list = [];

    for (var item in popup.children) {
      list.add(buildItem(provider, item, context));
    }

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 3),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: PageStorageKey<OpinionSearchList>(popup),
                textColor: Colors.black,
                collapsedTextColor: Colors.black,
                trailing: Icon(Icons.arrow_drop_down),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      popup.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                children: list,
                initiallyExpanded: isExpanded,
                onExpansionChanged: (value) {
                  ClickSound.soundDropdown();
                },
              ),
            )),
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

  Widget buildItem(OpinionController provider, OpinionSearchItem item,
      BuildContext context) {
    final dateTime = DateTime.parse(item.date);
    final format = DateFormat('dd MMMM, yyyy');
    final titleDate = format.format(dateTime);
    String latest_opinion_id =
        sp.getValue("${sp.getValue(SPUtil.PROGRAMKEY)}_latest_opinion")!;

    return Container(
        child: GestureDetector(
            onTap: () {
              ClickSound.soundClick();
              _floatingSearchBarController.clear();
              provider.opinionID = item.id;
              NavUtils.push(context, OpinionScreenFromSearch());
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 17, bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_right,
                    size: 20,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            children:
                                highlightOccurrences(item.title, item.value),
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(text: "  "),
                          TextSpan(
                              text: titleDate,
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                          item.id.toString() == latest_opinion_id
                              ? WidgetSpan(
                                  child: Container(
                                  padding: EdgeInsets.only(
                                      left: 6, right: 6, top: 3, bottom: 3),
                                  decoration: BoxDecoration(
                                      color: RemoteConfigData.getPrimaryColor(),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .latest_opinion,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ))
                              : TextSpan(text: "")
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            )));
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: RemoteConfigData.getTextColor(),
            backgroundColor: RemoteConfigData.getBackgroundColor(),
            fontSize: 15),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}
