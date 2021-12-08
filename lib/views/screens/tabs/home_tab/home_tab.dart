import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/providers/scroll_provider.dart';
import 'package:zcart/riverpod/state/scroll_state.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'components/category_widget.dart';
import 'components/error_widget.dart';
import 'components/slider_widget.dart';
import 'components/search_bar.dart';
import 'components/banners_widget.dart';

class HomeTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final sliderState = watch(sliderNotifierProvider.state);
    final categoryState = watch(categoryNotifierProvider.state);
    final bannerState = watch(bannerNotifierProvider.state);
    final trendingNowState = watch(trendingNowNotifierProvider.state);
    final latestItemState = watch(latestItemNotifierProvider.state);
    final popularItemState = watch(popularItemNotifierProvider.state);
    final randomItemState = watch(randomItemNotifierProvider.state);
    final scrollControllerProvider = watch(randomItemScrollNotifierProvider);

    return ProviderListener<ScrollState>(
        provider: randomItemScrollNotifierProvider.state,
        onChange: (context, state) {
          if (state is ScrollReachedBottomState) {
            context.read(randomItemNotifierProvider).getMoreRandomItems();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kLightBgColor,
            brightness: Brightness.light,
            flexibleSpace: SafeArea(child: CustomSearchBar()),
          ),
          body: SingleChildScrollView(
            controller: scrollControllerProvider.controller,
            child: Column(
              children: [
                /// Slider
                sliderState is SliderLoadedState
                    ? SliderWidget(sliderState.sliderList).py(5)
                    : sliderState is SliderErrorState
                        ? ErrorMessageWidget(sliderState.message)
                        : Container(),

                /// Category
                (categoryState is CategoryInitialState ||
                        categoryState is CategoryLoadingState)
                    ? Container()
                    : categoryState is CategoryLoadedState
                        ? CategoryWidget(categoryState.categoryList).py(5)
                        : categoryState is CategoryErrorState
                            ? ErrorMessageWidget(categoryState.message)
                            : Container(),

                /// Banner
                bannerState is BannerLoadedState
                    ? BannerWidget(bannerState.bannerList.sublist(0, 3))
                    : bannerState is BannerErrorState
                        ? ErrorMessageWidget(bannerState.message)
                        : Container(),

                /// Trending Now
                trendingNowState is TrendingNowLoadedState
                    ? ProductCard(
                            title: "Trending Now",
                            productList: trendingNowState.trendingNowList)
                        .py(15)
                    : trendingNowState is TrendingNowErrorState
                        ? ErrorMessageWidget(trendingNowState.message)
                        : ProductLoadingWidget(),

                /// Banner
                bannerState is BannerLoadedState
                    ? BannerWidget(
                        bannerState.bannerList.sublist(3, 5),
                        isReverse: false,
                      )
                    : bannerState is BannerErrorState
                        ? ErrorMessageWidget(bannerState.message)
                        : Container(),

                /// Recently Added (Latest Item)
                latestItemState is LatestItemLoadedState
                    ? ProductCard(
                            title: "Recently Added",
                            productList: latestItemState.latestItemList)
                        .py(15)
                    : latestItemState is LatestItemErrorState
                        ? ErrorMessageWidget(latestItemState.message)
                        : ProductLoadingWidget(),

                /// Popular Items
                popularItemState is PopularItemLoadedState
                    ? ProductCard(
                            title: "Popular Items",
                            productList: popularItemState.popularItemList)
                        .pOnly(bottom: 15)
                    : popularItemState is PopularItemErrorState
                        ? ErrorMessageWidget(popularItemState.message)
                        : ProductLoadingWidget(),

                /// Banner
                bannerState is BannerLoadedState
                    ? BannerWidget(bannerState.bannerList.sublist(5))
                    : bannerState is BannerErrorState
                        ? ErrorMessageWidget(bannerState.message)
                        : Container(),

                /// Random Items (Additional Items to Explore in the UI)
                randomItemState is RandomItemLoadedState
                    ? ProductDetailsCard(
                            title: "Additional Items to Explore",
                            productList: randomItemState.randomItemList)
                        .py(15)
                    : randomItemState is RandomItemErrorState
                        ? ErrorMessageWidget(randomItemState.message)
                        : ProductLoadingWidget(),
              ],
            ).px(10),
          ),
        ));
  }
}
