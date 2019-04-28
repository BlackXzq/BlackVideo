import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'models/models.dart';
import 'theme.dart';
import 'config.dart';
import 'factory.dart';
import 'pages/pages.dart';



class BLApp extends StatelessWidget {
  
  final logger = WgFactory().getLogger('app');
  final store  = WgFactory().getStore();
  final persistor = WgFactory().getPersistor();
  
  BLApp() {
    logger.info('WgConfig(debug: ${BLConfig.debug}, loggerLevel: ${BLConfig.loggerLevel})');
    persistor.load(store);
  }
  
  @override
  Widget build(BuildContext context) {
    return PersistorGate(
      persistor: persistor,
      builder: (context) => StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: BLConfig.packageInfo.appName ?? 'VideO',
          theme: BLTheme.theme,
          routes: {
            '/': (context) => BootstrapPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/tab': (context) => TabPage()
          },
        ),
      ),
    );
  }
}


