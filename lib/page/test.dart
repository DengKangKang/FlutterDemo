import 'package:flutter/material.dart';
import 'package:flutter_demo/core/annotations.dart';
import 'package:flutter_demo/core/base.dart';
import 'package:flutter_demo/intercept/network_checker.dart';

///Author:dengkangkang
///Date:2022/3/2

class TestPage extends BaseStatefulPage {
  const TestPage({Key? key, Map<String, Object> inputParams = const {}}) : super(key: key, inputParams: inputParams);

  @override
  State<StatefulWidget> createState() {
    return TestState();
  }
}

@inject
class TestState extends BaseState<TestPage> {


  @autowrite
  late TestProvider mProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mProvider.loadData();
      },
      child: const Text("TestState"),
    );
  }
}

class TestProvider extends BaseProvider with ChangeNotifier {
  TestProvider(Map<String, Object> inputParams) : super(inputParams);

  @requestNetwork
  void loadData() {
    print('load data by network.');
  }
}
