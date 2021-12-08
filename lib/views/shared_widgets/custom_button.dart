import 'package:flutter/material.dart';
import 'package:zcart/Theme/styles/colors.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String buttonText;

  final Color buttonBGColor;
  final double widthMultiplier;

  CustomButton({
    this.onTap,
    this.buttonText = "Update",
    this.buttonBGColor = kPrimaryColor,
    this.widthMultiplier = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width * widthMultiplier,
        decoration: BoxDecoration(
          color: buttonBGColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        height: 50.0,
        child: Center(
          child:
              Text(buttonText, style: TextStyle(color: kPrimaryLightTextColor)),
        ),
      ),
    );
  }
}
