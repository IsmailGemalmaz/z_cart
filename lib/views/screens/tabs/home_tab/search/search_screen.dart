import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/data/controller/search/search_controller.dart';
import 'package:zcart/data/controller/search/search_state.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/views/screens/product_details/product_details_screen.dart';
import 'package:zcart/views/screens/tabs/home_tab/components/error_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/views/shared_widgets/loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            autofocus: true,
            style: TextStyle(color: kPrimaryLightTextColor),
            cursorColor: kDarkColor,
            controller: searchController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Keyword ...",
                hintStyle: TextStyle(color: kPrimaryLightTextColor)),
            onChanged: (value) {
              if (value.length > 3) {
                context.read(searchProvider).search(value);
              }
            },
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => searchController.text.isNotEmpty == true
                  ? context.read(searchProvider).search(searchController.text)
                  : toast('Type something'),
              icon: Icon(CupertinoIcons.search))
        ],
      ),
      body: Consumer(
        builder: (context, watch, _) {
          final searchState = watch(searchProvider.state);

          return searchState is SearchLoadedState
              ? searchState.searchedItem.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: searchState.searchedItem.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: kLightColor,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Image.network(
                              searchState.searchedItem[index].image,
                              errorBuilder: (BuildContext _, Object error,
                                  StackTrace stack) {
                                return Container();
                              },
                            ),
                            title: Text(
                              searchState.searchedItem[index].title,
                            ),
                            onTap: () {
                              context
                                  .read(productNotifierProvider)
                                  .getProductDetails(
                                      searchState.searchedItem[index].slug);
                              context
                                  .read(productSlugListProvider)
                                  .addProductSlug(
                                      searchState.searchedItem[index].slug);
                              context.nextPage(ProductDetailsScreen());
                            },
                          ),
                        ).cornerRadius(10).pOnly(bottom: 10);
                      }).px(10)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.info_outline).pOnly(bottom: 10),
                        Text(
                          'No Item found',
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
              : searchState is SearchLoadingState
                  ? LoadingWidget()
                  : searchState is SearchInitialState
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(Icons.info_outline).pOnly(bottom: 10),
                            Text(
                              'Search for something',
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      : searchState is SearchErrorState
                          ? ErrorMessageWidget(searchState.message)
                          : Container();
        },
      ).p(10),
    );
  }
}
