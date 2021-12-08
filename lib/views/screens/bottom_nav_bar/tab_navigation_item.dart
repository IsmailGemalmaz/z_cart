import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:zcart/views/screens/auth/not_logged_in_screen.dart';
import 'package:zcart/views/screens/tabs/tabs.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;
  final String label;

  TabNavigationItem(
      {@required this.page,
      @required this.title,
      @required this.icon,
      @required this.label});

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomeTab(),
          icon: Icon(CupertinoIcons.home),
          title: Text("Home"),
          label: "Home",
        ),
        TabNavigationItem(
          page: VendorsTab(),
          icon: Icon(CupertinoIcons.doc_plaintext),
          title: Text("Vendors"),
          label: "Vendors",
        ),
        TabNavigationItem(
          page: accessAllowed ? WishListTab() : NotLoggedInScreen(),
          icon: Icon(CupertinoIcons.heart),
          title: Text("Wishlist"),
          label: "Wishlist",
        ),
        TabNavigationItem(
          page: MyCartTab(),
          icon: Icon(CupertinoIcons.cart),
          title: Text("My Cart"),
          label: "My Cart",
        ),
        TabNavigationItem(
          page: accessAllowed ? AccountTab() : NotLoggedInScreen(),
          icon: Icon(CupertinoIcons.person),
          title: Text("Account"),
          label: "Account",
        ),
      ];
}
