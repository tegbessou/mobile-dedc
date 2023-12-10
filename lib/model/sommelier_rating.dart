import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';

class SommelierRating {
  String? iri;
  int? id;
  Participant participant;
  String? rate;
  String? comment;
  Tasting? tasting;

  SommelierRating({
    this.iri = "",
    this.id,
    required this.participant,
    this.rate,
    this.comment,
    this.tasting,
  });

  factory SommelierRating.fromJson(Map<String, dynamic> json) {
    return SommelierRating(
      iri: json['@id'],
      id: json['id'] as int,
      participant: Participant.fromJson(json['participant']),
      rate: json['rate'],
      comment: json['comment'],
    );
  }
}
