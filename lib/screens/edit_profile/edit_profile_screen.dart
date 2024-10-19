import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/enums/experience.dart';
import 'package:q_flow/model/visitor.dart';
import 'package:q_flow/reusable_components/custom_text_field.dart';
import 'package:q_flow/reusable_components/page_header_view.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_cubit.dart';
import 'package:q_flow/reusable_components/buttons/date_btn_view.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../model/enums/gender.dart';
import '../../reusable_components/custom_dropdown_view.dart';
import '../../reusable_components/buttons/oval_toggle_btns.dart';
import '../../utils/validations.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, this.visitor});

  final Visitor? visitor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(null, null),
      child: Builder(builder: (context) {
        final cubit = context.read<EditProfileCubit>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  PageHeaderView(title: 'Profile'),
                  Column(
                    children: [
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, state) {
                          return _ImgView(cubit: cubit, visitor: visitor);
                        },
                      ),
                      TextButton(
                          onPressed: cubit.getImage,
                          child: Text('Add Photo',
                              style: TextStyle(
                                  fontSize: context.bodySmall.fontSize,
                                  color: context.primary,
                                  fontWeight: context.titleSmall.fontWeight)))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                            hintText: 'John',
                            controller: cubit.fNameController,
                            validation: Validations.name),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                            hintText: 'Doe',
                            controller: cubit.lNameController,
                            validation: Validations.name),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextField(
                          hintText: 'Gender',
                          readOnly: true,
                          controller: TextEditingController(),
                          validation: Validations.none),
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OvalToggleButtons(
                                currentIndex:
                                    Gender.values.indexOf(cubit.gender),
                                tabs:
                                    Gender.values.map((g) => g.value).toList(),
                                callback: (idx) => cubit.setGender(idx),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextField(
                          hintText: 'Experience Yrs.',
                          readOnly: true,
                          controller: TextEditingController(),
                          validation: Validations.none),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlocBuilder<EditProfileCubit, EditProfileState>(
                              builder: (context, state) {
                                return CustomDropdown(
                                  selectedValue: cubit.exp.value,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      cubit.setExperience(
                                          ExperienceExtension.fromString(
                                              newValue));
                                    }
                                  },
                                  dropdownItems: Experience.values
                                      .map((e) => e.value)
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextField(
                          hintText: 'DOB',
                          readOnly: true,
                          controller: TextEditingController(),
                          validation: Validations.none),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlocBuilder<EditProfileCubit, EditProfileState>(
                              builder: (context, state) {
                                return DateBtnView(
                                    date: cubit.dob,
                                    callback: (date) => cubit.updateDOB(date));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextField(
                          hintText: 'CV',
                          readOnly: true,
                          controller: TextEditingController(),
                          validation: Validations.none),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlocBuilder<EditProfileCubit, EditProfileState>(
                              builder: (context, state) {
                                return visitor?.resumeUrl == null
                                    ? Text('none', style: context.bodyMedium)
                                    : Icon(CupertinoIcons.doc_checkmark,
                                        color: context.textColor1);
                              },
                            ),
                            IconButton(
                                onPressed: () => (),
                                icon: Icon(CupertinoIcons.square_arrow_up_fill,
                                    color: context.primary))
                          ],
                        ),
                      )
                    ],
                  ),
                  CustomTextField(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Icon(BootstrapIcons.linkedin),
                      ),
                      hintText: 'Linkedin',
                      controller: cubit.linkedInController,
                      validation: Validations.name),
                  CustomTextField(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Icon(BootstrapIcons.link_45deg),
                      ),
                      hintText: 'Website',
                      controller: cubit.websiteController,
                      validation: Validations.name),
                  CustomTextField(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Icon(BootstrapIcons.twitter_x),
                      ),
                      hintText: 'Twitter',
                      controller: cubit.websiteController,
                      validation: Validations.name),
                  SizedBox(height: 16),
                  PrimaryBtn(
                      callback: () => cubit.navigateToBootcamp(context),
                      title: 'Next')
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ImgView extends StatelessWidget {
  const _ImgView({required this.cubit, required this.visitor});

  final EditProfileCubit cubit;
  final Visitor? visitor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            color: context.bg3,
            width: 120,
            height: 120,
            child: cubit.avatar != null
                ? Image.file(cubit.avatar!, fit: BoxFit.cover)
                : visitor?.avatarUrl == null
                    ? Icon(
                        CupertinoIcons.person_fill,
                        size: 40,
                        color: context.primary,
                      )
                    : Image.network(visitor!.avatarUrl!, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
