import 'package:degust_et_des_couleurs/core/date.dart';
import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/participant.dart';
import 'package:degust_et_des_couleurs/model/restaurant.dart';

class Tasting {
  String iri;
  int id;
  String name;
  Restaurant restaurant;
  List<Dish> dishes;
  List<Beverage> beverages;
  List<Participant> participants;
  DateTime createdAt;

  Tasting({
    required this.iri,
    required this.id,
    required this.name,
    required this.restaurant,
    required this.createdAt,
    required this.participants,
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
      dishes: json['dishes'].map<Dish>((json) => Dish.fromJson(json)).toList(),
      beverages: json['beverages'].map<Beverage>((json) => Beverage.fromJson(json)).toList(),
    );
  }

  String getFormattedDate() {
    return "${createdAt.day} ${Date().getFrenchMonth(createdAt.month)}";
  }
}