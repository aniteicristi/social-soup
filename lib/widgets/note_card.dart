import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:social_soup/global/styles/normal.dart';
import 'package:social_soup/models/note.dart';

class NoteCard extends StatelessWidget {
  NoteCard(this.note);

  Rx<Note> note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Get.width * .6,
          child: TextButton(
            onPressed: () {
              Get.toNamed('/profile', arguments: note.value.user);
            },
            child: Row(
              children: [
                SvgPicture.network(
                  note.value.userObject!.profilePicture,
                  width: Get.width * .1,
                ),
                Text(
                  '@${note.value.userObject?.handle}',
                  style: NormalStyle(),
                ),
              ],
            ),
          ),
        ),
        Text(
          note.value.note,
          style: NormalStyle(),
        ),
      ],
    );
  }
}
