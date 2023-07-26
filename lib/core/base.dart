import 'package:flutter/cupertino.dart';

import 'injector.dart';

abstract class BaseStatefulPage extends StatefulWidget {
  final Map<String, Object> inputParams;

  const BaseStatefulPage({Key? key, required this.inputParams}) : super(key: key);
}

abstract class BaseState<T extends BaseStatefulPage> extends State<T> {
  final Map<String, Object> outputParams = {};

  @override
  void initState() {
    ProviderInjector.injector(this);
    super.initState();
  }
}

class BaseProvider {
  final Map<String, Object> inputParams;

  BaseProvider(this.inputParams);
}
