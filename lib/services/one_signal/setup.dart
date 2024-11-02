import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalSetup {
  static Future<void> initialize() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("<YOUR APP ID HERE>");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }
}
