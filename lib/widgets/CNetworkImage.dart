import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/utils/resources.dart';

class CNetworkImage extends StatelessWidget {
  String url;

  double height;


  Widget placeholderWidget;
  Widget errorWidget;
  BoxFit fit;


  CNetworkImage({
    required this.url,

    required this.height,

    required this.placeholderWidget,
    required this.errorWidget,
    this.fit = BoxFit.contain,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: MyColors.white_pure(context),
        shape: BoxShape.circle,
        border: Border.all(color: MyColors.lilacColorF7(context), width: 1)
      ) ,
      child: CachedNetworkImage(
        imageUrl: "$url",
        // placeholder: (_, __) => Container(
        //   height: height ?? size,
        //   width: width ?? size,
        //   child: placeholderWidget ?? placeholderAndErrorWidget,
        // ),
        errorWidget: (_, __, ___) => Container(
          height: height ,

          child: placeholderWidget
        ),

        height: height,

        fit: this.fit,
      ),
    );
  }
}
