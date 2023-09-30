class Restaurant {
  String iri;
  int id;
  String name;
  String city;
  int starNumber;

  Restaurant({
    required this.iri,
    required this.id,
    required this.name,
    required this.city,
    required this.starNumber,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      iri: json['@id'],
      id: json['id'] as int,
      name: json['name'],
      city: json['city'],
      starNumber: json['starNumber'] as int,
    );
  }
}