import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/controller/cart/coupon_controller.dart';
import 'package:zcart/riverpod/providers/dispute_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/user_state.dart';
import 'package:zcart/views/screens/auth/reset_password.dart';
import 'package:zcart/views/screens/auth/sign_up_screen.dart';
import 'package:zcart/views/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginScreen extends StatefulWidget {
  final needBackButton;

  LoginScreen({this.needBackButton = false});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener<UserState>(
      provider: userNotifierProvider.state,
      onChange: (context, state) {
        if (state is UserLoadedState) {
          context.read(ordersProvider).orders();
          context.read(wishListNotifierProvider).getWishList();
          context.read(disputesProvider).getDisputes();
          context.read(couponsProvider).coupons();
          context.nextAndRemoveUntilPage(BottomNavBar(selectedIndex: 0));
        }
        if (state is UserErrorState) {
          toast(state.message, bgColor: kPrimaryColor);
        }
      },
      child: Scaffold(
        appBar: widget.needBackButton ? AppBar() : null,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                                  Text("Sign In",
                                      style: context.textTheme.headline5),
                                ],
                              ),
                            ).paddingBottom(20),
                            CustomTextField(
                              hintText: "Your Email",
                              title: "Your Email",
                              controller: _emailController,
                              validator: (value) => value.isEmpty
                                  ? 'This field is required'
                                  : null,
                            ),
                            CustomTextField(
                              isPassword: true,
                              hintText: "Password",
                              title: "Password",
                              controller: _passwordController,
                              validator: (value) => value.length < 6
                                  ? 'Password must be at least 6 characters long'
                                  : null,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot password?",
                                style: context.textTheme.subtitle2.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ).onInkTap(() {
                                context.nextPage(ResetPassword());
                              }).py(5),
                            ),
                            CustomButton(
                                buttonText: "Log In",
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    //hideKeyboard(context);
                                    context.read(userNotifierProvider).login(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim());
                                  }
                                }).pOnly(top: 10),
                            /*Text("Or Login With")
                                .text
                                .black
                                .textStyle(CustomTextStyle.caption)
                                .make()
                                .onInkTap(() => context.nextReplacementPage(SignUpScreen()))
                                .p(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  child: CustomButton(buttonText: "Google", buttonBGColor: Colors.red, onTap: () async {}),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: CustomButton(buttonText: "Facebook", buttonBGColor: Colors.indigoAccent, onTap: () async {}),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 20),*/
                            Text(
                              "Don't have an account? SIGN UP",
                              style: context.textTheme.caption,
                            )
                                .onInkTap(
                                    () => context.nextPage(SignUpScreen()))
                                .p(10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer(builder: (ctx, watch, _) {
                final authState = watch(userNotifierProvider.state);
                return Visibility(
                  visible: authState is UserLoadingState,
                  child: Container(
                    color: kLightColor,
                    child: LoadingWidget(),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
