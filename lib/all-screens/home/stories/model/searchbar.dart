class StorySearchList {
  StorySearchList(this.title, this.children);

  String title;
  List<StorySearchItem> children;
}

class StorySearchItem{
  StorySearchItem(this.id, this.title, this.image, this.date);
  String date;
  String image;
  String title;
  int id;
}

class OpinionSearchList{
  String title;
  List<OpinionSearchItem> children;

  OpinionSearchList(this.title, this.children);
}

class OpinionSearchItem{

  String title;
  String date;

  OpinionSearchItem(this.title, this.date);

}
