import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/widgets/home/act_card.dart';
import 'package:upoint/widgets/home/promo_card.dart';

class MainArea extends StatefulWidget {
  const MainArea({super.key});

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  List promoImages = [
    "https://images.unsplash.com/photo-1701127749663-78686c12f8e1?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1701203580497-e49d73574908?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4fHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1701198067264-0d9b607bd399?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D",
  ];
  List actImages = [
    "https://plus.unsplash.com/premium_photo-1700782893131-1f17b56098d0?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1701453831008-ea11046da960?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8",
    "https://images.unsplash.com/photo-1682687221175-fd40bbafe6ca?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
  ];
  List actTitle = ['3D雷雕工作坊', '創業計畫書工作坊', '投資人的眼光'];
  List actOrganizer = ['中原大學育成中心', '中原大學學發中心', '中原大學通識中心'];
  
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;

    return Column(
      children: [
        Column(
          children: [
            SizedBox(height: Dimensions.height5*2),
            Text(
              'Promo Today',
              style: TextStyle(
                color: onSecondary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.height5 * 3),
            Container(
              height: Dimensions.height5 * 40,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(promoImages.length, (index) {
                  return PromoCard(
                    imageUrl: promoImages[index],
                  );
                }),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height5 * 6),
        Column(
          children: [
            Text(
              'Activity Today',
              style: TextStyle(
                color: onSecondary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.height5 * 1),
            Column(
              children: List.generate(
                actImages.length,
                (index) {
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Dimensions.width5*2),
                    child: ActCard(
                      imageUrl: actImages[index],
                      title: actTitle[index],
                      organizer: actOrganizer[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
