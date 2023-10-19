// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';
import 'package:compound/core/environment/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';


@immutable
class SafeColorFilter extends StatelessWidget { //TODO MAVHA temporal fix for ColorFiltered web issues

  final Widget child;
  final ColorFilter colorFilter;

  const SafeColorFilter({@required this.colorFilter, this.child, Key key})
      : assert(colorFilter != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
      if(Environment.isNativeRuntime){
        return ColorFiltered(colorFilter:  colorFilter, child: child);
      }

      return  Container(child: child);
  }
}
