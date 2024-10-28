import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user/visitor.dart';
import '../utils/img_converter.dart';
import 'client/supabase_mgr.dart';

class SupabaseProfile {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'visitor';
  static final String avatarBucketKey = 'visitor_avatar';
  static final String resumeBucketKey = 'visitor_resume';

  static Future<Visitor?> fetchProfile(String visitorId) async {
    try {
      var response =
          await supabase.from(tableKey).select().eq('id', visitorId).single();
      return Visitor.fromJson(response);
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
      var response = await supabase.from(tableKey).insert(visitor.toJson());
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
          .eq('id', visitorId);
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

      await supabase.storage
          .from(resumeBucketKey)
          .uploadBinary(fileName, fileBytes);
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

      await supabase.storage
          .from(avatarBucketKey)
          .uploadBinary(fileName, fileBytes);
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
