import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/all-screens/home/opinion/opinion_controller.dart';
import 'package:ureport_ecaro/firebase-remote-config/remote-config-controller.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
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
    Provider.of<RemoteConfigController>(context, listen: false).getInitialData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    dropdownValue = spset.getValue(SPUtil.PROGRAMKEY)==null?"Global":spset.getValue(SPUtil.PROGRAMKEY);

    return Consumer<RemoteConfigController>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_select_program.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  from == "more"
                      ? GestureDetector(
                          onTap: () {
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
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              getLogo(),
                              SizedBox(
                                height: 50,
                              )
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
                                    Text(
                                      "${AppLocalizations.of(context)!.choose_program}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                                                  spset.setValue(SPUtil.PROGRAMKEY, dropdownValue);
                                                });
                                              },
                                              items: [
                                                DropdownMenuItem(
                                                  value:
                                                      "Global",
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                        image: AssetImage(
                                                            "assets/images/logo_global.png"),
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                          "Global")
                                                    ],
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value:
                                                      "On The Move",
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                        image: AssetImage(
                                                            "assets/images/logo_move.png"),
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                          "On The Move")
                                                    ],
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value:
                                                      "Italia",
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                        image: AssetImage(
                                                            "assets/images/logo_italy.png"),
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                          "Italia")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 70),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  child: Container(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        spset.setValue(SPUtil.PROGRAMKEY, dropdownValue);
                                        Provider.of<OpinionController>(context, listen: false).opinionID = 0;
                                        Provider.of<OpinionController>(context, listen: false).notify();
                                        NavUtils.pushAndRemoveUntil(context, NavigationScreen(0));
                                      },
                                      child: Text('Continue'),
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder()),
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

  getLogo() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/map.png"),
        ));
  }
}
