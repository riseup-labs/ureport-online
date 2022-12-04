import 'package:flutter/material.dart';

class TopHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const TopHeaderWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              child: Image.asset(
                "assets/images/top_header_ro.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 30),
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'Heebo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
