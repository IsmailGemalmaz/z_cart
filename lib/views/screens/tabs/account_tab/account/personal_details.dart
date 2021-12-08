import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/helper/get_formated_date.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class PersonalDetails extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController;
  TextEditingController nickNameController;
  TextEditingController bioController;
  TextEditingController emailController;

  DateTime _dateOfBirth;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final userState = watch(userNotifierProvider.state);

      if (userState is UserLoadedState) {
        fullNameController = TextEditingController(text: userState.user.name);
        nickNameController =
            TextEditingController(text: userState.user.niceName);
        bioController = TextEditingController(text: userState.user.description);
        emailController = TextEditingController(text: userState.user.email);
        _dateOfBirth = getDateFormatedFromString(userState.user.dob);

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
                    Text("Basic Info",
                            style: context.textTheme.headline6
                                .copyWith(color: kDarkColor))
                        .pOnly(bottom: 10),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            hideKeyboard(context);
                            await context
                                .read(userNotifierProvider)
                                .updateUserInfo(
                                  fullNameController.text.trim(),
                                  nickNameController.text.trim(),
                                  bioController.text.trim(),
                                  emailController.text.trim(),
                                  getDateFormatedToString(_dateOfBirth),
                                );
                            await context
                                .read(userNotifierProvider)
                                .getUserInfo();
                          }
                        },
                        child: Text("Update")),
                  ],
                ),
                CustomTextField(
                  color: kCardBgColor,
                  title: "Full name",
                  hintText: "Full name",
                  controller: fullNameController,
                  widthMultiplier: 1,
                ),
                CustomTextField(
                  color: kCardBgColor,
                  title: "Nick name",
                  hintText: "Nick name",
                  controller: nickNameController,
                  widthMultiplier: 1,
                ),
                CustomTextField(
                  color: kCardBgColor,
                  title: "Email",
                  hintText: "Email",
                  controller: emailController,
                  validator: (value) {
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Invalid email";
                    } else
                      return null;
                  },
                  widthMultiplier: 1,
                ),
                CustomTextField(
                  color: kCardBgColor,
                  title: "Bio",
                  hintText: "Bio",
                  controller: bioController,
                  widthMultiplier: 1,
                  minLines: 1,
                  maxLines: null,
                ),
                CustomDateTimeField(
                  title: "Date of birth",
                  color: kCardBgColor,
                  widthMultiplier: 1,
                  hintText: "Date of birth",
                  initialDate: _dateOfBirth,
                  onTextChanged: (date) {
                    _dateOfBirth = date;
                  },
                )
              ],
            ).p(10),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
