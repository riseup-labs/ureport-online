import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_controller.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/click_sound.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
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

  var dropdownValue = "";

  @override
  void initState() {
    Provider.of<RemoteConfigController>(context, listen: false)
        .getInitialData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue = spset.getValue(SPUtil.PROGRAMKEY) == null
        ? "Global"
        : spset.getValue(SPUtil.PROGRAMKEY);

    return Consumer<RemoteConfigController>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              child: Stack(
                children: [
                  from == "more"
                      ? GestureDetector(
                          onTap: () {
                            ClickSound.buttonClickYes();
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15, top: 20),
                            width: 50,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 45),
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
                                  image: AssetImage("assets/images/v2_map.png"),
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
                                              value: dropdownValue,
                                              iconSize: 24,
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                  spset.setValue(
                                                      SPUtil.PROGRAMKEY,
                                                      dropdownValue);
                                                });
                                              },
                                              items: RemoteConfigData
                                                  .getProgramListForProgramChooser(),
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
                                            ClickSound.settingsChanged();
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
                                            NavUtils.pushAndRemoveUntil(
                                                context, NavigationScreen(0));
                                          },
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.continu,
                                              style: TextStyle(
                                                  fontSize: 20,
                                              ),
                                            ),
                                          )
                                      ),
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
