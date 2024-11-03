import 'package:q_flow/model/rating/company_rating_question.dart';

class LocalData {
  LocalData._internal();

  static final LocalData _instance = LocalData._internal();

  factory LocalData() {
    return _instance;
  }

  var questions = [
    CompanyRatingQuestion(
        title: 'Overall Satisfaction',
        text: 'How satisfied were you with the overall interview process?'),
    CompanyRatingQuestion(
        title: 'Interviewer Professionalism',
        text: 'How would you rate the professionalism of the interviewer?'),
    CompanyRatingQuestion(
        title: 'Clarity of Questions',
        text: 'Were the interview questions clear and relevant to the role?'),
    CompanyRatingQuestion(
        title: 'Time Management',
        text: 'Was the interview conducted within the scheduled time frame?'),
    CompanyRatingQuestion(
        title: 'Fairness of the Process',
        text: 'Do you feel that the interview process was fair and unbiased?'),
    CompanyRatingQuestion(
        title: 'Opportunity to Express Skills',
        text:
            'Did you feel you had enough opportunity to showcase your skills and experience?'),
    CompanyRatingQuestion(
        title: 'Interview Environment',
        text:
            'How comfortable was the interview setting (e.g., location, noise level, privacy)?'),
    CompanyRatingQuestion(
        title: 'Communication',
        text:
            'How well were the interview instructions and expectations communicated prior to the interview?'),
    CompanyRatingQuestion(
        title: 'Post-Interview Feedback',
        text:
            'How satisfied are you with the feedback (if provided) after the interview?'),
    CompanyRatingQuestion(
        title: 'Likelihood to Recommend',
        text:
            'Based on your experience, how likely are you to recommend this interview process to others?'),
  ];
}
