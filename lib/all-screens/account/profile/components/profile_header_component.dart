import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/menu_view.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';

class ProfileHeaderComponent extends StatelessWidget {
  const ProfileHeaderComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                    child: Image.network(
                      "https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png",
                      width: 100,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "JOHN",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "DOE",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(68, 151, 223, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    NavUtils.push(context, MenuScreen());
                  },
                  child: Icon(
                    Icons.settings,
                    color: Color.fromRGBO(68, 151, 223, 1),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(68, 151, 223, 1),
              height: 2,
            )
          ],
        ),
      ),
    );
  }
}
