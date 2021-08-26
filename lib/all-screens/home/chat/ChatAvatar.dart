import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String image;

  ChatAvatar(this.image);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 30,
            width: 30,
            child: Image.asset(image,height: 30,width: 30,),
          ),
          /*Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff41B6E6),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
