import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_controller.dart';
import 'package:ureport_ecaro/all-screens/home/stories/story-controller.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/network_operation/utils/connectivity_controller.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/snackbar.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProgramChooser extends StatefulWidget {
  String from;

  ProgramChooser(this.from);

  @override
  _ProgramChooserState createState() => _ProgramChooserState(from);
}

class _ProgramChooserState extends State<ProgramChooser> {
  String from;

  var spset = locator<SPUtil>();

  _ProgramChooserState(this.from);

  var dropdownValue = "Global";

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Provider.of<ConnectivityController>(context, listen: false)
          .startMonitoring();
      await Provider.of<RemoteConfigController>(context, listen: false)
          .getInitialData(context);
      dropdownValue = spset.getValue(SPUtil.PROGRAMKEY).isEmpty
          ? "Global"
          : spset.getValue(SPUtil.PROGRAMKEY);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RemoteConfigController>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 0.0,
          ),
          body: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  from == "more"
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            ClickSound.soundClose();
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(left: 20),
                            height: 80,
                            child: Image(
                              height: 60,
                              width: 60,
                              image: AssetImage(
                                "assets/images/v2_ic_back.png",
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/images/v2_map.png"),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        //kaj koren
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.choose_program}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1.0,
                                              style: BorderStyle.solid,
                                              color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: dropdownValue.isNotEmpty
                                                  ? dropdownValue
                                                  : null,
                                              iconSize: 24,
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              onChanged: (String? newValue) {
                                                ClickSound.soundClick();
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                              items: RemoteConfigData
                                                  .getProgramListForProgramChooser(),
                                              onTap: () {
                                                ClickSound.soundDropdown();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  child: Container(
                                    child: Container(
                                      child: GestureDetector(
                                          onTap: () {
                                            if (Provider.of<
                                                        ConnectivityController>(
                                                    context,
                                                    listen: false)
                                                .isOnline) {
                                              ClickSound.soundClick();
                                              spset.setValue(SPUtil.PROGRAMKEY,
                                                  dropdownValue);
                                              Provider.of<OpinionController>(
                                                      context,
                                                      listen: false)
                                                  .opinionID = 0;
                                              Provider.of<OpinionController>(
                                                      context,
                                                      listen: false)
                                                  .notify();
                                              Provider.of<StoryController>(
                                                      context,
                                                      listen: false)
                                                  .isLoaded = true;
                                              Provider.of<OpinionController>(
                                                      context,
                                                      listen: false)
                                                  .isLoaded = true;
                                              Provider.of<OpinionController>(
                                                      context,
                                                      listen: false)
                                                  .items = [];
                                              Provider.of<ChatController>(
                                                      context,
                                                      listen: false)
                                                  .loadDefaultMessage();
                                              if (from == "more") {
                                                // locator<SPUtil>().setValue("${locator<SPUtil>().getValue(SPUtil.PROGRAMKEY)}_${SPUtil.REG_CALLED}", "false");
                                                Provider.of<ChatController>(
                                                        context,
                                                        listen: false)
                                                    .createContact();
                                              }
                                              NavUtils.pushAndRemoveUntil(
                                                  context, NavigationScreen(0));
                                            } else {
                                              ShowSnackBar
                                                  .showNoInternetMessage(
                                                      context);
                                            }
                                          },
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .continu,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
