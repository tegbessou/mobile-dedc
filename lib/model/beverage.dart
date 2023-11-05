import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';

class Beverage {
  String iri;
  int id;
  String name;
  List<Participant> participants = [];
  List<BeverageRating> beverageRatings = [];

  Beverage({
    required this.iri,
    required this.id,
    required this.name,
    this.participants = const [],
    this.beverageRatings = const [],
  });

  factory Beverage.fromJson(Map<String, dynamic> json) {
    List<BeverageRating> beverageRatings = [];

    if (json['beverageRatings'] != null) {
      beverageRatings = json['beverageRatings'].map<BeverageRating>((json) => BeverageRating.fromJson(json)).toList();
    }

    return Beverage(
      iri: json['@id'],
      id: json['id'] as int,
      name: json['name'],
      participants: json['participants'].map<Participant>((json) => Participant.fromJson(json)).toList(),
      beverageRatings: beverageRatings,
    );
  }

  Map toMap() {
    List participantsToMap = [];
    List beverageRatingsToMap = [];

    participants.forEach((Participant participant) {
      participantsToMap.add(participant.iri);
    });

    beverageRatings.forEach((BeverageRating beverageRating) {
      beverageRatingsToMap.add(beverageRating.toMap());
    });

    return {
      "name": name,
      "participants": participantsToMap,
      "beverageRatings": beverageRatingsToMap,
    };
  }
}