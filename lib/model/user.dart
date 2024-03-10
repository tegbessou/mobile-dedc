class User {
  String? iri;
  int id;
  String username;
  String pseudo;
  String firstName;
  List<User> friends = [];

  User({
    required this.iri,
    required this.id,
    required this.username,
    required this.pseudo,
    required this.firstName,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {
    User user = User(
      iri: json['@id'],
      id: json['id'],
      username: json['email'],
      pseudo: json['pseudo'],
      firstName: json['firstName'],
    );

    if (json['friends'] != null) {
      json['friends'].forEach((dynamic element) {
        if (element is String) {
          return;
        }

        user.friends.add(User.fromJson(element));
      });
    }

    return user;
  }
}
