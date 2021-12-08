import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:zcart/riverpod/providers/provider.dart';
import 'package:zcart/riverpod/state/state.dart';
import 'package:zcart/views/shared_widgets/address_list_widget.dart';
import 'package:zcart/views/shared_widgets/dropdown_field_loading_widget.dart';

import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/views/shared_widgets/shared_widgets.dart';

import 'add_address_screen.dart';
import 'password_update.dart';
import 'personal_details.dart';

class AccountDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Details")),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Personal Details
                  PersonalDetails().cornerRadius(10).p(10),

                  /// Password
                  PasswordUpdate().cornerRadius(10).p(10),

                  /// Address
                  AddressList().cornerRadius(10).p(10),
                ],
              ),
            ),
            Consumer(builder: (context, watch, _) {
              final userState = watch(userNotifierProvider.state);
              return Visibility(
                  visible: userState is UserLoadingState,
                  child:
                      Container(color: kLightBgColor, child: LoadingWidget()));
            })
          ],
        ),
      ),
    );
  }
}

class AddressList extends StatelessWidget {
  const AddressList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightColor,
      width: context.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Address",
                      style: context.textTheme.headline6
                          .copyWith(color: kDarkColor))
                  .pOnly(bottom: 10),
              ElevatedButton(
                  onPressed: () => context.nextPage(AddNewAddressScreen()),
                  child: Text("New Address")),
            ],
          ),
          Consumer(
            builder: (context, watch, _) {
              final addressState = watch(addressNotifierProvider.state);
              final cartItemDetailsState =
                  watch(cartItemDetailsNotifierProvider.state);

              return addressState is AddressLoadedState
                  ? addressState.addresses == null
                      ? Container()
                      : addressState.addresses.length == 0
                          ? Container()
                          : cartItemDetailsState is CartItemDetailsLoadedState
                              ? AddressListBuilder(
                                  addressesList: addressState.addresses)
                              : AddressListBuilder(
                                  addressesList: addressState.addresses)
                  : addressState is AddressLoadingState
                      ? FieldLoading().py(5)
                      : Container();
            },
          )
        ],
      ).p(10),
    );
  }
}
