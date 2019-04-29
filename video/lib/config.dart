import 'package:package_info/package_info.dart';
import 'package:logging/logging.dart';


class BLConfig {
  static PackageInfo packageInfo;
  static var domain = 'weiguan.app';
  static var apiBaseUrl = 'https://$domain/api';
  static var debug = false;
  static var loggerLevel = Level.ALL;
  static var isLogAction = false;
  static var isLogApi = false;
  static var isMockApi = true;
}