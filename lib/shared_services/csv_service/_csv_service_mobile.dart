import 'dart:convert';
import 'dart:io';

import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CSVService extends BaseService {
  Future<bool> generateCsv(List<PayrollModel> payroll) async {
    if (!await _requestPermissions()) {
      await Permission.storage.request();
      return null;
    } else {
      final int now = DateTime.now().millisecondsSinceEpoch;
      List<List<dynamic>> employeeData =
          List<List<dynamic>>.empty(growable: true);
      employeeData.add(['DATE', 'EMPLOYEE', 'LOCATION', 'PROPERTY', 'WAGE']);
      await Future.forEach(payroll, (PayrollModel e) {
        List<dynamic> row = List.empty(growable: true);
        row.add(DateFormat('MMM dd yyyy').format(e.createdAt.local()));
        row.add(e.employeeName);
        row.add(e.propertyAddress);
        row.add(e.propertyName);
        row.add(e.wage.toString());
        employeeData.add(row);
      });
      String csv = const ListToCsvConverter().convert(employeeData);
      Directory downloadsDirectory = Platform.isAndroid
          ? await DownloadsPathProvider.downloadsDirectory
          : await getApplicationDocumentsDirectory();
      final String path = downloadsDirectory.path;
      final String fileName = '$path/Report-$now.csv';
      print(fileName);
      final File file = File(fileName);
      await file.writeAsString(csv, flush: true);
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Report created successfully'),
      ));
      return true;
    }
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(date);
  }

  Future<bool> _requestPermissions() async {
    try {
      var permission = await Permission.storage.isGranted;

      if (!permission) {
        await Permission.storage.request();
        permission = await Permission.storage.isGranted;
      }

      return permission;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
