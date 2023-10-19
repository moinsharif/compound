import 'package:flutter/material.dart';

class LoadingCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
      ),
    );
  }
}
