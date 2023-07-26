// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: InjectProvider
// **************************************************************************

import 'package:flutter_demo/core/base.dart';
import 'package:flutter_demo/intercept/network_checker.dart';
import 'package:flutter_demo/page/test.dart';
import 'package:flutter_demo/page/test2.dart';
import 'package:flutter_demo/page/test3.dart';
part 'package:flutter_demo/page/test.provider.dart';
part 'package:flutter_demo/page/test2.provider.dart';
part 'package:flutter_demo/page/test3.provider.dart';

class InjectorProxy {
  void inject(BaseState state) {
    if (state is TestState) {
      injectTestState(state);
      return;
    }
    if (state is Test2State) {
      injectTest2State(state);
      return;
    }
    if (state is Test3State) {
      injectTest3State(state);
      return;
    }
  }
}
