
class NodoCollection {
  final List<NodoPOJO> list;

  NodoCollection(this.list);

  factory NodoCollection.fromJson(List<dynamic> json) =>
      NodoCollection(json.map((e) => NodoPOJO.fromJson(e)).toList());
}


class NodoPOJO {
  final String extremo1;
  final String extremo2;
  final String linea;

  NodoPOJO(this.extremo1, this.extremo2, this.linea);

  factory NodoPOJO.fromJson(List<dynamic> json) =>
      NodoPOJO(json[0], json[1], json[2]);
}
