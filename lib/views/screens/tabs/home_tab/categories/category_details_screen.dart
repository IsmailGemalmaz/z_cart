import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/data/models/categories/category_model.dart';
import 'package:zcart/riverpod/providers/product_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/product/product_state.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/screens/tabs/home_tab/components/category_widget.dart';
import 'package:zcart/views/screens/tabs/home_tab/components/error_widget.dart';
import 'package:zcart/views/shared_widgets/product_details_card.dart';
import 'package:zcart/views/shared_widgets/product_loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

class CategoryDetailsScreen extends ConsumerWidget {
  final CategoryList categoryListItem;
  CategoryDetailsScreen({@required this.categoryListItem});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final categorySubgroupState = watch(categorySubgroupNotifierProvider.state);
    final subgroupCategoryState = watch(subgroupCategoryNotifierProvider.state);
    final productListState = watch(productListNotifierProvider.state);
    final scrollControllerProvider =
        watch(categoryDetailsScrollNotifierProvider);

    return ProviderListener<ScrollState>(
      provider: categoryDetailsScrollNotifierProvider.state,
      onChange: (context, state) {
        if (state is ScrollReachedBottomState) {
          context.read(productListNotifierProvider).getMoreProductList();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryListItem.name),
        ),
        body: SingleChildScrollView(
          controller: scrollControllerProvider.controller,
          child: Column(
            children: [
              /// Cover image
              Container(
                height: context.screenHeight * .15,
                width: context.screenWidth,
                child: Image.network(categoryListItem.coverImage, errorBuilder:
                    (BuildContext _, Object error, StackTrace stack) {
                  return Container();
                }, fit: BoxFit.cover),
              ).pOnly(bottom: 5),

              /// Category subgroup list
              (categorySubgroupState is CategorySubgroupInitialState ||
                      categorySubgroupState is CategorySubgroupLoadingState)
                  ? CategoryLoadingWidget()
                  : categorySubgroupState is CategorySubgroupLoadedState
                      ? SizedBox(
                          height: context.screenHeight * .07,
                          child: ListView.builder(
                              itemCount: categorySubgroupState
                                  .categorysSubgroupList.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              itemBuilder: (BuildContext context, int index) {
                                return ActionChip(
                                  backgroundColor: context
                                              .read(
                                                  categorySubgroupNotifierProvider)
                                              .getSelectedSubgroup ==
                                          index
                                      ? kPrimaryColor
                                      : kCardBgColor,
                                  label: Text(
                                    categorySubgroupState
                                        .categorysSubgroupList[index].name,
                                    style: TextStyle(
                                      color: context
                                                  .read(
                                                      categorySubgroupNotifierProvider)
                                                  .getSelectedSubgroup ==
                                              index
                                          ? kPrimaryLightTextColor
                                          : kDarkColor,
                                    ),
                                  ).pSymmetric(h: 12, v: 8),
                                  onPressed: () {
                                    context
                                        .read(categorySubgroupNotifierProvider)
                                        .setSelectedSubgroup = index;
                                    context
                                        .read(subgroupCategoryNotifierProvider)
                                        .getSubgroupCategory(
                                            categorySubgroupState
                                                .categorysSubgroupList[index].id
                                                .toString());
                                    context
                                        .read(productListNotifierProvider)
                                        .getProductList(
                                            'category-subgrp/${categorySubgroupState.categorysSubgroupList[index].slug}');
                                  },
                                ).px(4);
                              }),
                        ).px(10)
                      : categorySubgroupState is CategorySubgroupErrorState
                          ? ErrorMessageWidget(categorySubgroupState.message)
                          : Container(),

              /// Category under Subgroup
              subgroupCategoryState is SubgroupCategoryLoadingState
                  ? CategoryLoadingWidget()
                  : subgroupCategoryState is SubgroupCategoryLoadedState
                      ? SizedBox(
                          height: context.screenHeight * .07,
                          child: ListView.builder(
                              itemCount: subgroupCategoryState
                                  .subgroupCategoryList.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              itemBuilder: (BuildContext context, int index) {
                                return ActionChip(
                                  backgroundColor: context
                                              .read(
                                                  subgroupCategoryNotifierProvider)
                                              .getSelectedSubgroupCategory ==
                                          index
                                      ? kPrimaryColor
                                      : kCardBgColor,
                                  label: Text(
                                    subgroupCategoryState
                                        .subgroupCategoryList[index].name,
                                    style: TextStyle(
                                      color: context
                                                  .read(
                                                      subgroupCategoryNotifierProvider)
                                                  .getSelectedSubgroupCategory ==
                                              index
                                          ? kPrimaryLightTextColor
                                          : kDarkColor,
                                    ),
                                  ).pSymmetric(h: 12, v: 8),
                                  onPressed: () {
                                    context
                                        .read(subgroupCategoryNotifierProvider)
                                        .setSelectedSubgroupCategory = index;
                                    context
                                        .read(productListNotifierProvider)
                                        .getProductList(
                                            'category/${subgroupCategoryState.subgroupCategoryList[index].slug}');
                                  },
                                ).px(4);
                                // return Container(
                                //         padding: EdgeInsets.symmetric(
                                //             horizontal: 10, vertical: 4),
                                //         color: context
                                //                     .read(
                                //                         subgroupCategoryNotifierProvider)
                                //                     .getSelectedSubgroupCategory ==
                                //                 index
                                //             ? kPrimaryColor.withOpacity(0.5)
                                //             : kCardBgColor,
                                //         child: Column(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.center,
                                //           children: [
                                //             Text(subgroupCategoryState
                                //                 .subgroupCategoryList[index]
                                //                 .name),
                                //           ],
                                //         ))
                                //     .onInkTap(() {
                                //       context
                                //           .read(
                                //               subgroupCategoryNotifierProvider)
                                //           .setSelectedSubgroupCategory = index;
                                //       context
                                //           .read(productListNotifierProvider)
                                //           .getProductList(
                                //               'category/${subgroupCategoryState.subgroupCategoryList[index].slug}');
                                //     })
                                //     .cornerRadius(10)
                                //     .pOnly(right: 10);
                              }),
                        ).px(10)
                      : Container(),

              /// Product List
              productListState is ProductListLoadedState
                  ? productListState.productList.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Icon(Icons.info_outline),
                            Text("No Item available"),
                          ],
                        )
                      : ProductDetailsCard(
                              productList: productListState.productList)
                          .px(10)
                  : ProductLoadingWidget().px(10),
            ],
          ),
        ),
      ),
    );
  }
}
