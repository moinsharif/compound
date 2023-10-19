import 'dart:convert';
import 'dart:html' as html;

import 'package:compound/core/base/base_service.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class CSVService extends BaseService {
  Future<bool> generateCsv(List<PayrollModel> payroll) async {
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
    // Encode our file in base64
    final _base64 = base64Encode(utf8.encode(csv));
    // Create the link with the file
    final anchor = html.AnchorElement(
        href: 'data:application/octet-stream;base64,$_base64')
      ..target = 'blank';
    anchor.download = 'Report-$now.csv';
    // trigger download
    html.document.body.append(anchor);
    anchor.click();
    anchor.remove();
    return true;
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(date);
  }
}
