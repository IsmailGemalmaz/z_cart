import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/providers/user_provider.dart';
import 'package:zcart/riverpod/state/user_state.dart';
import 'package:zcart/views/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:zcart/views/screens/tabs/account_tab/others/termsAndConditions_screen.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  String _email = '';
  String _name = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ProviderListener<UserState>(
        provider: userNotifierProvider.state,
        onChange: (context, state) {
          if (state is UserLoadedState) {
            context.read(cartNotifierProvider).getCartList();
            context.read(wishListNotifierProvider).getWishList();
            context.nextAndRemoveUntilPage(BottomNavBar(selectedIndex: 0));
          }
          if (state is UserErrorState) {
            toast(state.message, bgColor: kPrimaryColor);
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: kCardBgColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sign Up",
                                      style: context.textTheme.headline5),
                                ],
                              ),
                            ).paddingBottom(20),
                            CustomTextField(
                              hintText: "Full Name",
                              title: "Full Name",
                              onChanged: (value) => _name = value,
                              validator: (value) => value.isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            CustomTextField(
                              hintText: "Email",
                              title: "Email",
                              onChanged: (value) => _email = value,
                              validator: (value) => value.isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            CustomTextField(
                              isPassword: true,
                              hintText: "Password",
                              title: "Password",
                              onChanged: (value) => _password = value,
                              validator: (value) => value.length < 6
                                  ? 'Password must be at least 6 characters long'
                                  : null,
                            ),
                            CustomTextField(
                              isPassword: true,
                              hintText: "Confirm Password",
                              title: "Confirm Password",
                              validator: (value) => value != _password
                                  ? 'Password don\'t match'
                                  : null,
                            ),
                            CustomButton(
                              buttonText: "REGISTER",
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  hideKeyboard(context);
                                  context.read(userNotifierProvider).register(
                                      _name.trim(),
                                      _email.trim(),
                                      _password,
                                      true,
                                      false);
                                }
                              },
                            ).pOnly(top: 10),
                            Text("By signing up, you are confirming you agree to our Terms of Service")
                                .text
                                .center
                                .black
                                .textStyle(context.textTheme.caption)
                                .make()
                                .w(context.screenWidth * 0.8)
                                .onInkTap(() => context.nextReplacementPage(
                                    TermsAndConditionScreen()))
                                .pOnly(bottom: 10),
                            Text("Already have an account? LOG IN")
                                .text
                                .center
                                .black
                                .textStyle(context.textTheme.caption)
                                .make()
                                .w(context.screenWidth * 0.8)
                                .onInkTap(() => context.pop()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (context, watch, _) {
                  final authState = watch(userNotifierProvider.state);
                  return Visibility(
                    visible: authState is UserLoadingState,
                    child: Container(
                      color: kLightColor,
                      child: LoadingWidget(),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
