class DataList {
  DataList(this.title, this.children);

  String title;
  List<StoryItem> children;
}

class StoryItem{
  StoryItem(this.id, this.title, this.image, this.date);
  String date;
  String image;
  String title;
  int id;
}
