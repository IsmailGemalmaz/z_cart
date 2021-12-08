import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider(this.sliderList);

  final List sliderList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              height: context.percentHeight * 45,
              viewportFraction: 1,
              autoPlay: true,
            ),
            items: sliderList
                .map((item) => Container(
                      width: double.infinity,
                      color: kLightColor,
                      child: Image.network(
                        item.path,
                        fit: BoxFit.scaleDown,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          print(
                              "Exception: $exception\nStackTrace: $stackTrace");
                          return Container();
                        },
                      ),
                    ).cornerRadius(10))
                .toList()),
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: kFadeColor.withOpacity(0.3),
          ),
          child: BackButton(
            color: kDarkColor,
            onPressed: () {
              context.pop();
            },
          ),
        ).p(10),
      ],
    );
  }
}
