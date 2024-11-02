import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'send_state.dart';

class SendCubit extends Cubit<SendState> {
  SendCubit() : super(SendInitial());
  late String? userID;

  void setExternalID() {
    emitLoading();

    emitUpdate();
  }

  void emitLoading() => emit(SendLoadingState());
  void emitUpdate() => emit(SendUpdateState());
}
