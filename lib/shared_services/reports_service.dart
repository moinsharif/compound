import 'package:compound/core/base/base_service.dart';
import 'package:rxdart/subjects.dart';

class ReportsService extends BaseService {
  BehaviorSubject<List<String>> reportsLoaded = BehaviorSubject<List<String>>();
  List<String> _arrayReports = [];

  ReportsService() {
    reportsLoaded.add([]);
  }

  List<String> get getArray => _arrayReports;

  void dispose() {
    if (reportsLoaded != null && !reportsLoaded.isClosed) reportsLoaded.close();
  }

  void add(String value) {
    if (_arrayReports.contains(value)) {
      return;
    }

    _arrayReports = [..._arrayReports, value];
    reportsLoaded.add(_arrayReports);
  }

  void remove(String value) {
    _arrayReports.removeWhere((element) => element == value);
    reportsLoaded.add(_arrayReports);
  }

  clearReports() {
    _arrayReports = [];
    reportsLoaded.add([]);
  }
}
