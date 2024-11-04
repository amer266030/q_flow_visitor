import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalSetup {
  static init() async {
    //Remove this method to stop OneSignal Debugging
    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(dotenv.env['ONESIGNAL_KEY']!);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }
}
