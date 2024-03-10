import 'dart:math';
import 'package:degust_et_des_couleurs/model/tasting.dart';
import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:degust_et_des_couleurs/view/tasting/_share_tasting_view.dart';
import 'package:degust_et_des_couleurs/view/tasting/_tasting_resume_card_carousel_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TastingResumeCardView extends StatefulWidget {
  final Tasting tasting;
  final int userId;

  const TastingResumeCardView({
    super.key,
    required this.tasting,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() {
    return TastingResumeCardViewState();
  }
}

class TastingResumeCardViewState extends State<TastingResumeCardView> {
  final List<String> pictures = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTn0zPNJyKNwEkrd7jyPkwOC5JCZftn481CDCe0FCH0ywCW0gBCnDNqkVNn0MNXn8dZHMQ&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTd44KAI5Y4fpWHvYo82UzjeuXpo0GhKUlg_ExSdZlYZKiR3eJ5J2_bYsTW4bt-q7OCNXY&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQR3DGbY0UcZw7CpHf0pcQ35K4Bs6LWkvplN3SmIoI4YAA5a_Uo1HLgVXcnZAPMD4EIRfE&usqp=CAU",
    "https://www.materiel-horeca.com/guide/wp-content/uploads/2020/12/dressage-table.jpeg",
  ];
  late Tasting tasting;
  late int userId;

  @override
  void initState() {
    super.initState();

    tasting = widget.tasting;
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return InkWell(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          top: 15,
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
                width: 72,
                height: 72,
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 15)),
            SizedBox(
                width: MediaQuery.of(context).size.width - 165,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 215,
                          child: TextDmSans(
                            tasting.restaurant.name,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        canShare()
                            ? IconButton(
                                onPressed: shareDish,
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  size: 20,
                                ),
                              )
                            : Container(),
                      ],
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
                        TextDmSans(
                          "${tasting.participants.length} participants",
                          fontSize: 11,
                          letterSpacing: 0,
                          color: MyColors().greyColor,
                        ),
                        const Spacer(),
                        TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: MyColors().greyColor,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(30, 10),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    content: TastingResumeCardCarouselView(
                                      tasting: tasting,
                                    ),
                                  ),
                                ),
                            child: TextDmSans(
                              "Voir photos",
                              fontSize: 11,
                              letterSpacing: 0,
                              color: MyColors().greyColor,
                            )),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void shareDish() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        builder: (context) {
          return ShareTastingView(
            tasting: tasting,
          );
        });
  }

  bool canShare() {
    return tasting.user == "/users/$userId";
  }
}
