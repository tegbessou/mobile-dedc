import 'package:degust_et_des_couleurs/model/dish_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';

class Dish {
  String iri;
  int id;
  String name;
  List<Participant> participants = [];
  List<DishRating> dishRatings = [];

  Dish({
    required this.iri,
    required this.id,
    required this.name,
    this.participants = const [],
    this.dishRatings = const [],
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    List<DishRating> dishRatings = [];

    if (json['dishRatings'] != null) {
      dishRatings = json['dishRatings'].map<DishRating>((json) => DishRating.fromJson(json)).toList();
    }

    return Dish(
      iri: json['@id'],
      id: json['id'] as int,
      name: json['name'],
      participants: json['participants'].map<Participant>((json) => Participant.fromJson(json)).toList(),
      dishRatings: dishRatings,
    );
  }

  Map toMap() {
    List participantsToMap = [];
    List dishRatingsToMap = [];

    participants.forEach((Participant participant) {
      participantsToMap.add(participant.iri);
    });

    dishRatings.forEach((DishRating dishRating) {
      dishRatingsToMap.add(dishRating.toMap());
    });
    
    return {
      "name": name,
      "participants": participantsToMap,
      "dishRatings": dishRatingsToMap,
    };
  }
}