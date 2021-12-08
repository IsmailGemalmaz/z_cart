import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/views/shared_widgets/custom_button.dart';
import 'package:zcart/views/shared_widgets/custom_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          color: kLightBgColor,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Reset password!",
                  style: context.textTheme.bodyText1,
                ).py(10),
                CustomTextField(
                  controller: _emailController,
                  color: kCardBgColor,
                  title: "Email",
                  hintText: "Email",
                  validator: (value) {
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Invalid email";
                    } else {
                      return null;
                    }
                  },
                  widthMultiplier: 1,
                ).py(10),
                CustomButton(
                    buttonText: "Send reset link",
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        hideKeyboard(context);
                        context
                            .read(userNotifierProvider)
                            .forgotPassword(_emailController.text.trim());
                        context.pop();
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
