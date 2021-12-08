import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/helper/images.dart';
import 'package:zcart/views/screens/tabs/home_tab/search/search_screen.dart';

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          width: 50,
          child: Image.asset(AppImages.logo),
        ).pOnly(left: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => context.nextPage(SearchScreen()),
            child: Container(
              decoration: customBoxDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: kFadeColor,
                      ),
                      Text(
                        "Search Keyword",
                        style: context.textTheme.subtitle2
                            .copyWith(color: kPrimaryFadeTextColor),
                      ).px(5),
                    ],
                  ).p(10),
                  IconButton(
                      onPressed: () {
                        //TODO: Add Image Search
                        context.nextPage(SearchScreen());
                      },
                      icon: Icon(
                        CupertinoIcons.camera,
                        size: 18,
                        color: kFadeColor,
                      ))
                ],
              ),
            ).pSymmetric(h: 10, v: 8),
          ),
        ),
      ],
    );
  }
}

var customBoxDecoration = BoxDecoration(
  color: kLightColor,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
        blurRadius: 20,
        color: kDarkColor.withOpacity(0.1),
        spreadRadius: 3,
        offset: Offset(1, 1)),
  ],
);
