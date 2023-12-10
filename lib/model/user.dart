class User {
  String? iri;
  int id;
  String username;

  User({
    required this.iri,
    required this.id,
    required this.username,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {
    return User(
      iri: json['@id'],
      id: json['id'],
      username: json['email'],
    );
  }
}
