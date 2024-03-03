import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/colors.dart';

import '../../globals/dimension.dart';
import '../../models/ad_model.dart';

class AdLayout extends StatefulWidget {
  final List<AdModel> allAd;
  final bloc;
  const AdLayout({
    super.key,
    required this.allAd,
    required this.bloc,
  });

  @override
  State<AdLayout> createState() => _AdLayoutState();
}

class _AdLayoutState extends State<AdLayout> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    CColor cColor = CColor.of(context);
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.allAd.length,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (value) => widget.bloc.onPageChanged(value),
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.allAd[index].pic,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder<int>(
              valueListenable: widget.bloc.pageNotifier,
              builder: (context, value, child) {
                return Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height5 * 2),
                  child: DotsIndicator(
                    dotsCount: widget.allAd.length,
                    position: value,
                    decorator: DotsDecorator(
                      activeColor: cColor.white,
                      color: Colors.white.withOpacity(0.5),
                      size: Size.square(Dimensions.width5 * 2),
                      activeSize:
                          Size(Dimensions.width5 * 4, Dimensions.height5 * 2),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
