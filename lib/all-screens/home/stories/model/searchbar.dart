class DataList {
  DataList(this.title, this.children);

  String title;
  List<StoryItem> children;
}

class StoryItem{
  StoryItem(this.id, this.title);
  String title;
  int id;
}
