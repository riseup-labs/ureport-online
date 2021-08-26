
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/locator/locator.dart';

import 'model/Response_opinions.dart';
import 'model/Response_opinions.dart' as quistoin;
import 'opinion-repository.dart';

class OpinionController extends ChangeNotifier {

  var _opinionrepository = locator<OpinionRepository>();
  List<String>category_names=[];

  String _resultCategorytype = "all";

  String get resultCategorytype => _resultCategorytype;

  set resultCategorytype(String value) {
    _resultCategorytype = value;
    notifyListeners();
  }


  bool _all=false;
  bool _age=false;
  bool _gender=false;
  bool _location=false;



  double fraction_value_yes = 0.0;
   TextEditingController _typeAheadController = TextEditingController();

  TextEditingController get typeAheadController => _typeAheadController;
  set typeAheadController(TextEditingController value) {
    _typeAheadController = value;
    notifyListeners();
  }

  List<quistoin.Question>quistionlist =[];
  List<quistoin.ResultCategory?> categorylist= [];
  List<String> filterList= [];
    ResponseOpinions?  responseData;
  getOpinions() async {
    var apiresponsedata = await _opinionrepository.getOpinions("30");
    if(apiresponsedata.httpCode==200){
      responseData=apiresponsedata.data;
      responseData!.results.forEach((element) {
        quistionlist.addAll(element.questions);
        categorylist.add(element.category);
      });

      getSearchSuggetion();
    }

        notifyListeners();
      }

      getSearchSuggetion(){
    categorylist.forEach((element) {
      category_names.add(element!.name);
      print("the formated value length is ----${element.name}");

    });


    for(int i = 0; i< category_names.length; i++){
      if(!filterList.contains(category_names[i])){
        filterList.add(category_names[i]);
        print(filterList[i]);
      }
    }
    print("the formated value length is ----${category_names.length}");


      }
  List<String>getSuggestions(String query)=>List.of(filterList).where((element) {
    final namesLower= element.toLowerCase();
    final queryLower= query.toLowerCase();
    return namesLower.contains(queryLower);
  }).toList();

      double getFractionOfYes(index){
    print("${quistionlist[index].results.categories[0].count/quistionlist[index].results.resultsSet}");
    print("the yes count${quistionlist[index].results.categories[0].count}");
    print("total response ${quistionlist[index].results.resultsSet}");
      double fraction = (quistionlist[index].results.categories[0].count)/(quistionlist[index].results.resultsSet)*100;
      return fraction;
    }


    double getFractionOfNo(index){
    print("${quistionlist[index].results.categories[1].count/quistionlist[index].results.resultsSet}");
    print("the yes count${quistionlist[index].results.categories[1].count}");
    print("total response ${quistionlist[index].results.resultsSet}");
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
        print("the total response is ${quistionlist[index].resultsByGender[j].resultsSet}");
        print("the total succes is  ${quistionlist[index].resultsByGender[j].categories[k].count}");
    double fraction = (quistionlist[index].resultsByGender[j].categories[k].count)/((quistionlist[index].resultsByGender[j].resultsSet))*100;
    print("the number of progress bar is$k .....result== ${fraction}");
    print("the number of label $k  .....name== ${quistionlist[index].resultsByGender[j].categories[k].label}");

        return fraction;

  }



  double getFractionProgressForGender(index,j,k){
    print("the total response is ${quistionlist[index].resultsByGender[j].resultsSet}");
    print("the total succes is  ${quistionlist[index].resultsByGender[j].categories[k].count}");
    double fraction = (quistionlist[index].resultsByGender[j].categories[k].count)/((quistionlist[index].resultsByGender[j].resultsSet));
    print("the number of progress bar is$k .....result== ${fraction}");
    print("the number of label $k  .....name== ${quistionlist[index].resultsByGender[j].categories[k].label}");

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