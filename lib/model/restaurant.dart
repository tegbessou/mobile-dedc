class Restaurant {
  String iri;
  int id;
  String name;
  String? city;
  int? starNumber;

  Restaurant({
    required this.iri,
    required this.id,
    required this.name,
    this.city,
    this.starNumber,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final Restaurant restaurant = Restaurant(
      iri: json['@id'],
      id: json['id'] as int,
      name: json['name'],
    );

    if (json.containsKey('city')) {
      restaurant.city = json["city"];
    }

    if (json.containsKey('starNumber')) {
      restaurant.starNumber = json["starNumber"];
    }

    return restaurant;
  }
}
