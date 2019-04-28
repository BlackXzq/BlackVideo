import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'app.dart';
import 'config.dart';

void main() {
  PackageInfo.fromPlatform().then((packageInfo){
    BLConfig.packageInfo = packageInfo;
    runApp(BLApp());
  });
}

