import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/data/controller/cart/coupon_controller.dart';
import 'package:zcart/data/network/api.dart';
import 'package:zcart/helper/constants.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:zcart/helper/images.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/views/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    goToNextScreen();
  }

  goToNextScreen() async {
    var responseBody = await handleResponse(
        await getRequest(API.orders, bearerToken: true),
        showToast: false);
    if (responseBody.runtimeType == int && responseBody == 401) {
      await getSharedPref().then((value) => value.clear());
    }
    accessAllowed = await getBool(LOGGED_IN, defaultValue: false);
    initialData();
    Future.delayed(Duration(milliseconds: 300),
        () => context.nextReplacementPage(BottomNavBar()));
  }

  initialData() async {
    context.read(categoryNotifierProvider).getCategory();
    context.read(bannerNotifierProvider).getBanner();
    context.read(sliderNotifierProvider).getSlider();
    context.read(trendingNowNotifierProvider).getTrendingNowItems();
    context.read(latestItemNotifierProvider).getLatestItem();
    context.read(popularItemNotifierProvider).getLatestItem();
    context.read(randomItemNotifierProvider).getRandomItems();
    context.read(vendorsNotifierProvider).getVendors();
    context.read(cartNotifierProvider).getCartList();

    if (accessAllowed) {
      context.read(ordersProvider).orders();
      context.read(userNotifierProvider).getUserInfo();
      context.read(wishListNotifierProvider).getWishList();
      context.read(disputesProvider).getDisputes();
      context.read(couponsProvider).coupons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingWidget(),
            Container(
                width: context.screenWidth * 0.4,
                child: Image.asset(
                  AppImages.splashImage,
                  fit: BoxFit.fitWidth,
                )).py(20),
          ],
        ),
      ),
    ));
  }
}
