import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/Theme/light_theme.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/data/network/api.dart';
import 'package:zcart/riverpod/providers/logger_provider.dart';
import 'views/screens/startup/loading_screen.dart';

void main() {
  runApp(ProviderScope(observers: [Logger()], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: API.APP_NAME,
      theme: lightTheme.copyWith(
          textTheme: lightTextTheme(context),
          appBarTheme: appBarTheme.copyWith(
            textTheme: lightTextTheme(context).copyWith(
              headline6: TextStyle(
                  color: kPrimaryLightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )),
      home: LoadingScreen(),
    );
  }
}
