import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/widgets/act_card.dart';
import 'package:upoint/widgets/promo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  List actTitle = ['3D雷雕工作坊','創業計畫書工作坊','投資人的眼光'];
  List actOrganizer = [
    '中原大學育成中心','中原大學學發中心','中原大學通識中心'
  ];  

  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width5 * 6,
                  vertical: Dimensions.height5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Your',
                      style: TextStyle(
                        color: onSecondary,
                        fontSize: Dimensions.height5 * 5,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Text(
                      'Activities',
                      style: TextStyle(
                        color: onSecondary,
                        fontSize: Dimensions.height5 * 8,
                      ),
                    ),
                    SizedBox(height: Dimensions.height5 * 2),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: onSecondary,
                          ),
                          hintText: "Search you're looking for",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimensions.height5 * 3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height5 * 2),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  displacement: Dimensions.height5 * 3,
                  backgroundColor: onPrimary,
                  color: onSecondary,
                  onRefresh: () async {
                    print('onRefresh');
                  },
                  child: ListView(
                    children: [
                      SizedBox(height: Dimensions.height5 * 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
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
                                children:
                                    List.generate(promoImages.length, (index) {
                                  return PromoCard(
                                    imageUrl: promoImages[index],
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: Dimensions.height5 * 6),
                            Text(
                              'Activity Today',
                              style: TextStyle(
                                color: onSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimensions.height5 * 1),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(
                                actImages.length,
                                (index) {
                                  return ActCard(
                                    imageUrl: actImages[index],
                                    title: actTitle[index],
                                    organizer:actOrganizer[index] ,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
