import 'package:connectivity_plus/connectivity_plus.dart';

///Author:dengkangkang
///Date:2022/3/18

class NetworkChecker {
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile || noNetwork();
  }

  noNetwork() => throw Exception("Device not connected to any network");
}
