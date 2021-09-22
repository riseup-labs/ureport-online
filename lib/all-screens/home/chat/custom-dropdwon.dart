import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/all-screens/home/chat/chat-controller.dart';
import 'package:ureport_ecaro/network_operation/firebase/firebase_icoming_message_handling.dart';

import 'arrow_clipper.dart';

class CustomDropDownSecond extends StatefulWidget {
  final List<String> keyword;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final ValueChanged<int> onChange;

  const CustomDropDownSecond({
    Key? key,
    required this.keyword,
    required this.borderRadius,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.iconColor = Colors.black,
    required this.onChange,
  })  : assert(keyword != null),
        super(key: key);
  @override
  _CustomDropDownSecondState createState() => _CustomDropDownSecondState();
}

class _CustomDropDownSecondState extends State<CustomDropDownSecond>
    with SingleTickerProviderStateMixin {
  GlobalKey? _key;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  late OverlayEntry _overlayEntry;
  late BorderRadius _borderRadius;
  late AnimationController _animationController;


  List<String>listdata = ["join","data","quit"];
  String _chosenValue="join";
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  findButton() {
    /*final RenderObject? renderBox = _key!.currentContext!.findRenderObject();

  final  buttonSize = renderBox!.size;
   final buttonPosition = renderBox!.localToGlobal(Offset.zero);
*/
    final container = _key!.currentContext!.findRenderObject() as RenderBox;
    // buttonPosition = container.localToGlobal(Offset.zero);

    // buttonSize = container.size;
    buttonSize = container.size;
    buttonPosition = container.localToGlobal(Offset.zero);

  }


  void closeMenu() {
    _overlayEntry.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (isMenuOpen) {
          closeMenu();
        } else {
          openMenu();
        }
      },
      child: Container(
          padding: EdgeInsets.all(5),
          key: _key,
          decoration: BoxDecoration(
          ),
          child: Image.asset("assets/images/ic_chat_menu.png")

        /* IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
          color: Colors.black,
          onPressed: () {
            if (isMenuOpen) {
              closeMenu();
            } else {
              openMenu();
            }
          },
        ),*/
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy-20,
          right: 1,
          width:250,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0)
              ),

            ),


            child: Material(
              color: Colors.white,

              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   /* Row(
                      children: [
                        Text("Default Actions",style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold,fontSize: 18),),
                        Spacer(),
                        IconButton(onPressed: (){
                          closeMenu();
                        }, icon: Image.asset("assets/images/ic_close.png",width: 15,height: 15,),),

                      ],
                    ),*/

                    SizedBox(height: 5,),
                    Consumer<ChatController>(

                      builder: (_,provider,child){
                        return Center(
                          child: Container(

                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.red,

                                labelText: "Default Action",
                              ),


                              items: listdata.map((itemvalue) {

                                return DropdownMenuItem(
                                    value: itemvalue,
                                    child: SizedBox(
                                      width: 100,
                                      child: Text(itemvalue,textAlign: TextAlign.center,),
                                    ),);

                              }).toList(),
                              value: _chosenValue,
                              onChanged: (String? newvalue){
                               setState(() {
                                 _chosenValue=newvalue!;
                               });
                              },
                              dropdownColor: Colors.white,
                              isExpanded:true,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },

                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}