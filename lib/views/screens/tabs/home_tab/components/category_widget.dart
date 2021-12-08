import 'package:flutter/material.dart';
import 'package:zcart/Theme/styles/category_icons.dart';
import 'package:zcart/data/models/categories/category_model.dart';
import 'package:zcart/riverpod/providers/product_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/views/screens/tabs/home_tab/categories/categorisList_screen.dart';
import 'package:zcart/views/screens/tabs/home_tab/categories/category_details_screen.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zcart/views/screens/tabs/home_tab/components/search_bar.dart';

class CategoryWidget extends StatelessWidget {
  final List<CategoryList> categoryList;

  CategoryWidget(this.categoryList);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * .15,
      child: ListView.builder(
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: customBoxDecoration.copyWith(boxShadow: []),
              width: context.screenWidth * .35,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Category Icon
                  FaIcon(getCategoryIcon(categoryList[index].icon))
                      .pOnly(bottom: 5),
                  Text(
                    categoryList[index].name,
                    textAlign: TextAlign.center,
                    style: context.textTheme.subtitle2,
                  ),
                ],
              )),
            )
                .onInkTap(() {
                  if (index == 0)
                    context.nextPage(CategoryListScreen(
                        categoryList: categoryList.sublist(1)));
                  else {
                    context.read(subgroupCategoryNotifierProvider).resetState();
                    context
                        .read(categorySubgroupNotifierProvider)
                        .getCategorySubgroup(categoryList[index].id.toString());
                    context.read(productListNotifierProvider).getProductList(
                        'category-grp/${categoryList[index].slug}');
                    context.nextPage(CategoryDetailsScreen(
                        categoryListItem: categoryList[index]));
                  }
                })
                .cornerRadius(10)
                .pOnly(right: 10);
          }),
    );
  }
}

class CategoryLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: context.screenHeight * .1,
        child: ListView.builder(
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (BuildContext context, int index) {
              return Chip(
                backgroundColor: kCardBgColor,
                label: Text(
                  "Loading ...",
                  style: TextStyle(
                    color: kDarkColor,
                  ),
                ).pSymmetric(h: 12, v: 8),
              ).px(4);
            }),
      ),
    );
  }
}
