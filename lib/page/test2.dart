import 'package:flutter/material.dart';
import 'package:flutter_demo/core/annotations.dart';
import 'package:flutter_demo/core/base.dart';

///Author:dengkangkang
///Date:2022/3/4

class Test2Page extends BaseStatefulPage {

  const Test2Page({Key? key, Map<String, Object> inputParams = const {}}) : super(key: key, inputParams: inputParams);

  @override
  State<StatefulWidget> createState() {
    return Test2State();
  }
}

@inject
class Test2State extends BaseState<Test2Page> {

  @autowrite
  late Test2Provider mProvider;

  @override
  Widget build(BuildContext context) {

    throw UnimplementedError();
  }
}


class Test2Provider extends BaseProvider with ChangeNotifier {

  Test2Provider(Map<String, Object> inputParams) : super(inputParams);

}