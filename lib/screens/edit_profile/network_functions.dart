import 'package:flutter/material.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_cubit.dart';

import '../../model/user/visitor.dart';
import '../../supabase/supabase_profile.dart';

extension NetworkFunctions on EditProfileCubit {
  fetchProfile(BuildContext context, String visitorId) async {
    try {
      emitLoading();
      var profile = await SupabaseProfile.fetchProfile(visitorId);
      return profile;
    } catch (e) {
      print(e.toString());
      emitError('Could not fetch profile!\nPlease try again later.');
    }
  }

  createProfile(BuildContext context) async {
    var visitor = Visitor(
      gender: gender,
      fName: fNameController.text,
      lName: lNameController.text,
      experience: exp,
      dob: dob.toFormattedString(),
    );

    try {
      emitLoading();
      await SupabaseProfile.createProfile(
          visitor: visitor, resumeFile: resumeFile, avatarFile: avatarFile);
      emitUpdate();
      if (context.mounted) {
        navigateToBootcamp(context);
      }
    } catch (e) {
      print(e.toString());
      emitError('Could not create profile!\nPlease try again later.');
    }
  }

  updateProfile(BuildContext context, String visitorId) async {
    var visitor = Visitor(
      gender: gender,
      fName: fNameController.text,
      lName: lNameController.text,
      experience: exp,
      dob: dob.toFormattedString(),
    );

    try {
      emitLoading();
      await SupabaseProfile.updateProfile(
          visitor: visitor,
          visitorId: visitorId,
          resumeFile: resumeFile,
          avatarFile: avatarFile);

      if (context.mounted) {
        navigateBack(context);
      }
    } catch (e) {
      print(e.toString());
      emitError('Could not update profile!\nPlease try again later.');
    }
  }
}
