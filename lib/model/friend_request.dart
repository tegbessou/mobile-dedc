import 'package:degust_et_des_couleurs/model/user.dart';

class FriendRequest {
  String iri;
  int id;
  User source;
  User target;

  FriendRequest(
      {required this.iri,
      required this.id,
      required this.source,
      required this.target});

  factory FriendRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return FriendRequest(
      iri: json['@id'],
      id: json['id'],
      source: User.fromJson(json['source']),
      target: User.fromJson(json['target']),
    );
  }
}
