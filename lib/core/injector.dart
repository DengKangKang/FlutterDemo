import 'package:flutter_demo/core/base.dart';

import 'annotations.dart';
import 'injector.injector.dart';

@injector
class ProviderInjector {
  static void injector<T extends BaseState>(BaseState state) {
    try {
      InjectorProxy().inject(state);
    } catch (_) {}
  }
}
