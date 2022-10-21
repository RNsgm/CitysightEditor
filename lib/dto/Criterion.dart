class Criterion{
  Criterion({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.serviceName,
    required this.typeArticle,
    required this.typeEvent,
    required this.typeOrganization,
    required this.typeRoute,
    required this.active,
  });

  int id;
  String nameRu;
  String nameEn;
  String serviceName;
  bool typeArticle;
  bool typeEvent;
  bool typeOrganization;
  bool typeRoute;
  bool active;

  factory Criterion.fromJson(Map<String, dynamic> json){
    return Criterion(
      id: json['id'],
      nameRu: json['name_ru'],
      nameEn: json['name_en'],
      serviceName: json['service_name'],
      typeArticle: json['type_article'],
      typeEvent: json['type_event'],
      typeOrganization: json['type_organization'],
      typeRoute: json['type_route'],
      active: json['active'],
    );
  }
}