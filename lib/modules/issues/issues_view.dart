library issues_view;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/modules/issues/issues_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:compound/shared_components/background/background_pattern.dart';

part 'issues_mobile.dart';
part 'issues_web.dart';

class IssuesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _IssuesMobile(),
      desktop: _IssuesWeb(),
      tablet: _IssuesMobile(),
    );
  }
}
