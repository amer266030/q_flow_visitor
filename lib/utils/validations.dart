import 'package:easy_localization/easy_localization.dart';

class Validations {
  static String? name(String value) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (regex.hasMatch(value) || value.isEmpty) {
      // Valid email address
      return null;
    } else if (!regex.hasMatch(value)) {
      return 'Invalid name format';
    } else {
      // Invalid email address
      return 'ThisFieldCannotBeEmpty'.tr();
    }
  }

  static String? email(String value) {
    final regex = RegExp(r"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}");
    if (regex.hasMatch(value)) {
      return null;
    } else {
      return 'PleaseEnterAValidEmailAddress'.tr();
    }
  }

  static String? phoneNumber(String value) {
    final regex = RegExp(r'^[0-9]{10}$');

    if (regex.hasMatch(value)) {
      return null;
    } else {
      return 'PleaseEnterAValidPhoneNumber'.tr();
    }
  }

  static String? password(String value) {
    final regex = RegExp(r'^.{8,}$');

    if (regex.hasMatch(value)) {
      return null;
    } else {
      return 'MustBeAtLeast8Characters'.tr();
    }
  }

  static String? validateInt(String value) {
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'PleaseEnterAValidInteger'.tr();
    }

    return null; // Return null if validation passes
  }

  static String? validateDouble(String value) {
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'PleaseEnterAValidDecimalNumber'.tr();
    }

    return null; // Return null if validation passes
  }

  static String? validateUrl(String value) {
    final urlPattern =
        r'^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$';
    final regex = RegExp(urlPattern);

    if (value.isEmpty) {
      return 'This field cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null; // Return null if validation passes
  }

  static String? none(String value) => null;
}
