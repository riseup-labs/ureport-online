import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/remote-config-data.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'package:ureport_ecaro/widgets/custom-expantiontile.dart';
import 'model/parse-sugetiondata.dart';
import 'opiion-controller.dart';
import 'model/Response_opinions.dart' as quistoin;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpinionsScreen extends StatefulWidget {
  @override
  _OpinionsScreenState createState() => _OpinionsScreenState();
}

class _OpinionsScreenState extends State<OpinionsScreen> {
  TextEditingController controller = new TextEditingController();
  late AutoCompleteTextField search;
  GlobalKey<AutoCompleteTextFieldState<quistoin.Result>> key = new GlobalKey();
  String title_local = "";
  var spdata = locator<SPUtil>();
  int titleIndex=0;

  @override
  void initState() {
    Provider.of<OpinionController>(context, listen: false).quistionlist.clear();
    //Provider.of<OpinionController>(context, listen: false).forceEmptydata();
    //Provider.of<OpinionController>(context, listen: false).opinionList=[];
    Provider.of<OpinionController>(context, listen: false).getofflinedata(spdata.getValue(SPUtil.PROGRAMKEY));
    Provider.of<OpinionController>(context, listen: false).getOpinionFromServer("${RemoteConfigData.getOpinionUrl(spdata.getValue(SPUtil.PROGRAMKEY))}?limit=30",spdata.getValue(SPUtil.PROGRAMKEY));
    //print("THE BUILD METHOD IS CALLED INSIDE OPINION UI");


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print("the buil mehtod iscalled");

    AppBar appbarr = AppBar();
    return Consumer<OpinionController>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.options_background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Image(
                          fit: BoxFit.fill,
                          height: 30,
                          width: 150,
                          image: AssetImage('assets/images/ureport_logo.png')),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15, bottom: 10, left: 10),
                          child: Text(
                            "${AppLocalizations.of(context)!.opinions}",
                            style: TextStyle(fontSize: 24.0, color: Colors.black),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.only(left: 20),
                            width: 204,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  topRight: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                )),
                            child:  TypeAheadFormField<Sugetiondata?>(
                              suggestionsBoxVerticalOffset: 0.0,
                              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              ),
                              suggestionsCallback: provider.getSuggestions,
                              itemBuilder: (context, Sugetiondata? suggestions)  =>
                                        ListTileTheme(
                                          contentPadding: EdgeInsets.all(0),
                                          child: CustomExpansionTile(
                                            childrenPadding: EdgeInsets.all(0),
                                            tilePadding: EdgeInsets.symmetric(horizontal: 0.0),
                                            trailing: SizedBox.shrink(),
                                            leading: Icon(Icons.arrow_right_sharp),
                                            title: Text(
                                              "${suggestions!.category}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            children: [
                                             ListView.builder(
                                               padding: EdgeInsets.zero,
                                                 shrinkWrap: true,
                                                 physics: BouncingScrollPhysics(),
                                                 itemBuilder: (context,index){

                                                   return  Column(
                                                     children: [
                                                       Container(
                                                         margin: EdgeInsets.only(left: 25,right: 25,top: 0,bottom: 0),
                                                         padding: EdgeInsets.all(5),
                                                         child:  ListTile(
                                                           title: Text("${suggestions!.title[index]}",style: TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w500),),
                                                         ),),
                                                       SizedBox(height: 3,),
                                                       Divider(height: 1,color: Colors.grey,),
                                                     ],
                                                   );
                                                 },
                                               itemCount: suggestions!.title.length,
                                             ),
                                            ],
                                          ),
                                        ),

                              onSuggestionSelected:
                                  ( suggestion) {
                                provider.typeAheadController.text = suggestion!.category;
                                String data = provider.typeAheadController.text;
                                print("the sugestion data ${title_local}");

                              },
                              onSaved: (value)=>title_local=value!,

                              textFieldConfiguration: TextFieldConfiguration(
                                controller: provider.typeAheadController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(
                                      color: AppColors.textfield_hintcolor,
                                      fontSize: 12),
                                  hintText: "Search",
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xff000000),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ))


                      ],
                    ),
                    Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(
                        height: 1.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    //title container
                    provider.defaultTitle!="" ||  provider.defaultTitle.isNotEmpty?   Container(
                      child: Text(
                        "${provider.defaultTitle}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,),
                      ),
                    ):Container(),
                    SizedBox(height: 5,),
                  provider.categorydefault!=""?  Container(
                      padding: EdgeInsets.only(left:10,right: 10,top: 3,bottom: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text("${provider.categorydefault}",style:TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,)),
                    ):Container(),
                    SizedBox(
                      height: 10,
                    ),

                   // new addition
                   provider.quistionlist.length>0?  Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          //response part
                          Container(
                            padding:EdgeInsets.only(left:10,right:10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${provider.quistionlist[0].results.resultsSet}",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold,fontFamily: "Dosis"),),
                                    SizedBox(height:8),
                                    Text("Responses",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700,fontFamily: "Dosis"),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${
                                        ((provider.quistionlist[0].results.resultsSet)/(provider.quistionlist[0].results.resultsSet+provider.quistionlist[0].results.unset)*100).toStringAsFixed(0)
                                    }%",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold,fontFamily: "Dosis"),),
                                    SizedBox(height:8),
                                    Text("Responses Rate",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700,fontFamily: "Dosis"),),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height:
                          15,),

                          //male female part
                          Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Image.asset("assets/images/male.png",height: 36,width: 36,),
                                    SizedBox(height:5),
                                    Text("Male",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w700,fontFamily: "Dosis")),
                                  ],
                                ),

                                SizedBox(width:10,),
                                //male percentage
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${
                                    provider.getmalepercentage()
                                    }%",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold,fontFamily: "Dosis"),),
                                    SizedBox(height:17),

                                    Text("${provider.quistionlist[0].resultsByGender[0].resultsSet}",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w700,fontFamily: "Dosis"),),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Image.asset("assets/images/female.png",height: 35,width: 35,),
                                    SizedBox(height:5),
                                    Text("Female",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w700,fontFamily: "Dosis")),
                                  ],
                                ),
                                SizedBox(width: 5,),
                                //female percentage
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${provider.getfemalepercentage()}%",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold,fontFamily: "Dosis"),),
                                    SizedBox(height:19),

                                    Text("${provider.quistionlist[0].resultsByGender[1].resultsSet}",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w700,fontFamily: "Dosis"),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ):Container(),

                    SizedBox(height: 10,),
                    provider.quistionlist.length>0? Divider(color: Colors.grey,height: 1,):SizedBox(),


                    //test
                    provider.quistionlist.length>0
                        ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (provider.alllist == true) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 15),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)),
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.white54,
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(

                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 10, top: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${provider.quistionlist[index].title}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,fontWeight: FontWeight.w500),
                                                overflow: TextOverflow.fade,
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet + provider.quistionlist[index].results.unset}",
                                                style: TextStyle(
                                                    color: Color(0xff545454),
                                                    fontSize: 11,fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Container(
                                                  padding: EdgeInsets.only(right: 3),
                                                  width: 300,
                                                  height: 26.33,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(30)),

                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      provider.alllist ==
                                                              true
                                                          ? TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff535353),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(20)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = true;
                                                                provider.agelist=false;
                                                                provider.genderlist=false;
                                                                provider.locationlist=false;


                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "All",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,fontWeight:FontWeight.w500),
                                                              ),
                                                            )
                                                          : TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(20)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = true;
                                                                provider.agelist=false;
                                                                provider.genderlist=false;
                                                                provider.locationlist=false;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "All",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                      VerticalDivider(
                                                        width: 1,
                                                        color:
                                                            MyColors.gray7E(
                                                                context),
                                                      ),
                                                      provider.agelist ==
                                                              true
                                                          ? TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff535353),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              0),
                                                                      bottomLeft:
                                                                          Radius.circular(0)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = false;
                                                                provider.agelist=true;
                                                                provider.genderlist=false;
                                                                provider.locationlist=false;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "Age",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,fontWeight: FontWeight.w500),
                                                              ),
                                                            )
                                                          : TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(20)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = false;
                                                                provider.agelist=true;
                                                                provider.genderlist=false;
                                                                provider.locationlist=false;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "Age",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                      VerticalDivider(
                                                        width: 1,
                                                        color:
                                                            MyColors.gray7E(
                                                                context),
                                                      ),
                                                      provider.genderlist ==
                                                              true
                                                          ? TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff535353),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              0),
                                                                      bottomLeft:
                                                                          Radius.circular(0)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = false;
                                                                provider.agelist=false;
                                                                provider.genderlist=true;
                                                                provider.locationlist=false;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "Gender",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,fontWeight: FontWeight.w500),
                                                              ),
                                                            )
                                                          : TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft:
                                                                          Radius.circular(20)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = false;
                                                                provider.agelist=false;
                                                                provider.genderlist=true;
                                                                provider.locationlist=false;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "Gender",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                      VerticalDivider(
                                                        width: 1,
                                                        color:
                                                            MyColors.gray7E(
                                                                context),
                                                      ),
                                                      provider.locationlist ==
                                                              true
                                                          ? TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff535353),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(0),
                                                                      bottomRight: Radius.circular(0)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = false;
                                                                provider.agelist=false;
                                                                provider.genderlist=false;
                                                                provider.locationlist=true;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "Location",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,fontWeight: FontWeight.w500),
                                                              ),
                                                            )
                                                          : TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomRight:
                                                                          Radius.circular(20)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                provider.alllist = false;
                                                                provider.agelist=false;
                                                                provider.genderlist=false;
                                                                provider.locationlist=true;
                                                                print(
                                                                    "the button type is ${provider.resultCategorytype}");
                                                              },
                                                              child: Text(
                                                                "Location",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,fontWeight: FontWeight.w500),
                                                              ),
                                                            ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Divider(
                                          height: 1,
                                          color: MyColors.gray7E(context),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 280,
                                              margin: EdgeInsets.only(
                                                left: 15,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(20)),
                                              ),
                                              child: Stack(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 20,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8.0),
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: provider
                                                            .getFractionProgressOfYes(
                                                                index),
                                                        backgroundColor:
                                                            Colors
                                                                .transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Color(
                                                                    0xff009A17)),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                top: 2),
                                                        child: Text(
                                                          "${provider.quistionlist[index].results.categories.length>0?provider.quistionlist[index].results.categories[0].label:""}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,fontWeight: FontWeight.w500),
                                                        )),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${provider.getFractionOfYes(index).toStringAsFixed(2)}%",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 280,
                                              margin: EdgeInsets.only(
                                                left: 15,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(20)),
                                              ),
                                              child: Stack(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 20,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8.0),
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: provider
                                                            .getFractionProgressOfNo(
                                                                index),
                                                        backgroundColor:
                                                            Colors
                                                                .transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Color(
                                                                    0xff009A17)),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                top: 2),
                                                        child: Text(
                                                          "${provider.quistionlist[index].results.categories.length>0?provider.quistionlist[index].results.categories[1].label:""}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,fontWeight: FontWeight.w500),
                                                        )),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${provider.getFractionOfNo(index).toStringAsFixed(2)}%",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              );
                            }
                            else if (provider.genderlist ==
                                true) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 10, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${provider.quistionlist[index].title}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.fade,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet + provider.quistionlist[index].results.unset}",
                                          style: TextStyle(
                                              color: Color(0xff545454),
                                              fontSize: 11,fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 3),
                                            width: 300,
                                            height: 26.33,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(30)),

                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                provider.alllist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = true;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;


                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight:FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = true;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.agelist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              0),
                                                          bottomLeft:
                                                          Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=true;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Age",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=true;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Age",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.genderlist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              0),
                                                          bottomLeft:
                                                          Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=true;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=true;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.locationlist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(0),
                                                          bottomRight: Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=true;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight:
                                                          Radius.circular(
                                                              20),
                                                          bottomRight:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=true;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemBuilder: (context, j) {
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.white24,
                                              blurRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                    ),
                                                    child: Text(
                                                        "${provider.quistionlist[index].resultsByGender[j].label}",  style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ListView.builder(
                                                  itemBuilder: (context, k) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 280,
                                                              margin:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 15,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            20)),
                                                              ),
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    height:
                                                                        20,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(8.0),
                                                                      child:
                                                                          LinearProgressIndicator(
                                                                        value: provider.getFractionProgressForGender(
                                                                            index,
                                                                            j,
                                                                            k),
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(left: 5, top: 2),
                                                                        child: Text(
                                                                          "${provider.quistionlist[index].resultsByGender[j].categories[k].label}",
                                                                          style:
                                                                              TextStyle(color: Colors.black,fontWeight: FontWeight.w500,),
                                                                        )),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "${provider.getFractionOfYesForGender(index, j, k).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      15),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: provider
                                                      .quistionlist[index]
                                                      .resultsByGender[j]
                                                      .categories
                                                      .length,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: MyColors.gray7E(
                                                      context),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: provider.quistionlist[index]
                                        .resultsByGender.length,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }

                            if(provider.agelist==true){
                              return  Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 10, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${provider.quistionlist[index].title}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.fade,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet + provider.quistionlist[index].results.unset}",
                                          style: TextStyle(
                                              color: Color(0xff545454),
                                              fontSize: 11,fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 3),
                                            width: 300,
                                            height: 26.33,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(30)),

                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                provider.alllist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = true;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;


                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight:FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = true;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.agelist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              0),
                                                          bottomLeft:
                                                          Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=true;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Age",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=true;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Age",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.genderlist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              0),
                                                          bottomLeft:
                                                          Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=true;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=true;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.locationlist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(0),
                                                          bottomRight: Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=true;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight:
                                                          Radius.circular(
                                                              20),
                                                          bottomRight:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=true;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemBuilder: (context, j) {
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.white24,
                                              blurRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: MyColors.gray7E(
                                                      context),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                    ),
                                                    child: Text(
                                                        "${provider.quistionlist[index].resultsByAge[j].label}",  style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ListView.builder(
                                                  itemBuilder: (context, k) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 280,
                                                              margin:
                                                              EdgeInsets
                                                                  .only(
                                                                left: 15,
                                                              ),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20)),
                                                              ),
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    height:
                                                                    20,
                                                                    child:
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                      BorderRadius.circular(8.0),
                                                                      child:
                                                                      LinearProgressIndicator(
                                                                        value: provider.getFractionProgressForage(
                                                                            index,
                                                                            j,
                                                                            k),
                                                                        backgroundColor:
                                                                        Colors.transparent,
                                                                        valueColor:
                                                                        AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(left: 5, top: 2),
                                                                        child: Text(
                                                                          "${provider.quistionlist[index].resultsByAge[j].categories[k].label}",
                                                                          style:
                                                                          TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                                                        )),
                                                                    alignment:
                                                                    Alignment
                                                                        .centerLeft,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "${provider.getFractionOforAge(index, j, k).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  itemCount: provider
                                                      .quistionlist[index]
                                                      .resultsByAge[j]
                                                      .categories
                                                      .length,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: provider.quistionlist[index]
                                        .resultsByAge.length,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }

                            if(provider.locationlist==true){

                              return  Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 10, top: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${provider.quistionlist[index].title}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                          overflow: TextOverflow.fade,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet + provider.quistionlist[index].results.unset}",
                                          style: TextStyle(
                                              color: Color(0xff545454),
                                              fontSize: 11,fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.only(right: 3),
                                            width: 300,
                                            height: 26.33,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(30)),

                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                provider.alllist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = true;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;


                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight:FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = true;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.agelist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              0),
                                                          bottomLeft:
                                                          Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=true;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Age",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=true;
                                                    provider.genderlist=false;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Age",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.genderlist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              0),
                                                          bottomLeft:
                                                          Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=true;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(
                                                              20),
                                                          bottomLeft:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=true;
                                                    provider.locationlist=false;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Gender",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  width: 1,
                                                  color:
                                                  MyColors.gray7E(
                                                      context),
                                                ),
                                                provider.locationlist ==
                                                    true
                                                    ? TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Color(
                                                        0xff535353),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(0),
                                                          bottomRight: Radius.circular(0)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=true;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,fontWeight: FontWeight.w500),
                                                  ),
                                                )
                                                    : TextButton(
                                                  style: TextButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        0),
                                                    backgroundColor:
                                                    Colors
                                                        .white,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight:
                                                          Radius.circular(
                                                              20),
                                                          bottomRight:
                                                          Radius.circular(20)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider.alllist = false;
                                                    provider.agelist=false;
                                                    provider.genderlist=false;
                                                    provider.locationlist=true;
                                                    print(
                                                        "the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemBuilder: (context, j) {
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.white24,
                                              blurRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: MyColors.gray7E(
                                                      context),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                    ),
                                                    child: Text(
                                                        "${provider.quistionlist[index].resultsByLocation[j].label}",  style: TextStyle(
                                                        color: Colors
                                                            .black,fontWeight: FontWeight.w500),)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ListView.builder(
                                                  itemBuilder: (context, k) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 280,
                                                              margin:
                                                              EdgeInsets
                                                                  .only(
                                                                left: 15,
                                                              ),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        20)),
                                                              ),
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    height:
                                                                    20,
                                                                    child:
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                      BorderRadius.circular(8.0),
                                                                      child:
                                                                      LinearProgressIndicator(
                                                                        value: provider.getFractionProgressForLocation(
                                                                            index,
                                                                            j,
                                                                            k),
                                                                        backgroundColor:
                                                                        Colors.transparent,
                                                                        valueColor:
                                                                        AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(left: 5, top: 2),
                                                                        child: Text(
                                                                          "${provider.quistionlist[index].resultsByLocation[j].categories[k].label}",
                                                                          style:
                                                                          TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                                                                        )),
                                                                    alignment:
                                                                    Alignment
                                                                        .centerLeft,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "${provider.getFractionOforLocation(index, j, k).toStringAsFixed(2)}%",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  15),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  itemCount: provider
                                                      .quistionlist[index]
                                                      .resultsByLocation[j]
                                                      .categories
                                                      .length,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: provider.quistionlist[index]
                                        .resultsByLocation.length??0,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }

                            return Container();

                          },
                          itemCount: provider.quistionlist.length > 0
                              ? provider.quistionlist.length
                              : 0,
                        )
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget row(quistoin.Result item) {
    return ListTile(
      title: Text("${item.category.name}"),
    );
  }
}
