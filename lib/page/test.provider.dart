// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ProviderGenerator
// **************************************************************************

part of 'package:flutter_demo/core/injector.injector.dart';

void injectTestState(TestState state) {
  state.mProvider = TestProviderProxy(state.widget.inputParams);
}

class TestProviderProxy extends TestProvider with NetworkChecker {
  TestProviderProxy(Map<String, Object> inputParams) : super(inputParams);

  @override
  void loadData() async {
    try {
      await checkNetwork();
      super.loadData();
    } catch (_) {}
  }
}
