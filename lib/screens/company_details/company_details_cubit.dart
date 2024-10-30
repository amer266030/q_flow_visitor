import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/screens/interview_booked/interview_booked_screen.dart';
import 'package:url_launcher/url_launcher.dart';

part 'company_details_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  CompanyDetailsCubit() : super(CompanyDetailsInitial()) {
    initialLoad();
  }

  Future<void> launchLink(String? url, LinkType linkType) async {
    if (url == null || url.isEmpty) {
      throw Exception('URL cannot be null or empty for ${linkType.value}');
    }

    final Uri uri = Uri.parse(url);
    
    
    switch (linkType) {
      case LinkType.linkedIn:
     
        break;
      case LinkType.website:
       
        break;
      case LinkType.twitter:
       
        break;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  List<TechSkill> skills = [];

  initialLoad() {
    skills = TechSkill.values.sublist(0, 5);
    emitUpdateUI();
  }

  navigateToInterviewBooked(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InterviewBookedScreen()));

  navigateBack(BuildContext context) => Navigator.of(context).pop();

  emitUpdateUI() => emit(UpdateUIState());
}
