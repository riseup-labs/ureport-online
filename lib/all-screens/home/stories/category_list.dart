import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/stories/model/searchbar.dart';
import 'package:ureport_ecaro/all-screens/home/stories/stories-details.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story_list.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story_search.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/loading_bar.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/snackbar.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:ureport_ecaro/utils/top_bar_background.dart';
import 'model/ResponseStoryLocal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryListScreen extends StatefulWidget {
  //This screen is only for Romania region

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with AutomaticKeepAliveClientMixin {
  var sp = locator<SPUtil>();

  @override
  void initState() {
    super.initState();
    Provider.of<StoryController>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    var _future = Provider.of<StoryController>(context, listen: false)
        .getCategories(sp.getValue(SPUtil.PROGRAMKEY)!);

    return Consumer<StoryController>(builder: (context, provider, snapshot) {
      return Scaffold(
          body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar.getTopBar(AppLocalizations.of(context)!.stories),
            Container(
              child: Divider(
                height: 1,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            provider.isSyncing
                ? Container(
                    height: 5,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: LinearProgressIndicator(
                      color: RemoteConfigData.getPrimaryColor(),
                      backgroundColor: Colors.grey[300],
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  ClickSound.soundTap();
                  NavUtils.push(context, StorySearch());
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.search,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                            size: 38,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<StorySearchList>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && isLoaded) {
                      categoryList = snapshot.data!;
                      categoryListFull.addAll(snapshot.data!);
                      isLoaded = false;
                    }
                    return categoryList.length != 0
                        ? Container(
                            color: AppColors.white,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) =>
                                  getItem(categoryList[index], provider),
                              itemCount: categoryList.length,
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
                                        "No result found",
                                        style: TextStyle(fontSize: 15),
                                      ))),
                                ],
                              );
                  }),
            )
          ],
        ),
      ));
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<dynamic> getDataFromApi(
      BuildContext context, StoryController provider) async {
    if (provider.isOnline) {
      Provider.of<StoryController>(context, listen: false).setSyncing();
      return Provider.of<StoryController>(context, listen: false)
          .getRecentStory(
              RemoteConfigData.getStoryUrl(sp.getValue(SPUtil.PROGRAMKEY)),
              sp.getValue(SPUtil.PROGRAMKEY)!);
    } else {
      return ShowSnackBar.showNoInternetMessage(context);
    }
  }

  getItem(StorySearchList list, StoryController provider) {
    if (list.children.isEmpty) return ListTile(title: Text(list.title));

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 3),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  getItemTitleImage(list.children[0].image),
                  Text(
                    list.title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  getItemTitleImage(String? image_url) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: image_url != null
          ? CachedNetworkImage(
              height: 200,
              fit: BoxFit.cover,
              imageUrl: image_url,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      child: LoadingBar.spinkit,
                    ),
                  ),
                ],
              ),
              errorWidget: (context, url, error) => Container(
                  color: AppColors.errorWidgetBack,
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: LoadingBar.spinkit,
                    ),
                  )),
            )
          : Container(
              child: Image(
                image: AssetImage("assets/images/default.jpg"),
                fit: BoxFit.fill,
              ),
            ),
    );
  }

  getItemFeatured(String featured, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 15, bottom: 5, right: 10),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RemoteConfigData.getBackgroundColor()),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            featured == "true"
                ? AppLocalizations.of(context)!.featured_story
                : "STORY",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        )
      ],
    );
  }

  getItemTitle(String title) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  getItemSummery(String summery, BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: summery,
                  style: new TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300)),
              TextSpan(
                  text: summery.length != 0
                      ? " ${AppLocalizations.of(context)!.read_more}"
                      : "${AppLocalizations.of(context)!.read_more}",
                  style: new TextStyle(
                      fontSize: 14,
                      color: RemoteConfigData.getPrimaryColor(),
                      fontWeight: FontWeight.w300)),
            ],
          ),
        ));
  }
}
