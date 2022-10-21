class ImageMeta{
  ImageMeta({required this.id, required this.name});

  String id;
  String name;

  factory ImageMeta.fromJson(Map<String, dynamic> json){
    return ImageMeta(
      id: json['id'], 
      name: json['name']
    );
  }
}