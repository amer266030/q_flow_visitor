import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q_flow/model/enums/gender.dart';
import 'package:q_flow/screens/bootcamp_screen/bootcamp_screen.dart';

import '../../model/enums/experience.dart';
import '../../model/link_details.dart';
import '../../model/user.dart';
import '../../model/visitor.dart';
import '../../reusable_components/animated_snack_bar.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(User? user, Visitor? visitor) : super(EditProfileInitial()) {
    loadInitialValues(user, visitor);
  }

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  var gender = Gender.male;
  var exp = Experience.none;
  DateTime dob = DateTime.now();
  File? resume;
  File? avatar;

  // Fetch Social Links
  /// match userId
  /// match linkId
  List<LinkDetails> links = [
    LinkDetails(name: 'linkedIn', url: ''),
    LinkDetails(name: 'website', url: ''),
    LinkDetails(name: 'twitter', url: ''),
  ];

  final linkedInController = TextEditingController();
  final websiteController = TextEditingController();
  final xController = TextEditingController();

  loadInitialValues(User? user, Visitor? visitor) async {
    fNameController.text = visitor?.fName ?? '';
    lNameController.text = visitor?.lName ?? '';
    gender = visitor?.gender ?? Gender.male;
    exp = visitor?.experience ?? Experience.none;
    if (visitor?.dob != null) {
      dob = DateTime.parse(visitor!.dob!);
    }

    await Future.delayed(Duration(milliseconds: 50));
    emitUpdate();
  }

  navigateToBootcamp(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BootcampScreen()));

  void getImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) avatar = File(img.path);
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

  void emitLoading() => emit(LoadingState());
  void emitUpdate() => emit(UpdateUIState());
}
