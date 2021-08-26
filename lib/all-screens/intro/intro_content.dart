import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.text2,
    required this.image,
  }) : super(key: key);
  final String text, text2, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.fill,
                  height: getProportionateScreenHeight(380),
                  width: getProportionateScreenWidth(320),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(30),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}