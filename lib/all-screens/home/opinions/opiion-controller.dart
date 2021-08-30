
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';

import 'model/Response_opinions.dart';
import 'model/Response_opinions.dart' as quistoin;
import 'opinion-repository.dart';

class OpinionController extends ChangeNotifier {

  var _opinionrepository = locator<OpinionRepository>();
  var spservice =locator<SPUtil>();
  List<String>category_names=[];

  String _resultCategorytype = "all";

  String get resultCategorytype => _resultCategorytype;

  set resultCategorytype(String value) {
    _resultCategorytype = value;
    notifyListeners();
  }

  bool _islodading=true;


  bool get islodading => _islodading;

  set islodading(bool value) {
    _islodading = value;
    notifyListeners();
  }


  Map<String, dynamic> newMap = {};


  double fraction_value_yes = 0.0;
   TextEditingController _typeAheadController = TextEditingController();

  TextEditingController get typeAheadController => _typeAheadController;
  set typeAheadController(TextEditingController value) {
    _typeAheadController = value;
    notifyListeners();
  }

  List<quistoin.Question>quistionlist =[];
  List<quistoin.ResultCategory?> categorylist= [];
  List<quistoin.Result?> sugetionsdata= [];
  List<quistoin.Result?> sugetionsfilterdata= [];
  List<String> filterList= [];
    ResponseOpinions?  responseData;

    List<String> titlecollection=[];

     String title="";

  var data2 = {};
  var data1 = {};


  getOpinions() async {

    var offlinedata = await spservice.getValue(SPUtil.OPINIONDATA);
    print("The offline data---------------------------------------------------------------${offlinedata}");
    if(offlinedata==null){

      var apiresponsedata = await _opinionrepository.getOpinions("1");


      if(apiresponsedata.httpCode==200){

        responseData=apiresponsedata.data;

        String totalcount= apiresponsedata.data.count.toString();
      var apiresponsedatafull=await _opinionrepository.getOpinions(totalcount);
      if(apiresponsedatafull.httpCode==200){
        print("--------------------total count$totalcount");
        print("--------------------data length after whole data clll ${responseData!.results.length}");
        responseData=apiresponsedatafull.data;
        responseData!.results.forEach((element) {
          quistionlist.addAll(element.questions);
          categorylist.add(element.category);
        });
        getSearchSuggetion();
        notifyListeners();
      }

        responseData!.results.forEach((element) {
          quistionlist.addAll(element.questions);
          categorylist.add(element.category);
        });
        getSearchSuggetion();

      }

    }else{

      var apiresponsedata = await _opinionrepository.getOpinionsoffline();

      if(apiresponsedata.httpCode==200){
        responseData=apiresponsedata.data;

        responseData!.results.forEach((element) {
          quistionlist.addAll(element.questions);
          categorylist.add(element.category);
        });
        getSearchSuggetion();
        notifyListeners();
        //await _opinionrepository.getOpinions(responseData!.count.toString());

      }
    }
        notifyListeners();
      }
      getSearchSuggetion(){
        sugetionsdata.addAll(responseData!.results);
        sugetionsdata.forEach((element) {
          title=element!.title;
        });


        List<String> newlist = [];


       /* for(final i in sugetionsdata){
          if(!newlist.contains(i!.category.name)){
            newlist.add(i.category.name);
          }

        }*/

        for(int i =0;i<newlist.length;i++){
            titlecollection.clear();
          for(int j=0;j<sugetionsdata.length;j++){

            if(newlist[i]==sugetionsdata[j]!.category.name){
              titlecollection.add(sugetionsdata[j]!.title);

            }

          }


         // print("Category == ${newlist[i]} and title == ${titlecollection}\n\n\n");

         // filterList.addAll(titlecollection);
          //print("title list is -------------$titlecollection");
         filterList.addAll(titlecollection);

          //print("Whole map is -----------------$data1");
          
         /* if(newMap.isNotEmpty){
            
           // newMap.addAll({"${newlist[i]}":titlecollection});
            print("Whole map is -----------------$newMap");

          }else{
            newMap = Map.fromIterable(titlecollection);
            print("Whole map is -----------------$newMap");
          }*/



        }




        newMap.isNotEmpty?print("Whole map is -----------------$newMap"):print("Whole map is empty -----------------$newMap");







     /*  for(int i = 0;i<newlist.length;i++){
         print("the uniq catagory is ========================${newlist[i]}");
       }
*/

      /*  sugetionsdata.forEach((object) {
          sugetionsfilterdata = sugetionsdata.where((element) => element!.category.name==object!.category.name).toList();
        });


        sugetionsfilterdata.forEach((element) {

          print("chek plz-------------------------------${element!.title} and the category  ${element.category.name}");

        });
*/
        //titlecollection = sugetionsdata.where((element) => element.category.name)



      }

 /* List <String>getSuggestions(String query)=>filterList.where((element) {
    final userlower=element.toLowerCase();
    final querydata=query.toLowerCase();
    return userlower.contains(querydata);
  }).toList();
*/
   List <quistoin.Result?>getSuggestions(String query)=>sugetionsdata.where((element) {
     final userlower=element!.category.name.toLowerCase();
     final querydata=query.toLowerCase();
     return userlower.contains(querydata);
   }).toList();

      double getFractionOfYes(index){
    print("${quistionlist[index].results.categories[0].count/quistionlist[index].results.resultsSet}");

      double fraction = (quistionlist[index].results.categories[0].count)/(quistionlist[index].results.resultsSet)*100;
      return fraction;
    }


    double getFractionOfNo(index){
    print("${quistionlist[index].results.categories[1].count/quistionlist[index].results.resultsSet}");

    double fraction = (quistionlist[index].results.categories[1].count)/(quistionlist[index].results.resultsSet)*100;
    return fraction;
  }


  double getFractionProgressOfYes(index){

    double fraction = (quistionlist[index].results.categories[0].count)/(quistionlist[index].results.resultsSet);
    return fraction;
  }

  double getFractionProgressOfNo(index){

    double fraction = (quistionlist[index].results.categories[1].count)/(quistionlist[index].results.resultsSet);
    return fraction;
  }

  selectionHandling(String state){

    if(state== "all"){
      resultCategorytype="all";
    }else if(state == "age"){
      resultCategorytype="age";
    }else if(state=="gender"){
      resultCategorytype="gender";
    }else if(state =="location"){

    }

    notifyListeners();
  }
  double getFractionOfYesForGender(index,j,k){

    double fraction = (quistionlist[index].resultsByGender[j].categories[k].count)/((quistionlist[index].resultsByGender[j].resultsSet))*100;

        return fraction;
  }



  double getFractionProgressForGender(index,j,k){

    double fraction = (quistionlist[index].resultsByGender[j].categories[k].count)/((quistionlist[index].resultsByGender[j].resultsSet));
    return fraction;

  }



  double getFractionProgressForage(index,j,k){

        if((quistionlist[index].resultsByAge[j].resultsSet)!=0){
          double fraction = (quistionlist[index].resultsByAge[j].categories[k].count)/((quistionlist[index].resultsByAge[j].resultsSet));
          return fraction;
        }else return 0.0;


  }

  double getFractionOforAge(index,j,k){

        if((quistionlist[index].resultsByAge[j].resultsSet)!=0){
          double fraction = (quistionlist[index].resultsByAge[j].categories[k].count)/((quistionlist[index].resultsByAge[j].resultsSet))*100;
          return fraction;
        }else return 0.00;


  }





/* double getFractionOfNo(index){
    print("${quistionlist[index].results.categories[1].count/quistionlist[index].results.resultsSet}");
    print("the yes count${quistionlist[index].results.categories[1].count}");
    print("total response ${quistionlist[index].results.resultsSet}");
    double fraction = (quistionlist[index].results.categories[1].count)/(quistionlist[index].results.resultsSet)*100;
    return fraction;
  }*/




  /*TextField(
  textAlignVertical: TextAlignVertical.center,

  decoration: InputDecoration(
  hintStyle: TextStyle(color: AppColors.textfield_hintcolor,fontSize: 12),
  hintText: "Search",
  border: InputBorder.none,
  prefixIcon: Icon(Icons.search,color: Color(0xff000000),),
  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined,color: Color(0xff000000),),

  ),
  ),*/

}