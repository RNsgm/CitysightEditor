enum ContentType{
  NONE,
  ARTICLE,
  ROUTE,
  EVENT,
  PLACE,
  ORGANIZATION
}

class ContentTypeName{
  ContentTypeName(this.type, this.name);

  ContentType type;
  String name;

  factory ContentTypeName.thisName(ContentType type){
    String name = {
      ContentType.NONE: "Не выбрано",
      ContentType.ARTICLE: "Статья",
      ContentType.ROUTE: "Маршрут",
      ContentType.EVENT: "Событие",
      ContentType.PLACE: "Место",
      ContentType.ORGANIZATION: "Организация",
    }[type]!;
    return ContentTypeName(type, name);
  }
}