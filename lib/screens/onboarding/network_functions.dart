import 'package:q_flow/screens/onboarding/onboarding_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../supabase/supabase_visitor.dart';

extension NetworkFunctions on OnboardingCubit {
  Future setExternalId() async {
    try {
      emitLoading();

      dataMgr.visitor!.externalId = Uuid().v4();

      var visitor = await SupabaseVisitor.updateProfile(
        visitor: dataMgr.visitor!,
        visitorId: dataMgr.visitor!.id ?? '',
        resumeFile: null,
        avatarFile: null,
      );

      dataMgr.visitor = visitor;
    } catch (e) {
      rethrow;
    }
  }
}
