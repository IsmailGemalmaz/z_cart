import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/data/controller/blog/blog_controller.dart';
import 'package:zcart/data/controller/cart/coupon_controller.dart';
import 'package:zcart/data/controller/cart/coupon_state.dart';
import 'package:zcart/data/controller/chat/chat_controller.dart';
import 'package:zcart/data/controller/others/others_controller.dart';
import 'package:zcart/helper/constants.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/order_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/providers/wishlist_provider.dart';
import 'package:zcart/riverpod/state/dispute/disputes_state.dart';
import 'package:zcart/riverpod/state/order_state.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/riverpod/state/wishlist_state.dart';
import 'package:zcart/views/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:zcart/views/screens/tabs/account_tab/account/account_details_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/blogs/blogs_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/coupons/myCoupons_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/disputes/disputes_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/messages/messages_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/orders/myOrder_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/aboutUs_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/privacyPolicy_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/termsAndConditions_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Account"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Account_dashboard(),
                UserActivityCard(),
                ActionCard(),
                BottomCard(),
              ],
            ),
          ),
        ));
  }
}

class Account_dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final userState = watch(userNotifierProvider.state);

      return userState is UserLoadedState
          ? Container(
              padding: EdgeInsets.all(16),
              color: kLightColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        backgroundImage: NetworkImage(userState.user.avatar),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: context.textTheme.caption.copyWith(
                                  color: kPrimaryFadeTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${userState.user.name}",
                              style: context.textTheme.subtitle2
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ).pOnly(bottom: 10).px(10),
                  Divider(
                    height: 16,
                    thickness: 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: context.textTheme.caption.copyWith(
                            color: kPrimaryFadeTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${userState.user.email}",
                        style: context.textTheme.subtitle2
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ).p(10),
                  Divider(
                    height: 16,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sex",
                              style: context.textTheme.caption.copyWith(
                                  color: kPrimaryFadeTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${userState.user.sex}",
                              style: context.textTheme.subtitle2
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date of birth",
                              style: context.textTheme.caption.copyWith(
                                  color: kPrimaryFadeTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${userState.user.dob}",
                              style: context.textTheme.subtitle2
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ).p(10),
                ],
              ),
            ).cornerRadius(10).px(10).paddingBottom(10)
          : Container();
    });
  }
}

class UserActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kCardBgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(builder: (context, watch, _) {
                  final orderListState = watch(ordersProvider.state);

                  return Text(
                    orderListState is OrdersLoadedState
                        ? orderListState.orders.length.toString()
                        : "0",
                    style: context.textTheme.headline4.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  );
                }),
                Text(
                  "Orders",
                  style: context.textTheme.caption
                      .copyWith(color: kDarkColor, fontWeight: FontWeight.bold),
                )
              ],
            ).onInkTap(() {
              context.nextPage(MyOrderScreen());
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kCardBgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, watch, _) {
                    final couponState = watch(couponsProvider.state);
                    return Text(
                      couponState is CouponLoadedState
                          ? "${couponState.coupon.length}"
                          : "0",
                      style: context.textTheme.headline4.copyWith(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                Text(
                  "Coupons",
                  style: context.textTheme.caption
                      .copyWith(color: kDarkColor, fontWeight: FontWeight.bold),
                ),
              ],
            ).onInkTap(() {
              context.nextPage(MyCouponsScreen());
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kCardBgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, watch, _) {
                    final disputesState = watch(disputesProvider.state);
                    return Text(
                      disputesState is DisputesLoadedState
                          ? disputesState.disputes.length.toString()
                          : "0",
                      style: context.textTheme.headline4.copyWith(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                Text(
                  "Disputes",
                  style: context.textTheme.caption
                      .copyWith(color: kDarkColor, fontWeight: FontWeight.bold),
                )
              ],
            ).onInkTap(() {
              context.nextPage(DisputeScreen());
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kCardBgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (ctx, watch, _) {
                    final wishListState = watch(wishListNotifierProvider.state);
                    return Text(
                      wishListState is WishListLoadedState
                          ? wishListState.wishList.length.toString()
                          : '0',
                      style: context.textTheme.headline4.copyWith(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                Text(
                  "Wishlist",
                  style: context.textTheme.caption
                      .copyWith(color: kDarkColor, fontWeight: FontWeight.bold),
                )
              ],
            ).onInkTap(() {
              context.nextReplacementPage(BottomNavBar(selectedIndex: 2));
            }),
          ),
        ),
      ],
    ).cornerRadius(10).p(10);
  }
}

class ActionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: kLightColor,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bubble_left_bubble_right,
                          color: kDarkColor)
                      .pOnly(bottom: 10),
                  Text(
                    "Messages",
                    style: context.textTheme.caption.copyWith(
                        color: kDarkColor, fontWeight: FontWeight.bold),
                  )
                ],
              ).onInkTap(() {
                context.read(conversationProvider).conversation();
                context.nextPage(MessagesScreen());
              }),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.doc_append, color: kDarkColor)
                      .pOnly(bottom: 10),
                  Text(
                    "Blogs",
                    style: context.textTheme.caption.copyWith(
                        color: kDarkColor, fontWeight: FontWeight.bold),
                  )
                ],
              ).onInkTap(() {
                context.read(blogsProvider).blogs();
                context.nextPage(BlogsScreen());
              }),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.person, color: kDarkColor)
                      .pOnly(bottom: 10),
                  Text(
                    "Account",
                    style: context.textTheme.caption.copyWith(
                        color: kDarkColor, fontWeight: FontWeight.bold),
                  )
                ],
              ).onInkTap(() {
                context.read(userNotifierProvider).getUserInfo();
                context.read(countryNotifierProvider).getCountries();
                context.read(addressNotifierProvider).fetchAddress();
                context.nextPage(AccountDetailsScreen());
              }),
            ),
          ],
        )).cornerRadius(10).p(10);
  }
}

class BottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Card(
          elevation: 0,
          color: kCardBgColor,
          child: ListTile(
            title: Text("About Us",
                style: context.textTheme.subtitle2.copyWith(color: kDarkColor)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.read(aboutUsProvider).fetchAboutUs();
              context.nextPage(AboutUsScreen());
            },
          ),
        ),
        Card(
          elevation: 0,
          color: kCardBgColor,
          child: ListTile(
            title: Text("Privacy Policy",
                style: context.textTheme.subtitle2.copyWith(color: kDarkColor)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.read(privacyPolicyProvider).fetchPrivacyPolicy();
              context.nextPage(PrivacyPolicyScreen());
            },
          ),
        ),
        Card(
          elevation: 0,
          color: kCardBgColor,
          child: ListTile(
            title: Text("Terms and Conditions",
                style: context.textTheme.subtitle2.copyWith(color: kDarkColor)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.read(termsAndConditionProvider).fetchTermsAndCondition();
              context.nextPage(TermsAndConditionScreen());
            },
          ),
        ),
        Card(
          elevation: 0,
          color: kCardBgColor,
          child: ListTile(
            trailing: Icon(Icons.logout_outlined),
            title: Text("Logout",
                style: context.textTheme.subtitle2.copyWith(color: kDarkColor)),
            onTap: () async {
              showConfirmDialog(context, "Are your sure to log out?",
                  buttonColor: kPrimaryColor, onAccept: () {
                context.read(userNotifierProvider).logout();
                setBool(LOGGED_IN, false);
                context.nextAndRemoveUntilPage(BottomNavBar());
              });
            },
          ),
        ),
      ],
    )).cornerRadius(10).p(10);
  }
}
