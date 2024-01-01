import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';

class PromoCard extends StatefulWidget {
  final int index;
  final String imageUrl;
  final double aspectRatio;
  final ValueNotifier<int> selectedNotifier;
  final Function() filterFunc;
  const PromoCard({
    super.key,
    required this.imageUrl,
    required this.aspectRatio,
    required this.index,
    required this.selectedNotifier,
    required this.filterFunc,
  });

  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Column(
      children: [
        ValueListenableBuilder<int>(
            valueListenable: widget.selectedNotifier,
            builder: (context, selected, child) {
              return GestureDetector(
                onTapDown: (d) => setState(() {
                  _scale = 0.95;
                }),
                onTapUp: (d) {
                  setState(() {
                    _scale = 1.0;
                    widget.selectedNotifier.value = widget.index;
                    widget.filterFunc();
                  });
                },
                onTapCancel: () => setState(() {
                  _scale = 1.0;
                }),
                child: Transform.scale(
                  scale: _scale,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected == widget.index
                            ? onSecondary
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: promoCard(
                      widget.imageUrl,
                    ),
                  ),
                ),
              );
            }),
        SizedBox(height: Dimensions.height5),
      ],
    );
  }

  Widget promoCard(imageUrl) {
    Color onSecondary = Theme.of(context).colorScheme.onSecondary;
    return widget.index == 0
        ? AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    stops: const [0.1, 0.9],
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: onSecondary,
                ),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: ((context, imageProvider) {
              return AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        stops: const [0.1, 0.9],
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            placeholder: (context, url) => SizedBox(
              height: Dimensions.height5 * 3,
              width: Dimensions.height5 * 3,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.grey,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
  }
}
