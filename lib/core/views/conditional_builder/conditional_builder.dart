import 'package:flutter/material.dart';

class ConditionalBuilder extends StatelessWidget {

  final bool condition;
  final WidgetBuilder builder;
  final WidgetBuilder fallback;

  const ConditionalBuilder({
    Key key,
    @required this.condition,
    @required this.builder,
    this.fallback,
  })  : assert(condition != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      condition ? builder(context) : fallback != null ? fallback(context) : Container();
}