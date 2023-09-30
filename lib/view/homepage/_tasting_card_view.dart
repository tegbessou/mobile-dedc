import 'dart:math';

import 'package:degust_et_des_couleurs/controller/tasting_controller.dart';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TastingCardView extends StatelessWidget {
  List<String> pictures = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTn0zPNJyKNwEkrd7jyPkwOC5JCZftn481CDCe0FCH0ywCW0gBCnDNqkVNn0MNXn8dZHMQ&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTd44KAI5Y4fpWHvYo82UzjeuXpo0GhKUlg_ExSdZlYZKiR3eJ5J2_bYsTW4bt-q7OCNXY&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQR3DGbY0UcZw7CpHf0pcQ35K4Bs6LWkvplN3SmIoI4YAA5a_Uo1HLgVXcnZAPMD4EIRfE&usqp=CAU",
    "https://www.materiel-horeca.com/guide/wp-content/uploads/2020/12/dressage-table.jpeg",
  ];

  TastingCardView({
    super.key,
    required this.tasting,
  });

  Tasting tasting;

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return InkWell(
      onTap: () {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
          return TastingController(id: tasting.id);
        });

        Navigator.of(context).push(materialPageRoute);
      },
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                pictures[random.nextInt(3) + 1],
                fit: BoxFit.cover,
                width: 92,
                height: 92,
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 15)),
            Container(
              padding: const EdgeInsets.only(
                top: 7,
                bottom: 7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tasting.restaurant.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${tasting.getFormattedDate()} - ${tasting.name}",
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${tasting.participants.length} participants",
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 85,
                        margin: const EdgeInsets.only(
                          left: 80,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: MyColors().lightPrimaryColor,
                            elevation: 0,
                          ),
                          onPressed: () {
                            MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) {
                              return TastingController(id: tasting.id);
                            });

                            Navigator.of(context).push(materialPageRoute);
                          },
                          child: Center(
                            child: TextDmSans(
                              "Reprendre",
                              fontSize: 11,
                              letterSpacing: 0,
                              color: MyColors().primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}