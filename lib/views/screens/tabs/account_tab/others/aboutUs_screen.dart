import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:zcart/data/controller/others/about_us_state.dart';
import 'package:zcart/data/controller/others/others_controller.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, watch, _) {
                  final aboutUsState = watch(aboutUsProvider.state);
                  return aboutUsState is AboutUsLoadedState
                      ? HtmlWidget(
                          aboutUsState.aboutUsModel.data.content,
                          webView: true,
                        )
                      : aboutUsState is AboutUsLoadingState
                          ? LoadingWidget()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(Icons.info_outline),
                                const SizedBox(height: 10),
                                Text("No data yet!")
                              ],
                            );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
