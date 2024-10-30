import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/social_links/social_link.dart';
import '../model/user/visitor.dart';
import '../utils/img_converter.dart';
import 'client/supabase_mgr.dart';

class SupabaseVisitor {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'visitor';
  static final String avatarBucketKey = 'visitor_avatar';
  static final String resumeBucketKey = 'visitor_resume';
  static final dataMgr = GetIt.I.get<DataMgr>();

  static Future<Visitor?> fetchProfile() async {
    var visitorId = supabase.auth.currentUser?.id ?? '';
    try {
      // Fetch the visitor profile and associated social links based on user_id
      final response = await supabase
          .from('visitor')
          .select('*, social_link(*)')
          .eq('id', visitorId)
          .single();

      final visitor = Visitor.fromJson(response);

      dataMgr.saveVisitorData(visitor: visitor);

      if (response['social_link'] != null) {
        visitor.socialLinks = (response['social_link'] as List)
            .map((link) => SocialLink.fromJson(link))
            .toList();
      }

      return visitor;
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future createProfile({
    required Visitor visitor,
    required File? avatarFile,
    required File? resumeFile,
  }) async {
    if (resumeFile != null) {
      visitor.resumeUrl = await uploadResume(resumeFile);
    }
    if (avatarFile != null) {
      visitor.avatarUrl = await uploadAvatar(avatarFile);
    }
    try {
      var response =
          await supabase.from(tableKey).insert(visitor.toJson()).select();
      return response;
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future updateProfile({
    required Visitor visitor,
    required String visitorId,
    required File? resumeFile,
    required File? avatarFile,
  }) async {
    try {
      if (resumeFile != null) {
        visitor.resumeUrl = await uploadResume(resumeFile);
      }
      if (avatarFile != null) {
        visitor.avatarUrl = await uploadAvatar(avatarFile);
      }

      await supabase
          .from(tableKey)
          .update(visitor.toJson())
          .eq('id', visitorId)
          .select();
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> uploadResume(File pdfFile) async {
    try {
      final fileBytes = await ImgConverter.fileImgToBytes(pdfFile);
      final fileName =
          '${SupabaseMgr.shared.supabase.auth.currentUser?.id ?? '123'}.pdf';

      await supabase.storage.from(resumeBucketKey).uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(upsert: true),
          );

      final publicUrl =
          supabase.storage.from(resumeBucketKey).getPublicUrl(fileName);
      return publicUrl;
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> uploadAvatar(File imageFile) async {
    try {
      final fileBytes = await ImgConverter.fileImgToBytes(imageFile);
      final fileName =
          '${SupabaseMgr.shared.supabase.auth.currentUser?.id ?? '123'}.png';

      await supabase.storage.from(avatarBucketKey).uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(upsert: true),
          );

      final publicUrl =
          supabase.storage.from(avatarBucketKey).getPublicUrl(fileName);
      return publicUrl;
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
