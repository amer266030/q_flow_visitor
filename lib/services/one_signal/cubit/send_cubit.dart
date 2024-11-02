import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../supabase/client/supabase_mgr.dart';

part 'send_state.dart';

class SendCubit extends Cubit<SendState> {
  SendCubit() : super(SendInitial());
  late String? userID;

  Future<void> setExternalID() async {
    emitLoading();
    await OneSignal.login(Random().nextInt(99999).toString());
    userID = await OneSignal.User.getExternalId();
    // print('userID: $userID');
    await SupabaseMgr.shared.supabase
        .from('visitor')
        .update({'external_id': userID}).eq(
            'id', SupabaseMgr.shared.supabase.auth.currentUser!.id);
    emitUpdate();
  }

  

  void emitLoading() => emit(SendLoadingState());
  void emitUpdate() => emit(SendUpdateState());
}
