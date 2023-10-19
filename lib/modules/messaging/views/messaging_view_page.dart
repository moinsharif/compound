import 'package:compound/modules/messaging/flutter_chat/screens/chat.dart';
import 'package:compound/modules/messaging/viewmodels/messaging_view_model.dart';
import 'package:compound/modules/messaging/views/messaging_list_item_view.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/ui/widgets/creation_aware_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class MessagingViewPage extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessagingViewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => launchDirectChat(context));
  }

  void launchDirectChat(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as dynamic;
    if (args == null || args["peer"] == null) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(
          currentUserId: args["peer"]["owner"],
          peerId: args["peer"]["id"],
          peerName: args["peer"]["nickname"],
          peerAvatar: args["peer"]["photoUrl"]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as dynamic;
    return ViewModelBuilder<MessagingViewModel>.reactive(
        viewModelBuilder: () => MessagingViewModel(),
        onModelReady: (model) => model.load(args != null ? args["peer"] : null),
        builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                color: AppTheme.instance.primaryDarker,
                child: model.busy
                    ? Center(child: CircularProgressIndicator())
                    : model.items == null || model.items.length == 0
                        ? Center(
                            child: Text(
                            model.getEmptyMessage(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            itemCount: model.items.length,
                            itemBuilder: (context, index) {
                              return CreationAwareListItem(
                                  itemCreated: () {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((duration) =>
                                            model.handleItemCreated(index));
                                  },
                                  child: MessagingListItemView(
                                      chat: model.items[index]));
                            }),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  model.navigateToPersonPicker();
                },
                child: const Icon(Icons.add),
                backgroundColor: AppTheme.instance.primaryColorBlue,
              ),
            ));
  }
}
