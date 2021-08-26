import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';

class ProgramChooser extends StatefulWidget {
  const ProgramChooser({Key? key}) : super(key: key);

  @override
  _ProgramChooserState createState() => _ProgramChooserState();
}

class _ProgramChooserState extends State<ProgramChooser> {
  var dropdownValue = "Global";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/drawable-xxhdpi/bg_select_program.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      getLogo(),
                      SizedBox(height: 50,)
                    ],
                  ),
                ),
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
                              "Select U-Report Program",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
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
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                          print(dropdownValue);
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem(value: "Global",
                                          child: Row(
                                            children: [
                                              Image(
                                                image: AssetImage("assets/images/drawable-xxhdpi/logo_global.png"),
                                                height: 30,
                                                width: 30,
                                              ),
                                              SizedBox(width: 10,),
                                              Text("Global")
                                            ],
                                          ),),
                                        DropdownMenuItem(value: "On The Move",
                                          child: Row(
                                            children: [
                                              Image(
                                              image: AssetImage("assets/images/drawable-xxhdpi/logo_move.png"),
                                              height: 30,
                                              width: 30,
                                            ),
                                              SizedBox(width: 10,),
                                              Text("On The Move")
                                            ],
                                          ),),
                                        DropdownMenuItem(value: "Italy",
                                          child: Row(
                                            children: [
                                              Image(
                                                image: AssetImage("assets/images/drawable-xxhdpi/logo_italy.png"),
                                                height: 30,
                                                width: 30,
                                              ),
                                              SizedBox(width: 10,),
                                              Text("Italy")
                                            ],
                                          ),),

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
                                NavUtils.push(context, NavigationScreen());
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
        ),
      ),
    );
  }

  getLogo() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage("assets/images/drawable-ldpi/map.png"),
        ));
  }
}
