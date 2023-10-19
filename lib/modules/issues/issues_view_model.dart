import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/issue_model.dart';
import 'package:compound/shared_services/issue_service.dart';

import '../../core/services/navigation/navigator_service.dart';
import '../../router.dart';

class IssuesViewModel extends BaseViewModel {
  final IssueService _issueService = locator<IssueService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  List<IssueModel> issues;
  bool prevExist = false;
  bool nextExist = true;

  Future<void> load() async {
    setBusy(true);
    issues = await _issueService.getPaginatedIssues();
    setBusy(false);
  }

  Future<void> paginatedProperties(bool next, {int itemsPerPage = 6}) async {
    setBusy(true);
    issues = await _issueService.getPaginatedIssues(
        next: next, itemsPerPage: itemsPerPage);
    if (issues.length == 0 || issues.length < itemsPerPage)
      nextExist = false;
    else
      nextExist = true;
    if (_issueService.prevDocumentSnapshotList.length == 0)
      prevExist = false;
    else
      prevExist = true;
    setBusy(false);
  }

  @override
  void dispose() {
    _issueService.prevDocumentSnapshotList.clear();
    _issueService.nextDocumentSnapshot = null;
    _issueService.prevDocumentSnapshot = null;
    super.dispose();
  }
}
