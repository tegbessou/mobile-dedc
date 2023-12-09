import 'package:degust_et_des_couleurs/model/beverage_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';

class Beverage {
  String iri;
  int id;
  String name;
  String? contentUrl;
  List<Participant> participants = [];
  List<BeverageRating> beverageRatings = [];

  Beverage({
    required this.iri,
    required this.id,
    required this.name,
    this.contentUrl,
    this.participants = const [],
    this.beverageRatings = const [],
  });

  factory Beverage.fromJson(Map<String, dynamic> json) {
    List<BeverageRating> beverageRatings = [];

    if (json['beverageRatings'] != null) {
      beverageRatings = json['beverageRatings'].map<BeverageRating>((json) => BeverageRating.fromJson(json)).toList();
    }

    final Beverage beverage = Beverage(
      iri: json['@id'],
      id: json['id'] as int,
      name: json['name'],
      participants: json['participants'].map<Participant>((json) => Participant.fromJson(json)).toList(),
      beverageRatings: beverageRatings,
    );

    if (json['contentUrl'] != null) {
      beverage.contentUrl = json['contentUrl'];
    }

    return beverage;
  }

  Map toMap() {
    List participantsToMap = [];
    List beverageRatingsToMap = [];

    for (var participant in participants) {
      participantsToMap.add(participant.iri);
    }

    for (var beverageRating in beverageRatings) {
      beverageRatingsToMap.add(beverageRating.toMap());
    }

    return {
      "name": name,
      "participants": participantsToMap,
      "beverageRatings": beverageRatingsToMap,
    };
  }
}