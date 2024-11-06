import 'package:easy_localization/easy_localization.dart';

enum InterviewStatus { upcoming, completed, cancelled }

extension InterviewStatusExtension on InterviewStatus {
  String get value {
    switch (this) {
      case InterviewStatus.upcoming:
        return 'Upcoming'.tr();
      case InterviewStatus.completed:
        return 'Completed'.tr();
      case InterviewStatus.cancelled:
        return 'Cancelled'.tr();
      default:
        return '';
    }
  }

  static InterviewStatus fromString(String? gender) {
    switch (gender) {
      case 'Upcoming':
        return InterviewStatus.upcoming;
      case 'Completed':
        return InterviewStatus.completed;
      case 'Cancelled':
        return InterviewStatus.cancelled;
      default:
        throw ArgumentError('InvalidBootcampValue'.tr());
    }
  }
}
