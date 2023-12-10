import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';

class DishRating {
  String? iri;
  int? id;
  Participant participant;
  String? rate;
  String? comment;
  Dish? dish;

  DishRating({
    this.iri = "",
    this.id,
    required this.participant,
    this.rate,
    this.comment,
    this.dish,
  });

  factory DishRating.fromJson(Map<String, dynamic> json) {
    return DishRating(
      iri: json['@id'],
      id: json['id'] as int,
      participant: Participant.fromJson(json['participant']),
      rate: json['rate'],
      comment: json['comment'],
    );
  }

  Map toMap() {
    final Map dishRatingMap = {
      "participant": participant.iri,
      "rate": rate,
      "comment": comment,
    };

    if (id != null) {
      dishRatingMap["id"] = id;
    }

    return dishRatingMap;
  }
}
