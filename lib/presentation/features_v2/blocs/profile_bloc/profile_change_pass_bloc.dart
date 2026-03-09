import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/repositories/profile/profile_repository.dart';

import '../../../../data/models/base/response.dart';

class ProfileChangePassBloc extends Cubit<CubitState> {
  ProfileChangePassBloc() : super(CubitState());

  final _repo = ProfileRepository();

  bool _showOldPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;

  bool get showOldPass => _showOldPass;

  bool get showNewPass => _showNewPass;

  bool get showConfirmPass => _showConfirmPass;

  void toggleOldPass() {
    _showOldPass = !_showOldPass;
    emit(CubitState(status: BlocStatus.success));
  }

  void toggleNewPass() {
    _showNewPass = !_showNewPass;
    emit(CubitState(status: BlocStatus.success));
  }

  void toggleConfirmPass() {
    _showConfirmPass = !_showConfirmPass;
    emit(CubitState(status: BlocStatus.success));
  }

  Future<BaseResponseModel> changePass({
    required String oldPass,
    required String newPass,
  }) async {
    final res = await _repo.changePass(
      oldPass: oldPass,
      newPass: newPass,
    );
    return res;
  }
}
