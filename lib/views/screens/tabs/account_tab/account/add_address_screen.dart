import 'package:nb_utils/nb_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zcart/Theme/styles/colors.dart';
import 'package:zcart/riverpod/providers/address_provider.dart';
import 'package:zcart/riverpod/state/address/country_state.dart';
import 'package:zcart/riverpod/state/address/states_state.dart';
import 'package:zcart/views/shared_widgets/custom_dropdownfield.dart';
import 'package:zcart/views/shared_widgets/custom_textfield.dart';
import 'package:zcart/views/shared_widgets/dropdown_field_loading_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isAccessed;
  const AddNewAddressScreen({
    Key key,
    this.isAccessed = true,
  }) : super(key: key);
  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController addressTypeController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController statesController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  int selectedCountryID;

  int selectedStateID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:
          AppBar(title: Text("Add Address"), centerTitle: true, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  color: kLightColor,
                  width: context.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.isAccessed
                          ? CustomDropDownField(
                              title: "Address type",
                              optionsList: ["Primary", "Billing", "Shipping"],
                              value: "Select",
                              controller: addressTypeController,
                              widthMultiplier: 1,
                              validator: (text) {
                                if (text == null ||
                                    text.isEmpty ||
                                    text == "") {
                                  return 'Address type can\'t be empty';
                                }
                                return null;
                              },
                            )
                          : SizedBox(),
                      CustomTextField(
                        color: kCardBgColor,
                        title: "Contact person",
                        hintText: "Contact person",
                        controller: contactPersonController,
                        widthMultiplier: 1,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        color: kCardBgColor,
                        title: "Contact number",
                        hintText: "Contact number",
                        controller: contactNumberController,
                        widthMultiplier: 1,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Contact number can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      Consumer(
                        builder: (context, watch, _) {
                          final countryState =
                              watch(countryNotifierProvider.state);

                          return countryState is CountryLoadedState
                              ? CustomDropDownField(
                                  title: "Country",
                                  optionsList: countryState.countryList
                                      .map((e) => e.name)
                                      .toList(),
                                  //value: "Select",
                                  controller: countryController,
                                  widthMultiplier: 1,
                                  isCallback: true,
                                  callbackFunction: (int countryId) {
                                    selectedCountryID =
                                        countryState.countryList[countryId].id;
                                    context
                                        .read(statesNotifierProvider)
                                        .getState(countryState
                                            .countryList[countryId].id);
                                  },
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please select a country';
                                    }
                                    return null;
                                  },
                                )
                              : countryState is CountryLoadingState
                                  ? FieldLoading()
                                  : Container();
                        },
                      ),
                      Consumer(
                        builder: (context, watch, _) {
                          final statesState =
                              watch(statesNotifierProvider.state);
                          if (statesState is StatesLoadedState) {
                            selectedStateID = statesState.statesList.length == 0
                                ? null
                                : statesState.statesList[0].id;
                          }
                          return statesState is StatesLoadedState
                              ? CustomDropDownField(
                                  title: "States",
                                  optionsList:
                                      statesState.statesList.length == 0
                                          ? ["Select"]
                                          : statesState.statesList
                                              .map((e) => e.name)
                                              .toList(),
                                  //value: "Select",
                                  controller: statesController,
                                  widthMultiplier: 1,
                                  isCallback: true,
                                  callbackFunction: (int stateId) {
                                    selectedStateID =
                                        statesState.statesList[stateId].id;
                                  },
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please select a state';
                                    }
                                    return null;
                                  },
                                )
                              : statesState is StatesLoadingState
                                  ? FieldLoading()
                                  : Container();
                        },
                      ),
                      CustomTextField(
                        color: kCardBgColor,
                        title: "Zip code",
                        hintText: "Enter zip code",
                        controller: zipCodeController,
                        widthMultiplier: 1,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Zip code can\'t be empty';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                          color: kCardBgColor,
                          title: "Address line 1",
                          hintText: "Enter address",
                          controller: addressLine1Controller,
                          widthMultiplier: 1,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              if (addressLine2Controller.text == null ||
                                  addressLine2Controller.text.isEmpty) {
                                return 'Address field can\'t be empty';
                              }
                            }
                            return null;
                          }),
                      CustomTextField(
                        color: kCardBgColor,
                        title: "Address line 2",
                        hintText: "Enter address",
                        controller: addressLine2Controller,
                        widthMultiplier: 1,
                        validator: (text) {
                          if (addressLine1Controller.text == null ||
                              addressLine1Controller.text.isEmpty) {
                            if (text == null || text.isEmpty) {
                              return 'Address field can\'t be empty';
                            }
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        color: kCardBgColor,
                        title: "City",
                        hintText: "City",
                        controller: cityController,
                        widthMultiplier: 1,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please give a city name';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  toast("Please wait",
                                      gravity: ToastGravity.CENTER,
                                      bgColor: kPrimaryColor);
                                  context
                                      .read(addressNotifierProvider)
                                      .createAddress(
                                        addressType: addressTypeController
                                                        .text ==
                                                    null ||
                                                addressTypeController
                                                    .text.isEmpty ||
                                                addressTypeController.text == ""
                                            ? "Shipping"
                                            : addressTypeController.text,
                                        contactPerson:
                                            contactPersonController.text,
                                        contactNumber:
                                            contactNumberController.text,
                                        countryId: selectedCountryID == null
                                            ? 4.toString()
                                            : selectedCountryID.toString(),
                                        stateId: selectedStateID.toString(),
                                        cityId: cityController.text,
                                        addressLine1:
                                            addressLine1Controller.text,
                                        addressLine2:
                                            addressLine2Controller.text,
                                        zipCode: zipCodeController.text,
                                      );
                                  context.pop();
                                }
                              },
                              child: Text("Add Address")),
                        ],
                      ),
                    ],
                  ).p(10),
                ).cornerRadius(10).p(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}