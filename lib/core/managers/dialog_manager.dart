import 'package:compound/core/models/dialog_models.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:compound/locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                request.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(request.description),
              actions: <Widget>[
                if (isConfirmationDialog)
                  TextButton(
                    child: Text(request.cancelTitle),
                    onPressed: () {
                      _dialogService
                          .dialogComplete(DialogResponse(confirmed: false));
                      Navigator.pop(context);
                    },
                  ),
                TextButton(
                  child: Text(request.buttonTitle),
                  onPressed: () {
                    _dialogService
                        .dialogComplete(DialogResponse(confirmed: true));
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
