import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/pages/promo_page.dart';

class PromoCard extends StatefulWidget {
  final String imageUrl;
  final double aspectRatio;
  const PromoCard({
    super.key,
    required this.imageUrl,
    required this.aspectRatio,
  });

  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (d) => setState(() {
            _scale = 0.95;
          }),
          onTapUp: (d) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PromoPage(),
              ),
            );
            setState(() {
              _scale = 1.0;
            });
          },
          onTapCancel: () => setState(() {
            _scale = 1.0;
          }),
          child: Transform.scale(
            scale: _scale,
            child: promoCard(
              widget.imageUrl,
            ),
          ),
        ),
        SizedBox(height: Dimensions.height5),
      ],
    );
  }

  Widget promoCard(imageUrl) {
    return CachedNetworkImage(
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
