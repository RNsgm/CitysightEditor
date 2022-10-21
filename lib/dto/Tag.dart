class Tag{
  Tag({
  required this.id,
  required this.name_ru,
  required this.name_en,
  });

  int id;
  String name_ru;
  String name_en;
  

  factory Tag.fromJson(Map<String, dynamic> json){
    return Tag(
      id: json['id'],
      name_ru: json['name_ru'],
      name_en: json['name_en']
    );
  }
}