import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zcart/Theme/styles/category_icons.dart';
import 'package:zcart/data/models/categories/category_model.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/views/screens/tabs/home_tab/categories/category_details_screen.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/views/screens/tabs/home_tab/components/search_bar.dart';

class CategoryListScreen extends StatelessWidget {
  final List<CategoryList> categoryList;

  CategoryListScreen({this.categoryList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Categories"),
        ),
        body: Container(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: categoryList.length,
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  decoration: customBoxDecoration.copyWith(
                    boxShadow: [],
                  ),
                  child: GridTile(
                    header: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            kAccentColor.withOpacity(0.7),
                            kPrimaryColor
                          ]),
                          borderRadius: BorderRadius.circular(30)),
                    ).pOnly(top: 16, left: 112, right: 16),
                    child: Center(
                      child: FaIcon(
                        getCategoryIcon(categoryList[index].icon),
                        size: 35,
                        color: kDarkColor,
                      ),
                    ),
                    footer: Center(
                        child:
                            Text(categoryList[index].name).pOnly(bottom: 24)),
                  ).onInkTap(() {
                    context.read(subgroupCategoryNotifierProvider).resetState();
                    context
                        .read(categorySubgroupNotifierProvider)
                        .getCategorySubgroup(categoryList[index].id.toString());
                    context.read(productListNotifierProvider).getProductList(
                        'category-grp/${categoryList[index].slug}');
                    context.nextPage(CategoryDetailsScreen(
                        categoryListItem: categoryList[index]));
                  }),
                ).p(10);
              }),
        ));
  }
}
