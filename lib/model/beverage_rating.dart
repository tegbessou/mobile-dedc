import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';

class BeverageRating {
  String? iri;
  int? id;
  Participant participant;
  String? rate;
  String? comment;
  Beverage? beverage;

  BeverageRating({
    this.iri = "",
    this.id,
    required this.participant,
    this.rate,
    this.comment,
    this.beverage,
  });

  factory BeverageRating.fromJson(Map<String, dynamic> json) {
    return BeverageRating(
      iri: json['@id'],
      id: json['id'] as int,
      participant: Participant.fromJson(json['participant']),
      rate: json['rate'],
      comment: json['comment'],
    );
  }
}