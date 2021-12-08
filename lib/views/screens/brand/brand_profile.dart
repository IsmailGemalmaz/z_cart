import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/data/models/brand/brand_profile_model.dart';
import 'package:zcart/riverpod/providers/brand_provider.dart';
import 'package:zcart/riverpod/state/brand_state.dart';
import 'package:zcart/views/screens/brand/brand_items_list.dart';
import 'package:zcart/views/shared_widgets/product_loading_widget.dart';

class BrandProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final brandProfileState = watch(brandProfileNotifierProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text("Brand Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            brandProfileState is BrandProfileLoadedState
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: context.screenHeight * .30,
                        width: context.screenWidth,
                        child: Image.network(
                          brandProfileState.brandProfile.data.coverImage,
                          errorBuilder:
                              (BuildContext _, Object error, StackTrace stack) {
                            return Container();
                          },
                          fit: BoxFit.cover,
                        ),
                      ),

                      //Name
                      ListTile(
                        title: Text(
                          brandProfileState.brandProfile.data.name,
                          style: context.textTheme.headline6
                              .copyWith(color: kPrimaryColor),
                        ),
                        leading: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          width: context.screenWidth * .10,
                          child: Image.network(
                            brandProfileState.brandProfile.data.image,
                            errorBuilder: (BuildContext _, Object error,
                                StackTrace stack) {
                              return Container();
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ).p(10),

                      Container(
                        color: kLightColor,
                        child: Column(
                          children: [
                            BrandDetailsRowItem(
                              title: "Origin",
                              value:
                                  brandProfileState.brandProfile.data.origin ??
                                      "Not available",
                            ).py(5),
                            BrandDetailsRowItem(
                              title: "Available from",
                              value: brandProfileState
                                      .brandProfile.data.availableFrom ??
                                  "Not available",
                            ).py(5),
                            BrandDetailsRowItem(
                              title: "Url",
                              value: brandProfileState.brandProfile.data.url ??
                                  "Not available",
                            ).py(5),
                            BrandDetailsRowItem(
                              title: "Product count",
                              value: brandProfileState
                                      .brandProfile.data.listingCount ??
                                  "Not available",
                            ).py(5),
                          ],
                        ).px(16).py(10),
                      ).cornerRadius(10).py(5).px(10),

                      BrandDescription(
                              brandProfile: brandProfileState.brandProfile)
                          .cornerRadius(10)
                          .py(5)
                          .px(10),

                      BrandItemsListView(),
                    ],
                  )
                : brandProfileState is BrandProfileLoadingState ||
                        brandProfileState is BrandProfileInitialState
                    ? Container(
                        child: ProductLoadingWidget(),
                      ).px(10)
                    : brandProfileState is BrandProfileErrorState
                        ? Container(
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.info_outline),
                                  Text("Something went wrong!"),
                                ],
                              ),
                            ),
                          ).px(10)
                        : Container(),
          ],
        ),
      ),
    );
  }
}

class BrandDescription extends StatefulWidget {
  const BrandDescription({
    Key key,
    @required this.brandProfile,
  }) : super(key: key);

  final BrandProfile brandProfile;

  @override
  _BrandDescriptionState createState() => _BrandDescriptionState();
}

class _BrandDescriptionState extends State<BrandDescription> {
  int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: kLightColor,
      child: ListTile(
        title: Text("Description").py(5),
        onTap: () {
          setState(() {
            _maxLines = _maxLines > 3 ? 3 : 99999;
          });
        },
        subtitle: Text(
          widget.brandProfile.data.description,
          maxLines: _maxLines,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.subtitle2,
        ),
      ),
    );
  }
}

class BrandDetailsRowItem extends StatelessWidget {
  BrandDetailsRowItem({@required this.title, @required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title  :  ",
          style: context.textTheme.subtitle2,
        ),
        Flexible(
          child: SelectableText(
            value,
            style: context.textTheme.subtitle2,
          ),
        )
      ],
    );
  }
}
