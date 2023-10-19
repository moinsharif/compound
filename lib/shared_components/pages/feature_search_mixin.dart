
import 'package:compound/shared_components/pages/base_page.dart';
import 'package:flutter/material.dart';

mixin FeatureSearchMixin<Page extends BasePage> on BaseState<Page> {
  @override 
	Widget appBarBottom() => Container();
}