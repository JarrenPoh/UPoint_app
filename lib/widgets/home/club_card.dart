import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint/globals/colors.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/pages/organizer_profile.dart';
import '../../globals/dimension.dart';
import '../../models/organizer_model.dart';

class ClubCard extends StatefulWidget {
  final String hero;
  final OrganizerModel club;

  const ClubCard({
    super.key,
    required this.hero,
    required this.club,
  });

  @override
  State<ClubCard> createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  late CColor cColor = CColor.of(context);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizerProfile(
              organizer: widget.club,
              hero: widget.hero,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cColor.div,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height2 * 6,
          horizontal: Dimensions.width2 * 6,
        ),
        child: clubCard(
          widget.club.pic,
          widget.club.username,
        ),
      ),
    );
  }

  Widget clubCard(
    imageUrl,
    clubName,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: widget.hero,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: Dimensions.width2 * 4),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MediumText(
                color: cColor.grey500,
                size: 14,
                text: clubName,
                maxLines: 3,
              ),
              Icon(
                Icons.favorite_rounded,
                color: cColor.grey300,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
