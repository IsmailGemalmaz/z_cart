import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/helper/constants.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:zcart/riverpod/providers/cart_provider.dart';
import 'package:zcart/riverpod/state/cart_state.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'tab_navigation_item.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;

  BottomNavBar({this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    getLoginState();
    _currentIndex = widget.selectedIndex == null ? 0 : widget.selectedIndex;
  }

  getLoginState() async {
    accessAllowed = await getBool(LOGGED_IN, defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final cartState = watch(cartNotifierProvider.state);
      int cartItems = 0;

      if (cartState is CartLoadedState) {
        for (var item in cartState.cartList) {
          cartItems += item.items.length;
        }
      }

      return Scaffold(
        body: PageTransitionSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              FadeThroughTransition(
            fillColor: Colors.transparent,
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: _selectPage(),
        ),
        bottomNavigationBar: Stack(children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: kPrimaryColor,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: kFadeColor,
            selectedItemColor: kLightColor,
            selectedFontSize: 11,

            //showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              for (final item in TabNavigationItem.items)
                BottomNavigationBarItem(icon: item.icon, label: item.label)
            ],
          ),
          Positioned(
            top: 5,
            right: context.width() / 5 + 15,
            child: CircleAvatar(
              backgroundColor: kLightColor,
              radius: 10,
              child: Text(
                cartItems.toString(),
                style: context.theme.textTheme.caption
                    .copyWith(color: kPrimaryDarkTextColor),
              ),
            ),
          ),
        ]),
      );
    });
  }

  Widget _selectPage() {
    return TabNavigationItem.items[_currentIndex].page;
  }
}
