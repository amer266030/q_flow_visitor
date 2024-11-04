import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/model/enums/interview_status.dart';
import 'package:q_flow/reusable_components/cards/ticket_view.dart';
import 'package:q_flow/screens/tickets/tickets_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../reusable_components/buttons/expanded_toggle_buttons.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketsCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<TicketsCubit>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Booked Interviews',
                      style: TextStyle(
                        fontSize: context.bodyLarge.fontSize,
                        fontWeight: FontWeight.bold,
                        color: context.textColor1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<TicketsCubit, TicketsState>(
                      builder: (context, state) {
                        return ListView(children: [
                          ExpandedToggleButtons(
                            currentIndex: InterviewStatus.values
                                .indexOf(cubit.selectedStatus),
                            tabs: InterviewStatus.values
                                .map((i) => i.value)
                                .toList(),
                            callback: (int value) =>
                                cubit.setSelectedStatus(value),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                                children: cubit.filteredInterviews
                                    .map((interview) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: InkWell(
                                            onTap: () => cubit.navigateToRating(
                                                context, interview),
                                            child: TicketView(
                                                timeOfBooking: interview
                                                            .createdAt ==
                                                        null
                                                    ? '?'
                                                    : DateTime.parse(interview
                                                            .createdAt!)
                                                        .toFormattedStringTimeOnly(),
                                                positionInQueue: -1,
                                                company: cubit.getCompany(
                                                    interview.companyId ?? '')),
                                          ),
                                        ))
                                    .toList()),
                          )
                        ]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
