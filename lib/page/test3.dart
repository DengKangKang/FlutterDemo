import 'package:flutter/material.dart';
import 'package:flutter_demo/core/annotations.dart';
import 'package:flutter_demo/core/base.dart';

///Author:dengkangkang
///Date:2022/3/7

class Test3Page extends BaseStatefulPage {

  const Test3Page({Key? key, Map<String, Object> inputParams = const {}}) : super(key: key, inputParams: inputParams);

  @override
  State<StatefulWidget> createState() {
    return Test3State();
  }
}

@inject
class Test3State extends BaseState<Test3Page> {

  @autowrite
  late Test3Provider mProvider;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


class Test3Provider extends BaseProvider with ChangeNotifier {

  Test3Provider(Map<String, Object> inputParams) : super(inputParams);

}