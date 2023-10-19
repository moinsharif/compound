import 'package:flutter/material.dart';

class BackgroundPattern extends StatelessWidget {
  final Widget child;

  const BackgroundPattern({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Arrow-Pattern.png'),
              fit: BoxFit.cover)),
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}
