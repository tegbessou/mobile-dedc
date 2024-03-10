import 'package:degust_et_des_couleurs/view/friend/friend_view.dart';
import 'package:flutter/material.dart';

class FriendController extends StatefulWidget {
  final int userId;

  const FriendController({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() {
    return FriendControllerState();
  }
}

class FriendControllerState extends State<FriendController> {
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    return FriendView(
      userId: userId,
    );
  }
}
