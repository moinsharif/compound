import 'package:compound/locator.dart';
import 'package:compound/theme/app_theme_dark.dart';

class AppTheme {
  //TODO MAVHA multi theme support, swap themes at runtime

  static AppThemeBrand _instance;

  static AppThemeBrand get instance => _instance = locator<AppThemeBrand>(); 
  
  
  //TODO MAVHA optimize/fix, this is a hack to allow theme changes to be hot reloaded after changes //_instance == null? _instance = locator<AppThemeDark>() : _instance;
}
