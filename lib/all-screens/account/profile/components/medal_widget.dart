import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/profile/model/medal.dart';

class MedalWidget extends StatelessWidget {
  const MedalWidget({Key? key, required this.medal}) : super(key: key);
  final Medal medal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    offset: Offset(-8, 8),
                    spreadRadius: -3,
                    blurRadius: 4,
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  )
                ]),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.network(medal.image),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      medal.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      medal.description,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "SHARE",
                        style: TextStyle(
                          color: Color.fromRGBO(68, 151, 223, 1),
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(68, 151, 223, 1),
            height: 2,
          )
        ],
      ),
    );
  }
}
