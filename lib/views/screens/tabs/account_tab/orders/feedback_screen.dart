import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/data/controller/feedback/feedback_controller.dart';
import 'package:zcart/data/models/orders/order_details_model.dart';
import 'package:zcart/riverpod/providers/order_provider.dart';
import 'package:zcart/views/shared_widgets/custom_textfield.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackScreen extends StatefulWidget {
  final Order order;

  FeedbackScreen({this.order});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productFormKey = GlobalKey<FormState>();
  TextEditingController shopRatingController = TextEditingController();
  TextEditingController shopCommentController = TextEditingController();

  List<int> listingIdList = [];

  List<int> ratingList = [];

  List<String> feedbackList = [];

  updateListingIdList({int index, int listingId}) {
    if (listingIdList.isEmpty) {
      listingIdList.insert(index, listingId);
    } else if (index <= listingIdList.length - 1) {
      listingIdList[index] = listingId;
    } else {
      listingIdList.insert(index, listingId);
    }
  }

  updateRatingList({int index, double rating}) {
    updateListingIdList(index: index, listingId: widget.order.items[index].id);
    if (ratingList.isEmpty) {
      ratingList.insert(index, rating.toInt());
    } else if (index <= ratingList.length - 1) {
      ratingList[index] = rating.toInt();
    } else {
      ratingList.insert(index, rating.toInt());
    }
  }

  updateFeedbackList({int index, String feedback}) {
    updateListingIdList(index: index, listingId: widget.order.items[index].id);
    if (feedbackList.isEmpty) {
      feedbackList.insert(index, feedback);
    } else if (index <= feedbackList.length - 1) {
      feedbackList[index] = feedback;
    } else {
      feedbackList.insert(index, feedback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Evaluation"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (_productFormKey.currentState.validate()) {
                    if (listingIdList.length == widget.order.items.length &&
                        feedbackList.length == widget.order.items.length) {
                      context
                          .read(sellerFeedbackProvider)
                          .postFeedback(
                            widget.order.id,
                            shopRatingController.text,
                            shopCommentController.text,
                          )
                          .then((value) => context
                              .read(productFeedbackProvider)
                              .postFeedback(
                                widget.order.id,
                                listingIdList,
                                ratingList,
                                feedbackList,
                              ))
                          .then((value) => context
                                  .read(ordersProvider)
                                  .orders(ignoreLoadingState: false)
                                  .then((value) {
                                context.pop();
                                context.pop();
                              }));
                    }
                  } else {
                    toast('Please rate all product', bgColor: kPrimaryColor);
                  }
                }
              },
              child: Text('Submit'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Rate Seller
            Container(
              decoration: BoxDecoration(
                  color: kLightColor, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rate Seller", style: context.textTheme.subtitle2)
                        .py(5),
                    Row(
                      children: [
                        Image.network(widget.order.shop.image, errorBuilder:
                                (BuildContext _, Object error,
                                    StackTrace stack) {
                          return Container();
                        }, height: 50, width: 50)
                            .p(10),
                        Text(widget.order.shop.name,
                            style: context.textTheme.subtitle2),
                      ],
                    ),
                    Container(
                      color: kPrimaryColor.withOpacity(0.2),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBar.builder(
                            initialRating: double.parse('0.00'),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25,
                            itemPadding: EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (context, _) =>
                                Icon(Icons.star_border, color: kPrimaryColor),
                            onRatingUpdate: (rating) {
                              shopRatingController.text = '$rating';
                            },
                          ),
                        ],
                      ),
                    ).cornerRadius(10),
                    CustomTextField(
                      title: "Write a feedback",
                      hintText: "Write about your experience",
                      widthMultiplier: 1,
                      validator: (value) {
                        if (value.length < 10) {
                          return "Comment Must Be 10 Characters";
                        } else if (value.length > 250) {
                          return "Comment Must Be Less Than 250 Characters";
                        }
                        return null;
                      },
                      maxLines: null,
                      controller: shopCommentController,
                    ),
                  ],
                ),
              ),
            ),

            /// Rate Product
            Container(
              decoration: BoxDecoration(
                  color: kLightColor, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              child: Form(
                key: _productFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rate Product(s)", style: context.textTheme.subtitle2)
                        .py(5),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.order.items.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, index) {
                          return ProductRatingCard(
                            order: widget.order,
                            index: index,
                            updateRatingList: updateRatingList,
                            updateFeedbackList: updateFeedbackList,
                          );
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProductRatingCard extends StatelessWidget {
  ProductRatingCard({
    @required this.order,
    @required this.index,
    @required this.updateRatingList,
    @required this.updateFeedbackList,
  });

  final Order order;
  final int index;
  final void Function({int index, double rating}) updateRatingList;
  final void Function({int index, String feedback}) updateFeedbackList;

  TextEditingController productFeedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.network(
            order.items[index].image,
            errorBuilder: (BuildContext _, Object error, StackTrace stack) {
              return Container();
            },
          ),
          title: Text(order.items[index].description),
          subtitle: Text(
            order.items[index].unitPrice,
            style: context.textTheme.subtitle2.copyWith(color: kPrimaryColor),
          ),
          trailing: Text('x ' + order.items[index].quantity.toString()),
        ),
        Container(
          color: kPrimaryColor.withOpacity(0.2),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: double.parse('0.00'),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 25,
                itemPadding: EdgeInsets.symmetric(horizontal: 5),
                itemBuilder: (context, _) =>
                    Icon(Icons.star_border, color: kPrimaryColor),
                onRatingUpdate: (rating) =>
                    updateRatingList(index: index, rating: rating),
              ),
            ],
          ),
        ).cornerRadius(10),
        CustomTextField(
          title: "Write a feedback",
          hintText: "Write about your experience",
          widthMultiplier: 1,
          maxLines: null,
          controller: productFeedbackController,
          validator: (value) {
            if (value.length < 10) {
              return "Comment Must Be 10 Characters";
            } else if (value.length > 250) {
              return "Comment Must Be Less Than 250 Characters";
            }
            return null;
          },
          onChanged: (feedback) {
            updateFeedbackList(index: index, feedback: feedback);
          },
        ).pOnly(bottom: 10),
      ],
    );
  }
}
