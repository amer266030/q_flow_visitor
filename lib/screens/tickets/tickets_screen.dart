import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/model/enums/interview_status.dart';
import 'package:q_flow/reusable_components/cards/ticket_view.dart';
import 'package:q_flow/screens/tickets/tickets_cubit.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../reusable_components/buttons/expanded_toggle_buttons.dart';
import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketsCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<TicketsCubit>();
        return BlocListener<TicketsCubit, TicketsState>(
          listener: (context, state) {
            if (cubit.previousState is LoadingState) {
              Navigator.of(context).pop();
            }

            if (state is LoadingState) {
              showLoadingDialog(context);
            }

            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
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
                      ).tr(),
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
                            cubit.filteredInterviews.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                      cubit.getEmptyStateMessage(
                                          cubit.selectedStatus),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: context.textColor1,
                                      ),
                                      textAlign: TextAlign
                                          .center, // Center text alignment
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Column(
                                        children: cubit.filteredInterviews
                                            .map((interview) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  child: InkWell(
                                                    onTap: () =>
                                                        cubit.navigateToRating(
                                                            context, interview),
                                                    child: Stack(
                                                      children: [
                                                        TicketView(
                                                            timeOfBooking: interview
                                                                        .createdAt ==
                                                                    null
                                                                ? '?'
                                                                : DateTime.parse(
                                                                        interview
                                                                            .createdAt!)
                                                                    .toFormattedStringTimeOnly(),
                                                            positionInQueue: -1,
                                                            company: cubit
                                                                .getCompany(
                                                                    interview
                                                                            .companyId ??
                                                                        '')),
                                                        if (interview.status ==
                                                            InterviewStatus
                                                                .upcoming)
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: IconButton(
                                                                  onPressed: () =>
                                                                      cubit.cancelInterview(
                                                                          context,
                                                                          interview),
                                                                  icon: Icon(
                                                                      CupertinoIcons
                                                                          .trash,
                                                                      size:
                                                                          20)))
                                                      ],
                                                    ),
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
          ),
        );
      }),
    );
  }
}
