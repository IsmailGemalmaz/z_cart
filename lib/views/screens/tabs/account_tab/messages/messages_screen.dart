import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/controller/chat/chat_controller.dart';
import 'package:zcart/data/controller/chat/chat_state.dart';

import 'package:zcart/views/screens/tabs/account_tab/messages/vendor_chat_screen.dart';
import 'package:zcart/views/shared_widgets/loading_widget.dart';
import 'package:zcart/Theme/styles/colors.dart';

import 'package:velocity_x/velocity_x.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final conversationState = watch(conversationProvider.state);
        return Scaffold(
            appBar: AppBar(
              title: Text("Messages"),
              centerTitle: true,
              elevation: 0,
            ),
            body: conversationState is ConversationLoadedState
                ? conversationState.conversationModel.data.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline),
                            const SizedBox(height: 10),
                            Text('Empty inbox!')
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            conversationState.conversationModel.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
                              leading: Image.network(
                                conversationState
                                    .conversationModel.data[index].shop.image,
                                errorBuilder: (BuildContext _, Object error,
                                    StackTrace stack) {
                                  return Container();
                                },
                                width: context.screenWidth * 0.20,
                                fit: BoxFit.cover,
                              ).p(5),
                              title: Text(
                                  conversationState
                                      .conversationModel.data[index].shop.name,
                                  style: context.textTheme.bodyText2
                                      .copyWith(color: kPrimaryColor)),
                              trailing: Icon(CupertinoIcons.chevron_forward),
                            ),
                          ).onInkTap(() async {
                            print(conversationState
                                .conversationModel.data[index].shop.name);

                            context.nextPage(VendorChatScreen(
                                shopId: conversationState
                                    .conversationModel.data[index].shop.id,
                                shopImage: conversationState
                                    .conversationModel.data[index].shop.image,
                                shopName: conversationState
                                    .conversationModel.data[index].shop.name,
                                shopVerifiedText: conversationState
                                    .conversationModel
                                    .data[index]
                                    .shop
                                    .verifiedText));
                            await context
                                .read(productChatProvider)
                                .productConversation(
                                  conversationState
                                      .conversationModel.data[index].shop.id,
                                );
                          });
                        }).pOnly(top: 5)
                : Center(child: LoadingWidget()));
      },
    );
  }
}
