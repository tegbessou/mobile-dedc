import 'package:carousel_slider/carousel_slider.dart';
import 'package:degust_et_des_couleurs/exception/no_picture_exception.dart';
import 'package:degust_et_des_couleurs/model/beverage.dart';
import 'package:degust_et_des_couleurs/model/dish.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/repository/beverage_repository.dart';
import 'package:degust_et_des_couleurs/repository/dish_repository.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TastingResumeCardCarouselView extends StatefulWidget {
  final Tasting tasting;

  const TastingResumeCardCarouselView({super.key, required this.tasting});

  @override
  State<StatefulWidget> createState() {
    return TastingResumeCardCarouselViewState();
  }
}

class TastingResumeCardCarouselViewState
    extends State<TastingResumeCardCarouselView> {
  late Tasting tasting;
  List<Widget> pictures = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPictures().onError((error, stackTrace) {
          Navigator.of(context).pop();

          throw NoPictureException();
        }),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          List<Widget>? pictures = [];

          if (snapshot.hasData) {
            pictures = snapshot.data;
          } else {
            //Put a loader here
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                child: Container(
                  color: MyColors().lightGreyColor,
                  child: Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: MyColors().primaryColor,
                      size: 50,
                    ),
                  ),
                ),
              );
          }

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.50,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              items: pictures,
            ),
          );
        });
  }

  Future<List<Widget>> getPictures() async {
    return await loadPictures().then((value) {
      final List<Widget> widgets = [];

      value
          .forEach((key, value) {
        final widget = Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(value, fit: BoxFit.fill, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        key,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );

        widgets.add(widget);
      });

      if (widgets.isEmpty) {
        throw NoPictureException();
      }

      return widgets;
    });
  }

  Future<Map<String, String>> loadPictures() async {
    final Map<String, String> pictures = {};

    setState(() {
      isLoading = true;
    });

    final List<Dish> dishes = await DishRepository().findByTasting(tasting);
    final List<Beverage> beverages =
        await BeverageRepository().findByTasting(tasting);

    for (var element in dishes) {
      if (element.contentUrl == null) {
        continue;
      }

      pictures[element.name] = element.contentUrl!;
    }

    for (var element in beverages) {
      if (element.contentUrl == null) {
        continue;
      }

      pictures[element.name] = element.contentUrl!;
    }

    setState(() {
      isLoading = false;
    });

    return pictures;
  }
}
