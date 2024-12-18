import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/enums/experience.dart';
import 'package:q_flow/model/user/visitor.dart';
import 'package:q_flow/reusable_components/buttons/date_btn_view.dart';
import 'package:q_flow/reusable_components/buttons/primary_btn.dart';
import 'package:q_flow/reusable_components/custom_text_field.dart';
import 'package:q_flow/reusable_components/page_header_view.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_cubit.dart';
import 'package:q_flow/screens/edit_profile/network_functions.dart';
import 'package:q_flow/theme_data/extensions/text_style_ext.dart';
import 'package:q_flow/theme_data/extensions/theme_ext.dart';

import '../../extensions/img_ext.dart';
import '../../model/enums/gender.dart';
import '../../reusable_components/buttons/oval_toggle_btns.dart';
import '../../reusable_components/custom_dropdown_view.dart';
import '../../reusable_components/dialogs/error_dialog.dart';
import '../../reusable_components/dialogs/loading_dialog.dart';
import '../../utils/validations.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen(
      {super.key, this.visitor, this.isInitialSetup = true});

  final Visitor? visitor;
  final bool isInitialSetup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(visitor),
      child: Builder(builder: (context) {
        final cubit = context.read<EditProfileCubit>();
        return BlocListener<EditProfileCubit, EditProfileState>(
          listener: (context, state) async {
            if (cubit.previousState is LoadingState) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }

            if (state is LoadingState) {
              showLoadingDialog(context);
            }

            if (state is ErrorState) {
              showErrorDialog(context, state.msg);
            }
          },
          child: Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    PageHeaderView(title: 'UpdateProfile'.tr()),
                    Column(
                      children: [
                        BlocBuilder<EditProfileCubit, EditProfileState>(
                          builder: (context, state) {
                            return _ImgView(cubit: cubit, visitor: visitor);
                          },
                        ),
                        TextButton(
                            onPressed: cubit.getImage,
                            child: Text('AddPhoto',
                                style: TextStyle(
                                    fontSize: context.bodySmall.fontSize,
                                    color: context.primary,
                                    fontWeight: context.titleSmall.fontWeight)).tr())
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              hintText: 'John'.tr(),
                              controller: cubit.fNameController,
                              validation: Validations.name),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                              hintText: 'Doe'.tr(),
                              controller: cubit.lNameController,
                              validation: Validations.name),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        CustomTextField(
                            hintText: 'Gender'.tr(),
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
                                  tabs: Gender.values
                                      .map((g) => g.value)
                                      .toList(),
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
                            hintText: 'ExperienceYrs'.tr(),
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
                            hintText: 'DOB'.tr(),
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
                                      callback: (date) =>
                                          cubit.updateDOB(date));
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
                            hintText: 'CV'.tr(),
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
                                  return (visitor?.resumeUrl != null ||
                                          cubit.resumeFile != null)
                                      ? Icon(CupertinoIcons.doc_checkmark,
                                          color: context.textColor1)
                                      : Text('none', style: context.bodyMedium).tr();
                                },
                              ),
                              IconButton(
                                  onPressed: cubit.uploadResume,
                                  icon: Icon(
                                      CupertinoIcons.square_arrow_up_fill,
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
                        hintText: 'Linkedin'.tr(),
                        controller: cubit.linkedInController,
                        validation: Validations.validateUrl),
                    CustomTextField(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Icon(BootstrapIcons.link_45deg),
                        ),
                        hintText: 'Website'.tr(),
                        controller: cubit.websiteController,
                        validation: Validations.validateUrl),
                    CustomTextField(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Icon(BootstrapIcons.twitter_x),
                        ),
                        hintText: 'Twitter'.tr(),
                        controller: cubit.xController,
                        validation: Validations.validateUrl),
                    SizedBox(height: 16),
                    PrimaryBtn(
                        callback: (isInitialSetup || visitor == null)
                            ? () {
                                if (cubit.validateFields()) {
                                  cubit.createProfile(context);
                                } else {
                                  cubit.showSnackBar(
                                      context,
                                      'PleaseFill'.tr(),
                                      AnimatedSnackBarType.error);
                                }
                              }
                            : () {
                                if (cubit.validateFields()) {
                                  cubit.updateProfile(context);
                                } else {
                                  cubit.showSnackBar(
                                      context,
                                      'PleaseFill'.tr(),
                                      AnimatedSnackBarType.error);
                                }
                              },
                        title: isInitialSetup ? 'Next' : 'Save')
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // border: Border.all(color: context.primary, width: 2),
            ),
            width: 140,
            height: 140,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 5,
                child: ClipOval(
                  child: cubit.avatarFile != null
                      ? Image.file(cubit.avatarFile!, fit: BoxFit.cover)
                      : visitor?.avatarUrl == null
                          ? Image(image: Img.avatar, fit: BoxFit.cover)
                          : Image.network(visitor!.avatarUrl!,
                              fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
