import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/model/enums/gender.dart';
import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/reusable_components/animated_snack_bar.dart';

import '../../model/enums/experience.dart';
import '../../model/user/visitor.dart';
import '../skills/skills_screen.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileState? previousState;
  EditProfileCubit(Visitor? visitor) : super(EditProfileInitial()) {
    loadInitialValues(visitor);
  }

  var dataMgr = GetIt.I.get<DataMgr>();

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  var gender = Gender.male;
  var exp = Experience.none;
  DateTime dob = DateTime.now();
  File? resumeFile;
  File? avatarFile;

  final linkedInController = TextEditingController();
  final websiteController = TextEditingController();
  final xController = TextEditingController();

  loadInitialValues(Visitor? visitor) async {
    if (visitor != null) {
      fNameController.text = visitor.fName ?? '';
      lNameController.text = visitor.lName ?? '';
      gender = visitor.gender ?? Gender.male;
      exp = visitor.experience ?? Experience.none;
      if (visitor.dob != null) {
        dob = visitor.dob!.toDate();
      }

      if (visitor.socialLinks != null && visitor.socialLinks!.isNotEmpty) {
        for (var link in visitor.socialLinks!) {
          switch (link.linkType) {
            case LinkType.linkedIn:
              linkedInController.text = link.url ?? '';
            case LinkType.website:
              websiteController.text = link.url ?? '';
            case LinkType.twitter:
              xController.text = link.url ?? '';
            default:
          }
        }
      }
    }

    await Future.delayed(Duration(milliseconds: 50));
    emitUpdate();
  }

  bool validateFields() {
    final currentYear = DateTime.now().year;
    if (fNameController.text.isEmpty ||
        lNameController.text.isEmpty ||
        linkedInController.text.isEmpty ||
        websiteController.text.isEmpty ||
        xController.text.isEmpty ||
        exp == Experience.none ||
        dob.year > currentYear - 10) {
      return false;
    }
    return true;
  }

  navigateBack(BuildContext context) => Navigator.of(context).pop();

  navigateToSkills(BuildContext context) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => SkillsScreen()));

  void getImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) avatarFile = File(img.path);
    emitUpdate();
  }

  void uploadResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      resumeFile = File(result.files.single.path!);
    }
    emitUpdate();
  }

  setGender(int idx) {
    gender = Gender.values[idx];
    emitUpdate();
  }

  setExperience(Experience selectedExp) {
    exp = selectedExp;
    emitUpdate();
  }

  updateDOB(DateTime date) {
    dob = date;
    emitUpdate();
  }

  void showSnackBar(
      BuildContext context, String msg, AnimatedSnackBarType type) {
    if (context.mounted) {
      animatedSnakbar(msg: msg, type: type).show(context);
    }
  }

  @override
  void emit(EditProfileState state) {
    previousState = this.state;
    super.emit(state);
  }

  void emitLoading() => emit(LoadingState());
  void emitUpdate() => emit(UpdateUIState());
  void emitError(String msg) => emit(ErrorState(msg));
}
