import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';

class ChatAvatar extends StatelessWidget {
  final String image;
  final bool user;

  ChatAvatar(this.image, this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 30,
            width: 30,
            child: user?Image.asset(image,height: 25,width: 25) :
            Image.asset(image,height: 25,width: 25,color: RemoteConfigData.getBackgroundColor()),
          ),
        ],
      ),
    );
  }
}
