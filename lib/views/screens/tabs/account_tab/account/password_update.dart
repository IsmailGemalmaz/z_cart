import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class PasswordUpdate extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightColor,
      width: context.screenWidth,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Password",
                        style: context.textTheme.headline6
                            .copyWith(color: kDarkColor))
                    .pOnly(bottom: 10),
                ElevatedButton(
                    onPressed: () async {
                      toast("Please wait");
                      if (_formKey.currentState.validate()) {
                        hideKeyboard(context);
                        context.read(userNotifierProvider).updatePassword(
                            oldPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                            confirmPasswordController.text.trim());
                        oldPasswordController.clear();
                        newPasswordController.clear();
                        confirmPasswordController.clear();
                      }
                    },
                    child: Text("Update")),
              ],
            ),
            CustomTextField(
              color: kCardBgColor,
              title: "Old password",
              hintText: "Enter old password",
              isPassword: true,
              controller: oldPasswordController,
              widthMultiplier: 1,
            ),
            CustomTextField(
              color: kCardBgColor,
              title: "New password",
              hintText: "Enter new password",
              isPassword: true,
              controller: newPasswordController,
              widthMultiplier: 1,
            ),
            CustomTextField(
              color: kCardBgColor,
              title: "Confirm password",
              hintText: "Re-enter password",
              isPassword: true,
              controller: confirmPasswordController,
              widthMultiplier: 1,
            ),
          ],
        ).p(10),
      ),
    );
  }
}
