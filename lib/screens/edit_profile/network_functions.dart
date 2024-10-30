import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_cubit.dart';
import 'package:q_flow/supabase/social_link.dart';

import '../../model/user/visitor.dart';
import '../../supabase/supabase_visitor.dart';

extension NetworkFunctions on EditProfileCubit {
  fetchProfile(BuildContext context) async {
    try {
      emitLoading();
      var profile = await SupabaseVisitor.fetchProfile();
      return profile;
    } catch (e) {
      emitError(e.toString());
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
      await SupabaseVisitor.createProfile(
          visitor: visitor, resumeFile: resumeFile, avatarFile: avatarFile);
      await SupabaseSocialLink.upsertLinks([]);
      emitUpdate();
      if (context.mounted) {
        navigateToBootcamp(context);
      }
    } catch (e) {
      emitError(e.toString());
    }
  }

  updateProfile(BuildContext context) async {
    var visitor = GetIt.I.get<DataMgr>().visitor;
    try {
      emitLoading();
      if (visitor == null) throw Exception('Could not read profile data');
      visitor.gender = gender;
      visitor.fName = fNameController.text;
      visitor.lName = lNameController.text;
      visitor.experience = exp;
      visitor.dob = dob.toFormattedString();

      await SupabaseVisitor.updateProfile(
          visitor: visitor,
          visitorId: visitor.id ?? '',
          resumeFile: resumeFile,
          avatarFile: avatarFile);

      emitUpdate();
      Future.delayed(Duration(milliseconds: 50));
      if (context.mounted) {
        navigateBack(context);
      }
    } catch (e) {
      emitError(e.toString());
    }
  }
}
