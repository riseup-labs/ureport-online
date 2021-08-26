

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/utils/resources.dart';
import 'opiion-controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'model/Response_opinions.dart' as quistoin;

class OpinionsScreen extends StatefulWidget{


  @override
  _OpinionsScreenState createState() => _OpinionsScreenState();
}

class _OpinionsScreenState extends State<OpinionsScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<OpinionController>(context,listen: false).getOpinions();

    print("the buil method is called ...............................");

    AppBar appbarr = AppBar();
    return Consumer<OpinionController>(
      builder: (context,provider,child){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.options_background,
            title: Text("Opinions",style: TextStyle(color:Colors.black),),
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(

                  height: appbarr.preferredSize.height,
                  color: AppColors.options_background,
                ),
                Image.asset("assets/images/bg_hader.png",),
              ],
            ),
          ),
          backgroundColor: AppColors.options_background,
          body: provider.islodading?Center(child: CircularProgressIndicator(),):Container(
            margin: EdgeInsets.only(left: 10,top: 20,right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/ureport_logo.png",width: 120,height: 35,),
                    Container(
                        padding: EdgeInsets.all(3),
                        width: 204,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(8.0),
                              bottomLeft: const Radius.circular(8.0),
                              bottomRight: const Radius.circular(8.0),
                            )
                        ),
                        child: TypeAheadFormField<String?>(
                          suggestionsCallback: provider.getSuggestions,
                          itemBuilder: (context,String? suggestions)=>Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text("$suggestions"),
                            ),
                          ),
                          onSuggestionSelected: (String?suggestion){
                            provider.typeAheadController.text=suggestion.toString();
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: provider.typeAheadController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: AppColors.textfield_hintcolor,fontSize: 12),
                              hintText: "Search",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search,color: Color(0xff000000),),
                              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined,color: Color(0xff000000),),
                            ),
                          ),
                        )

                    )
                  ],
                ),

                SizedBox(height: 20,),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      if(provider.resultCategorytype=="all"){

                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
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

                                    padding: EdgeInsets.only(left: 15,right: 10,top: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${provider.quistionlist[index].title}",
                                          style: TextStyle(color: Colors.black,fontSize: 16),overflow: TextOverflow.fade,),
                                        SizedBox(height: 2,),
                                        Text("${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet+provider.quistionlist[index].results.unset}",style: TextStyle(color: Color(0xff545454),fontSize: 11),),

                                        SizedBox(height: 10,),
                                        Center(
                                          child: Container(
                                            width: 300,
                                            height:26.33,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            child: Row(

                                              children: [
                                                provider.resultCategorytype=="all"? TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Color(0xff535353),
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="all";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("All",style: TextStyle(color: Colors.white),),):
                                                TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Colors.white,
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="all";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("All",style: TextStyle(color:Colors.black),),),
                                                VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                                provider.resultCategorytype=="age"? TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Color(0xff535353),
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="age";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("Age",style: TextStyle(color: Colors.white),),):
                                                TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Colors.white,
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="age";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("Age",style: TextStyle(color:Colors.black),),),
                                                VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                                provider.resultCategorytype=="gender"? TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Color(0xff535353),
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="gender";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("Gender",style: TextStyle(color: Colors.white),),):
                                                TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Colors.white,
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="gender";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("Gender",style: TextStyle(color: Colors.black),),),
                                                VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                                provider.resultCategorytype=="location"? TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Color(0xff535353),
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="location";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("Location",style: TextStyle(color: Colors.white),),):
                                                TextButton(
                                                  style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                                    backgroundColor: Colors.white,
                                                    shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),

                                                    ),
                                                  ),

                                                  onPressed: (){

                                                    provider.resultCategorytype="location";
                                                    print("the button type is ${provider.resultCategorytype}");
                                                  },
                                                  child: Text("Location",style: TextStyle(color: Colors.black),),),
                                                VerticalDivider(width: 1,color: MyColors.gray7E(context),),


                                              ],
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  Divider(
                                    height: 1,color: MyColors.gray7E(context),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),



                                  Row(
                                    children: [
                                      Container(
                                        width: 280,
                                        margin: EdgeInsets.only(left: 15,),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),

                                        child: Stack(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: LinearProgressIndicator(
                                                  value: provider.getFractionProgressOfYes(index),
                                                  backgroundColor: Colors.transparent,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                ),
                                              ),
                                            ),
                                            Align(child: Padding(
                                                padding: EdgeInsets.only(left: 5,top: 2),
                                                child: Text("${provider.quistionlist[index].results.categories[0].label}",style: TextStyle(color: Colors.black),)), alignment: Alignment.centerLeft,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${provider.getFractionOfYes(index).toStringAsFixed(2)}%",style: TextStyle(color: Colors.black,fontSize: 15),),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(
                                    children: [
                                      Container(
                                        width: 280,
                                        margin: EdgeInsets.only(left: 15,),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),

                                        child: Stack(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: LinearProgressIndicator(
                                                  value:provider.getFractionProgressOfNo(index),
                                                  backgroundColor: Colors.transparent,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                ),
                                              ),
                                            ),
                                            Align(child: Padding(
                                                padding: EdgeInsets.only(left: 5,top: 2),
                                                child: Text("${provider.quistionlist[index].results.categories[1].label}",style: TextStyle(color: Colors.black),)), alignment: Alignment.centerLeft,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("${provider.getFractionOfNo(index).toStringAsFixed(2)}%",style: TextStyle(color: Colors.black,fontSize: 15),),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(height: 15,)
                          ],
                        );
                      }

                      else if(provider.resultCategorytype=="gender"){
                        return Column(
                          children: [

                            Container(

                              padding: EdgeInsets.only(left: 15,right: 10,top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${provider.quistionlist[index].title}",
                                    style: TextStyle(color: Colors.black,fontSize: 16),overflow: TextOverflow.fade,),
                                  SizedBox(height: 2,),
                                  Text("${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet+provider.quistionlist[index].results.unset}",style: TextStyle(color: Color(0xff545454),fontSize: 11),),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 300,
                                      height:26.33,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Row(

                                        children: [
                                          provider.resultCategorytype=="all"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="all";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("All",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="all";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("All",style: TextStyle(color:Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                          provider.resultCategorytype=="age"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="age";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Age",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="age";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Age",style: TextStyle(color:Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                          provider.resultCategorytype=="gender"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="gender";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Gender",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="gender";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Gender",style: TextStyle(color: Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                          provider.resultCategorytype=="location"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="location";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Location",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="location";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Location",style: TextStyle(color: Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),


                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3,),



                                ],
                              ),
                            ),

                            ListView.builder(
                              itemBuilder:(context,j){

                                return Container(
                                  padding: EdgeInsets.only(bottom: 15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [


                                          Container(
                                              margin: EdgeInsets.only(left: 15,),
                                              child: Text("${provider.quistionlist[index].resultsByGender[j].label}")),
                                          SizedBox(height: 5,),

                                          ListView.builder(

                                            itemBuilder: (
                                                context,k){
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 280,
                                                        margin: EdgeInsets.only(left: 15,),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        ),

                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 20,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                                child: LinearProgressIndicator(
                                                                  value: provider.getFractionProgressForGender(index,j,k),
                                                                  backgroundColor: Colors.transparent,
                                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(child: Padding(
                                                                padding: EdgeInsets.only(left: 5,top: 2),
                                                                child: Text("${provider.quistionlist[index].resultsByGender[j].categories[k].label}",style: TextStyle(color: Colors.black),)), alignment: Alignment.centerLeft,),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("${provider.getFractionOfYesForGender(index,j,k).toStringAsFixed(2)}%",style: TextStyle(color: Colors.black,fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),


                                                ],
                                              );
                                            },
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: provider.quistionlist[index].resultsByGender[j].categories.length,
                                          ),

                                          SizedBox(height: 10,),
                                          Divider(
                                            height: 1,color: MyColors.gray7E(context),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: provider.quistionlist[index].resultsByGender.length,
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      }

                      else if(provider.resultCategorytype=="age"){
                        return Column(
                          children: [
                            Container(

                              padding: EdgeInsets.only(left: 15,right: 10,top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${provider.quistionlist[index].title}",
                                    style: TextStyle(color: Colors.black,fontSize: 16),overflow: TextOverflow.fade,),
                                  SizedBox(height: 2,),
                                  Text("${provider.quistionlist[index].results.resultsSet} responded out of ${provider.quistionlist[index].results.resultsSet+provider.quistionlist[index].results.unset}",style: TextStyle(color: Color(0xff545454),fontSize: 11),),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 300,
                                      height:26.33,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Row(

                                        children: [
                                          provider.resultCategorytype=="all"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="all";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("All",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="all";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("All",style: TextStyle(color:Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                          provider.resultCategorytype=="age"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="age";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Age",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="age";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Age",style: TextStyle(color:Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                          provider.resultCategorytype=="gender"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="gender";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Gender",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="gender";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Gender",style: TextStyle(color: Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),

                                          provider.resultCategorytype=="location"? TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Color(0xff535353),
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="location";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Location",style: TextStyle(color: Colors.white),),):
                                          TextButton(
                                            style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                              backgroundColor: Colors.white,
                                              shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),

                                              ),
                                            ),

                                            onPressed: (){

                                              provider.resultCategorytype="location";
                                              print("the button type is ${provider.resultCategorytype}");
                                            },
                                            child: Text("Location",style: TextStyle(color: Colors.black),),),
                                          VerticalDivider(width: 1,color: MyColors.gray7E(context),),


                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3,),



                                ],
                              ),
                            ),

                            ListView.builder(
                              itemBuilder:(context,j){

                                return Container(

                                  padding: EdgeInsets.only(bottom: 15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8,),
                                          Divider(
                                            height: 1,color: MyColors.gray7E(context),
                                          ),

                                          SizedBox(height: 10,),

                                          Container(
                                              margin: EdgeInsets.only(left: 15,),
                                              child: Text("${provider.quistionlist[index].resultsByAge[j].label}")),
                                          SizedBox(height: 5,),

                                          ListView.builder(

                                            itemBuilder: (
                                                context,k){
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 280,
                                                        margin: EdgeInsets.only(left: 15,),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        ),

                                                        child: Stack(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 20,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                                child: LinearProgressIndicator(
                                                                  value: provider.getFractionProgressForage(index,j,k),
                                                                  backgroundColor: Colors.transparent,
                                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff009A17)),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(child: Padding(
                                                                padding: EdgeInsets.only(left: 5,top: 2),
                                                                child: Text("${provider.quistionlist[index].resultsByAge[j].categories[k].label}",style: TextStyle(color: Colors.black),)), alignment: Alignment.centerLeft,),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text("${provider.getFractionOforAge(index,j,k).toStringAsFixed(2)}%",style: TextStyle(color: Colors.black,fontSize: 15),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                ],
                                              );
                                            },
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: provider.quistionlist[index].resultsByAge[j].categories.length,
                                          ),

                                          SizedBox(height: 10,),

                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: provider.quistionlist[index].resultsByAge.length,
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      }
                      return Container();
                    },
                    itemCount: provider.quistionlist.length>0? provider.quistionlist.length:0,),
                ),

              ],
            ),
          ),

        );
      },

    );
  }
}

