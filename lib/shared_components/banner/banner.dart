import 'package:flutter/material.dart';
import 'package:compound/theme/app_theme.dart';

class AppBanner extends StatelessWidget {
  
  final Image image;
  const AppBanner({@required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[Container(
                    color: AppTheme.instance.primaryLighter,
                    child: Center(
                      child: this.image,
                    ),
                  ),
            ]);
  }
}


