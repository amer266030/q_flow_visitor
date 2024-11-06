import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../managers/data_mgr.dart';

class DIContainer {
  static Future<void> setup() async {
    GetIt.I.registerSingleton<DataMgr>(DataMgr());
  }

  static configureOneSignal() async {
    await dotenv.load(fileName: ".env");
    OneSignal.Debug.setLogLevel(OSLogLevel.error);
    OneSignal.initialize(dotenv.env['ONESIGNAL_KEY']!);
    OneSignal.Notifications.requestPermission(true);
  }
}
