import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/screens/interview_booked/interview_booked_screen.dart';
import 'package:q_flow/supabase/supabase_queue.dart';
import 'package:url_launcher/url_launcher.dart';

part 'company_details_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  CompanyDetailsState? previousState;
  CompanyDetailsCubit(Company company) : super(CompanyDetailsInitial()) {
    initialLoad(company);
  }

  StreamSubscription<int>? queueSubscription;
  var dataMgr = GetIt.I.get<DataMgr>();
  var company = Company();
  var queueLength = 0;

  initialLoad(Company company) async {
    this.company = company;
    queueLength = await SupabaseQueue.getQueueLength(company.id!) ?? 0;
    emitUpdate();
  }

  // Subscribe to the queue length stream
  void subscribeToQueueLength(String companyId) {
    queueSubscription = SupabaseQueue.getQueueLengthStream(companyId).listen(
      (newQueueLength) {
        queueLength = newQueueLength;
        emitUpdate();
      },
    );
  }

  @override
  Future<void> close() {
    queueSubscription?.cancel();
    return super.close();
  }

  Future<void> launchLink(String? url, LinkType linkType) async {
    if (url == null || url.isEmpty) {
      throw Exception('URL cannot be null or empty for ${linkType.value}');
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url'; // Prepend https:// if missing
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

  navigateToInterviewBooked(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InterviewBookedScreen()));

  navigateBack(BuildContext context) => Navigator.of(context).pop();

  @override
  void emit(CompanyDetailsState state) {
    previousState = this.state;
    super.emit(state);
  }

  void emitLoading() => emit(LoadingState());
  void emitUpdate() => emit(UpdateUIState());
  void emitError(String msg) => emit(ErrorState(msg));
}
