import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/reusable_components/cards/ticket_view.dart';
import 'package:q_flow/reusable_components/page_header_view.dart';
import 'package:q_flow/screens/interview_booked/interview_booked_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';

class InterviewBookedScreen extends StatelessWidget {
  const InterviewBookedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InterviewBookedCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<InterviewBookedCubit>();
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PageHeaderView(title: 'Interview Booked'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      BlocBuilder<InterviewBookedCubit, InterviewBookedState>(
                        builder: (context, state) {
                          if (cubit.interview != null &&
                              cubit.company != null) {
                            return TicketView(
                                company: cubit.company!,
                                timeOfBooking: cubit.interview!.createdAt ?? '',
                                positionInQueue: 0);
                          } else {
                            return Text('?');
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                                "Please make sure to arrive at your interview location ahead of time to avoid missing your turn. If you miss your scheduled time, you'll need to rebook and wait in the queue again.",
                                style: context.bodyMedium),
                            const SizedBox(height: 8),
                            Text(
                              '* The Company might ask your for your National ID number or your QR code',
                              style: context.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: PrimaryBtn(
                                  callback: () => cubit.navigateToHome(context),
                                  title: 'Acknowledged')),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
