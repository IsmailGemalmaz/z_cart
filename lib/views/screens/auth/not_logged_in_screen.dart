import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/data/controller/blog/blog_controller.dart';
import 'package:zcart/data/controller/others/others_controller.dart';
import 'package:zcart/views/screens/auth/login_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/blogs/blogs_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/aboutUs_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/privacyPolicy_screen.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/termsAndConditions_screen.dart';
import 'package:zcart/views/shared_widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotLoggedInScreen extends StatelessWidget {
  const NotLoggedInScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: kDarkColor.withOpacity(0.5),
                        child: Icon(
                          Icons.person,
                          color: kLightColor,
                          size: 28,
                        ),
                      ).pOnly(bottom: 5),
                      Text(
                        'You need to log in to access this section',
                        textAlign: TextAlign.center,
                        style: context.textTheme.subtitle2
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        onTap: () {
                          context.nextPage(LoginScreen(
                            needBackButton: true,
                          ));
                        },
                        buttonText: "Log in",
                      ),
                      Divider(
                        height: 20,
                        thickness: 2,
                        color: kAccentColor.withOpacity(0.5),
                        endIndent: 20,
                        indent: 20,
                      ),
                      Card(
                        elevation: 0,
                        color: kCardBgColor,
                        child: ListTile(
                          title: Text("Blogs",
                              style: context.textTheme.subtitle2
                                  .copyWith(color: kDarkColor)),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.read(blogsProvider).blogs();
                            context.nextPage(BlogsScreen());
                          },
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: kCardBgColor,
                        child: ListTile(
                          title: Text("About Us",
                              style: context.textTheme.subtitle2
                                  .copyWith(color: kDarkColor)),
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
                              style: context.textTheme.subtitle2
                                  .copyWith(color: kDarkColor)),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context
                                .read(privacyPolicyProvider)
                                .fetchPrivacyPolicy();
                            context.nextPage(PrivacyPolicyScreen());
                          },
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: kCardBgColor,
                        child: ListTile(
                          title: Text("Terms and Conditions",
                              style: context.textTheme.subtitle2
                                  .copyWith(color: kDarkColor)),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context
                                .read(termsAndConditionProvider)
                                .fetchTermsAndCondition();
                            context.nextPage(TermsAndConditionScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
