import 'package:degust_et_des_couleurs/core/date.dart';
import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/general_rating.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';
import 'package:degust_et_des_couleurs/model/service_rating.dart';
import 'package:degust_et_des_couleurs/model/sommelier_rating.dart';

class Tasting {
  String iri;
  int id;
  String name;
  Restaurant restaurant;
  List<Dish> dishes;
  List<Beverage> beverages;
  List<Participant> participants;
  List<ServiceRating> serviceRatings;
  List<SommelierRating> sommelierRatings;
  List<GeneralRating> generalRatings;
  DateTime createdAt;

  Tasting({
    required this.iri,
    required this.id,
    required this.name,
    required this.restaurant,
    required this.createdAt,
    required this.participants,
    required this.serviceRatings,
    required this.sommelierRatings,
    required this.generalRatings,
    required this.dishes,
    required this.beverages,
  });

  factory Tasting.fromJson(Map<String, dynamic> json) {
    return Tasting(
      iri: json['@id'],
      id: json['id'],
      name: json['name'],
      restaurant: Restaurant.fromJson(json['restaurant']),
      createdAt: DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
      participants: json['participants'].map<Participant>((json) => Participant.fromJson(json)).toList(),
      serviceRatings: json['serviceRatings'].map<ServiceRating>((json) => ServiceRating.fromJson(json)).toList(),
      sommelierRatings: json['sommelierRatings'].map<SommelierRating>((json) => SommelierRating.fromJson(json)).toList(),
      generalRatings: json['generalRatings'].map<GeneralRating>((json) => GeneralRating.fromJson(json)).toList(),
      dishes: json['dishes'].map<Dish>((json) => Dish.fromJson(json)).toList(),
      beverages: json['beverages'].map<Beverage>((json) => Beverage.fromJson(json)).toList(),
    );
  }

  String getFormattedDate() {
    return "${createdAt.day} ${Date().getFrenchMonth(createdAt.month)}";
  }
}