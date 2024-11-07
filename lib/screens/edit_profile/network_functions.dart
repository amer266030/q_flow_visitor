import 'package:flutter/material.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/model/social_links/social_link.dart';
import 'package:q_flow/screens/edit_profile/edit_profile_cubit.dart';
import 'package:q_flow/supabase/client/supabase_mgr.dart';
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
      email: SupabaseMgr.shared.supabase.auth.currentUser?.email,
      experience: exp,
      dob: dob.toFormattedString(),
    );

    try {
      emitLoading();
      var newVisitor = await SupabaseVisitor.createProfile(
          visitor: visitor, resumeFile: resumeFile, avatarFile: avatarFile);

      // Create Social Links

      Future.delayed(Duration(milliseconds: 50));

      var visitorId = newVisitor.id;
      if (visitorId == null)
        throw Exception(
            'Could not create social links because no user was found!');
      var links = createLinks(visitorId);
      var socialLinks = await SupabaseSocialLink.insertLinks(links);
      newVisitor.socialLinks = socialLinks;

      dataMgr.visitor = newVisitor;

      emitUpdate();

      await Future.delayed(Duration(milliseconds: 50));

      if (context.mounted) {
        navigateToSkills(context);
      }
    } catch (e) {
      emitError(e.toString());
    }
  }

  updateProfile(BuildContext context) async {
    var visitor = dataMgr.visitor;
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

      // Update Social lLinks
      var links = createLinks(visitor.id ?? '');
      await SupabaseSocialLink.updateLinks(links);

      emitUpdate();
      Future.delayed(Duration(milliseconds: 50));
      if (context.mounted) {
        navigateBack(context);
      }
    } catch (e) {
      emitError(e.toString());
    }
  }

  List<SocialLink> createLinks(String visitor_id) {
    return [
      SocialLink(
        visitorId: visitor_id,
        linkType: LinkType.linkedIn,
        url: linkedInController.text,
      ),
      SocialLink(
        visitorId: visitor_id,
        linkType: LinkType.website,
        url: websiteController.text,
      ),
      SocialLink(
        visitorId: visitor_id,
        linkType: LinkType.twitter,
        url: xController.text,
      ),
    ];
  }
}
