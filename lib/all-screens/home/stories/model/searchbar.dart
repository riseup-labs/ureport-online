class StorySearchList {
  StorySearchList(
    this.title,
    this.img,
    this.children,
  );
  String title;
  String img;
  List<StorySearchItem> children;
}

class StorySearchItem {
  StorySearchItem(this.id, this.title, this.image, this.date,
      {this.value = ""});
  String date;
  String image;
  String title;
  int id;
  String value;
}

class OpinionSearchList {
  String title;
  List<OpinionSearchItem> children;

  OpinionSearchList(this.title, this.children);
}

class OpinionSearchItem {
  String title;
  String date;
  int id;
  String value;
  OpinionSearchItem(this.id, this.title, this.date, {this.value = ""});
}
