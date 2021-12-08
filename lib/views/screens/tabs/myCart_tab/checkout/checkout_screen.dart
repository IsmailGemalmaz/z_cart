import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/data/controller/cart/coupon_controller.dart';
import 'package:zcart/data/models/address/shipping_model.dart';
import 'package:zcart/data/models/cart/cart_item_details_model.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:zcart/riverpod/providers/address_provider.dart';
import 'package:zcart/riverpod/providers/checkout_provider.dart';
import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/address/address_state.dart';
import 'package:zcart/riverpod/state/cart_state.dart';
import 'package:zcart/riverpod/state/checkout_state.dart';
import 'package:zcart/views/screens/tabs/account_tab/account/add_address_screen.dart';
import 'package:zcart/views/shared_widgets/address_list_widget.dart';
import 'package:zcart/views/shared_widgets/custom_textfield.dart';
import 'package:zcart/views/shared_widgets/dropdown_field_loading_widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  //Conditions
  int _selectedAddressIndex;
  int _selectedShippingOptionsIndex;
  int _selectedPackagingIndex;
  int _selectedPaymentIndex;

  /// Coupon
  bool showApplyButton = false;
  TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProviderListener<CheckoutState>(
      provider: checkoutNotifierProvider.state,
      onChange: (context, state) {
        if (state is CheckoutLoadedState) {
          toast("Successfully placed order",
              bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
          context.pop();
        }
      },
      child: ProviderListener<CartItemDetailsState>(
        provider: cartItemDetailsNotifierProvider.state,
        onChange: (context, state) {
          if (state is CartItemDetailsLoadedState) {
            context.read(checkoutNotifierProvider).cartId =
                state.cartItemDetails.id;
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Checkout"),
            ),
            body: Consumer(builder: (context, watch, _) {
              final cartItemDetailsState =
                  watch(cartItemDetailsNotifierProvider.state);

              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                            accentColor: kAccentColor,
                            colorScheme:
                                ColorScheme.light(primary: kPrimaryColor)),
                        child: Stepper(
                          type: StepperType.vertical,
                          physics: ScrollPhysics(),
                          currentStep: _currentStep,
                          onStepTapped: (step) => tapped(step),
                          onStepContinue: continued,
                          onStepCancel: cancel,
                          steps: <Step>[
                            /// Shipping
                            _shipping(context, cartItemDetailsState),

                            /// Order options
                            _orderOptions(cartItemDetailsState),

                            /// Place order
                            _placeOrder(cartItemDetailsState, context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }

  Step _placeOrder(
      CartItemDetailsState cartItemDetailsState, BuildContext context) {
    return Step(
      title: new Text('Place Order'),
      content: Container(
        color: kLightColor,
        padding: EdgeInsets.all(10),
        child: cartItemDetailsState is CartItemDetailsLoadedState
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          cartItemDetailsState.cartItemDetails.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            cartItemDetailsState
                                .cartItemDetails.items[index].image,
                            errorBuilder: (BuildContext _, Object error,
                                StackTrace stack) {
                              return Container();
                            },
                          ),
                          title: Text(cartItemDetailsState
                              .cartItemDetails.items[index].description),
                          subtitle: Text(
                            cartItemDetailsState
                                .cartItemDetails.items[index].unitPrice,
                            style: context.textTheme.subtitle2
                                .copyWith(color: kPrimaryColor),
                          ),
                          trailing: Text('x ' +
                              cartItemDetailsState
                                  .cartItemDetails.items[index].quantity
                                  .toString()),
                        );
                      }),
                  Text('\nOrder Summary\n', style: context.textTheme.subtitle2),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Sub total: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  cartItemDetailsState.cartItemDetails.total,
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Discount: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  cartItemDetailsState.cartItemDetails.discount,
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Packaging: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  cartItemDetailsState
                                      .cartItemDetails.packaging,
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Shipping: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  cartItemDetailsState.cartItemDetails.shipping,
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Handling: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  cartItemDetailsState.cartItemDetails.handling,
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Taxes: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  '${cartItemDetailsState.cartItemDetails.taxes} (${cartItemDetailsState.cartItemDetails.taxrate})',
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2, child: Text("Grand total: ")),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  cartItemDetailsState
                                      .cartItemDetails.grandTotal,
                                  style: context.textTheme.subtitle2)),
                        ],
                      ),
                    ],
                  ).pOnly(bottom: 10),
                  CustomTextField(
                    color: kCardBgColor,
                    title: "Apply Coupon",
                    hintText: "Enter coupon code",
                    controller: couponController,
                    onChanged: (value) {
                      if (!showApplyButton) {
                        setState(() {
                          showApplyButton = true;
                        });
                      }
                    },
                  ),
                  Visibility(
                    visible: showApplyButton,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            context
                                .read(applyCouponProvider)
                                .applyCoupon(
                                    cartItemDetailsState.cartItemDetails.id,
                                    couponController.text)
                                .then((value) => context
                                    .read(cartItemDetailsNotifierProvider)
                                    .getCartItemDetails(cartItemDetailsState
                                        .cartItemDetails.id));
                          },
                          child: Text('Apply',
                              style: TextStyle(color: kPrimaryColor)),
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    color: kCardBgColor,
                    title: "Buyers Note",
                    hintText: "Note for seller",
                    maxLines: null,
                    onChanged: (value) => (value != null)
                        ? context.read(checkoutNotifierProvider).buyerNote =
                            value
                        : null,
                  ).pOnly(bottom: 5),
                ],
              )
            : Container(),
      ).cornerRadius(10),
      isActive: _currentStep >= 0,
      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
    );
  }

  Step _orderOptions(CartItemDetailsState cartItemDetailsState) {
    return Step(
      title: new Text('Order Options'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text('Shipping Options', style: context.textTheme.bodyText2),
            ],
          ).pOnly(bottom: 10),
          Consumer(
            builder: (context, watch, _) {
              final shippingState = watch(shippingNotifierProvider.state);
              return shippingState is ShippingLoadedState
                  ? cartItemDetailsState is CartItemDetailsLoadedState
                      ? shippingState.shippingOptions.length != 0
                          ? ShippingOptionsBuilder(
                              shippingOptions: shippingState.shippingOptions,
                              cartItem: cartItemDetailsState.cartItemDetails,
                              onPressedCheckBox: (value) {
                                setState(() {
                                  _selectedShippingOptionsIndex = value;
                                });
                              },
                            ).cornerRadius(10)
                          : Container(
                              color: kLightColor,
                              padding: EdgeInsets.all(10),
                              width: context.screenWidth,
                              child: Column(
                                children: [
                                  Icon(Icons.info_outline).pOnly(bottom: 5),
                                  Text(
                                    "Seller does not deliver to this area. You can choose from other sellers.",
                                    textAlign: TextAlign.center,
                                  ).pOnly(bottom: 5)
                                ],
                              ),
                            ).cornerRadius(10)
                      : ShippingOptionsBuilder(
                              shippingOptions: shippingState.shippingOptions)
                          .cornerRadius(10)
                  : Container();
            },
          ),
          Row(
            children: [
              Text('Packaging', style: context.textTheme.bodyText2),
            ],
          ).pOnly(top: 10, bottom: 10),
          Container(
            color: kLightColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: cartItemDetailsState is CartItemDetailsLoadedState
                ? PackagingListBuilder(
                    cartItem: cartItemDetailsState.cartItemDetails,
                    onPressedCheckBox: (value) {
                      setState(() {
                        _selectedPackagingIndex = value;
                      });
                    },
                  )
                : PackagingListBuilder(),
          ).cornerRadius(10),
          Row(
            children: [
              Text('Payment', style: context.textTheme.bodyText2),
            ],
          ).pOnly(top: 10, bottom: 10),
          PaymentOptionsListBuilder(
            onPressedCheckBox: (value) {
              setState(() {
                _selectedPaymentIndex = value;
              });
            },
          ).cornerRadius(10)
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step _shipping(
      BuildContext context, CartItemDetailsState cartItemDetailsState) {
    return Step(
      title: new Text('Shipping'),
      content: Column(
        children: <Widget>[
          Row(
            children: [
              Text('Select Shipping Address',
                  style: context.textTheme.subtitle1),
            ],
          ).pOnly(bottom: 10),
          Container(
            color: kLightColor,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.add_circle_outlined, color: kPrimaryColor)
                    .pOnly(right: 10),
                Text("Add Address", style: context.textTheme.subtitle2)
              ],
            ),
          ).onInkTap(() {
            context.read(countryNotifierProvider).getCountries();
            context.read(statesNotifierProvider).resetState();
            context.nextPage(AddNewAddressScreen(
              isAccessed: false,
            ));
          }).cornerRadius(10),
          Consumer(
            builder: (context, watch, _) {
              final addressState = watch(addressNotifierProvider.state);

              return addressState is AddressLoadedState
                  ? addressState.addresses == null
                      ? Container()
                      : addressState.addresses.length == 0
                          ? Container()
                          : cartItemDetailsState is CartItemDetailsLoadedState
                              ? AddressListBuilder(
                                  addressesList: addressState.addresses,
                                  cartItem:
                                      cartItemDetailsState.cartItemDetails,
                                  onPressedCheckBox: (value) {
                                    setState(() {
                                      _selectedAddressIndex = value;
                                    });
                                  },
                                )
                              : AddressListBuilder(
                                  addressesList: addressState.addresses)
                  : addressState is AddressLoadingState
                      ? FieldLoading().py(5)
                      : addressState is AddressErrorState
                          ? ListTile(
                              title: Text(addressState.message,
                                  style: TextStyle(color: kPrimaryColor)),
                              leading: Icon(Icons.dangerous),
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                            )
                          : addressState is AddressInitialState
                              ? Container()
                              : Container();
            },
          )
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 0 && _selectedAddressIndex == null) {
      toast("Select a shipping address to continue",
          bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
    } else if (_currentStep == 1 && _selectedShippingOptionsIndex == null) {
      toast("Select a shipping option to continue",
          bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
    } else if (_currentStep == 1 && _selectedPackagingIndex == null) {
      toast("Select a packaging method to continue",
          bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
    } else if (_currentStep == 1 && _selectedPaymentIndex == null) {
      toast("Select a payment method to continue",
          bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
    } else if (_currentStep == 2) {
      if (!accessAllowed) {
        toast("Please wait - Guest Checkout",
            bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
        context.read(checkoutNotifierProvider).guestCheckout();
      } else {
        toast("Please wait",
            bgColor: kPrimaryColor, gravity: ToastGravity.CENTER);
        context.read(checkoutNotifierProvider).checkout();
      }
    } else if (_currentStep < 2) setState(() => _currentStep += 1);
  }

  cancel() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }
}

class PaymentOptionsListBuilder extends StatefulWidget {
  final Function(int) onPressedCheckBox;
  const PaymentOptionsListBuilder({
    Key key,
    this.onPressedCheckBox,
  }) : super(key: key);
  @override
  _PaymentOptionsListBuilderState createState() =>
      _PaymentOptionsListBuilderState();
}

class _PaymentOptionsListBuilderState extends State<PaymentOptionsListBuilder> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Consumer(
        builder: (context, watch, _) {
          final paymentOptionsState =
              watch(paymentOptionsNotifierProvider.state);
          return paymentOptionsState is PaymentOptionsLoadedState
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: paymentOptionsState.paymentOptions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        widget.onPressedCheckBox(index);
                        context.read(checkoutNotifierProvider).paymentMethodId =
                            paymentOptionsState.paymentOptions[index].id;
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      title:
                          Text(paymentOptionsState.paymentOptions[index].name),
                      //subtitle: Text(paymentOptionsState.paymentOptions[index].name),
                      trailing: index == selectedIndex
                          ? Icon(Icons.check_circle, color: kPrimaryColor)
                          : Icon(Icons.radio_button_unchecked),
                    );
                  })
              : Container();
        },
      ),
    );
  }
}

class PackagingListBuilder extends StatefulWidget {
  final CartItemDetails cartItem;
  final Function(int) onPressedCheckBox;

  const PackagingListBuilder({Key key, this.cartItem, this.onPressedCheckBox})
      : super(key: key);

  @override
  _PackagingListBuilderState createState() => _PackagingListBuilderState();
}

class _PackagingListBuilderState extends State<PackagingListBuilder> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final packagingState = watch(packagingNotifierProvider.state);
        return packagingState is PackagingLoadedState
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: packagingState.packagingList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      widget.onPressedCheckBox(index);
                      context.read(cartItemDetailsNotifierProvider).updateCart(
                          widget.cartItem.id,
                          packagingId: packagingState.packagingList[index].id);
                      context.read(checkoutNotifierProvider).packagingId =
                          packagingState.packagingList[index].id;
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    title: Text(packagingState.packagingList[index].cost
                        .substring(
                            0,
                            (packagingState.packagingList[index].cost
                                    .indexOf('.') +
                                3))),
                    subtitle: Text(packagingState.packagingList[index].name),
                    trailing: index == selectedIndex
                        ? Icon(Icons.check_circle, color: kPrimaryColor)
                        : Icon(Icons.radio_button_unchecked),
                  );
                })
            : Container();
      },
    );
  }
}

class ShippingOptionsBuilder extends StatefulWidget {
  const ShippingOptionsBuilder({
    Key key,
    @required this.shippingOptions,
    this.cartItem,
    this.onPressedCheckBox,
  }) : super(key: key);

  final List<ShippingOptions> shippingOptions;
  final CartItemDetails cartItem;
  final Function(int) onPressedCheckBox;

  @override
  _ShippingOptionsBuilderState createState() => _ShippingOptionsBuilderState();
}

class _ShippingOptionsBuilderState extends State<ShippingOptionsBuilder> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.shippingOptions.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                widget.onPressedCheckBox(index);
                context.read(cartItemDetailsNotifierProvider).updateCart(
                    widget.cartItem.id,
                    shippingZoneId:
                        widget.shippingOptions[index].shippingZoneId,
                    shippingOptionId: widget.shippingOptions[index].id);
                context.read(checkoutNotifierProvider).shippingOptionId =
                    widget.shippingOptions[index].id;

                setState(() {
                  selectedIndex = index;
                });
              },
              title: Text(
                widget.shippingOptions[index].name,
              ).pOnly(bottom: 5),
              trailing: Text(
                widget.shippingOptions[index].cost,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shippingOptions[index].carrierName,
                  ),
                  Text(
                    widget.shippingOptions[index].deliveryTakes.substring(25),
                  ),
                ],
              ).pOnly(right: 10),
              leading: index == selectedIndex
                  ? Icon(Icons.check_circle, color: kPrimaryColor)
                  : Icon(Icons.radio_button_unchecked),
            );
          }),
    );
  }
}
