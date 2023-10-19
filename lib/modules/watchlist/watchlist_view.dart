library watchlist_view;

import 'dart:async';

import 'package:compound/config.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/watchlist/watchlist_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/evidence_picture/evidence_picture.dart';
import 'package:compound/shared_components/evidence_picture/services/evidence_picture_service.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_components/loading/loading.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'watchlist_mobile.dart';

class WatchlistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _WatchlistViewMobileState(),
      desktop: _WatchlistViewMobileState(),
      tablet: _WatchlistViewMobileState(),
    );
  }
}
