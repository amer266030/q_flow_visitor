import 'package:get_it/get_it.dart';

import '../managers/data_mgr.dart';

class DIContainer {
  static Future<void> setup() async {
    GetIt.I.registerSingleton<DataMgr>(DataMgr());
  }
}
