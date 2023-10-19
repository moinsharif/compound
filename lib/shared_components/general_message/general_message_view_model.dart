import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_services/issue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GeneralMessageViewModel extends BaseViewModel {
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  final IssueService _issueService = locator<IssueService>();

  Future<void> load() async {}

  Future<String> addIssue() async {
    final FormBuilderState form = fbKey.currentState;
    setBusy(true);
    final date = DateTime.now();
    Map<String, dynamic> data = {
      'subject': form.fields['subject'].value,
      'describe': form.fields['describe'].value,
      'updatedAt': date,
      'createdAt': date,
    };
    final resp = await _issueService.addIssue(data);
    setBusy(false);
    return resp;
  }
}
