import 'package:compound/modules/messaging/messaging_button/messaging_button_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MessagingButton extends StatelessWidget {
  const MessagingButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessagingButtonViewModel>.reactive(
        viewModelBuilder: () => MessagingButtonViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => !model.visible
            ? Container()
            : Container(
                margin: EdgeInsets.only(right: 0, left: 10, top: 2),
                child: InkWell(
                    onTap: () {
                      model.navigateToMessages();
                    },
                    child: Row(children: [
                      model.counter != null && model.counter > 0
                          ? Text(
                              model.counter.toString(),
                              style: TextStyle(
                                  fontFamily: AppTheme.instance.primaryFont,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.instance.primaryColorBlue,
                                  fontSize: 18),
                            )
                          : Container(),
                      Icon(Icons.chat,
                          color: AppTheme.instance.colorGreyLight, size: 18)
                    ])),
              ));
  }
}
