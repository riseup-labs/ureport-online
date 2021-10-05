import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';

import 'nav_utils.dart';

class TopBar {
  static Widget getTopBar(String title) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(top: 4),
                child: CachedNetworkImage(
                  imageUrl: RemoteConfigData.getLargeIcon(),
                  height: 30,
                  width: 150,
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: CustomPaint(
                painter: CustomBackground(),
                child: Container(
                  height: 80,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 26.0,
                            color: RemoteConfigData.getTextColor(),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getChatTopBar(String title,BuildContext context,String from) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.only(top: 4),
                child: CachedNetworkImage(
                  imageUrl: RemoteConfigData.getLargeIcon(),
                  height: 30,
                  width: 150,
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: CustomPaint(
                painter: CustomBackground(),
                child: Container(
                  height: 80,
                  child: Container(
                    padding: EdgeInsets.only(right: 30),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 26.0,
                                color: RemoteConfigData.getTextColor(),
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 30,
                            ),
                            onPressed: () {
                              //Detect where this page called
                              if(from == "Home"){
                                Navigator.pop(context);
                              }else{
                                NavUtils.pushAndRemoveUntil(context, NavigationScreen(0));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        RemoteConfigData.getBackgroundColor(),
        RemoteConfigData.getBackgroundColor()
      ],
      tileMode: TileMode.clamp,
    );

    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = new Paint()
      ..shader = gradient.createShader(colorBounds);

    Path path = Path();
    path.moveTo(size.width / 5, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 5, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
