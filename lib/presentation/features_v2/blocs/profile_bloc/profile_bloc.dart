import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/profile/profile_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/profile/profile_repository.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../../data/models/base/response.dart';

class ProfileBloc extends Cubit<CubitState<ProfileModel>> {
  ProfileBloc() : super(CubitState());

  final _repo = ProfileRepository();

  XFile? _avatar;
  XFile? get avatar => _avatar;

  bool _isloadAvatar = false;
  bool get isloadAvatar => _isloadAvatar;

  Future<void> init() async {
    emit(state.copyWith(status: BlocStatus.loading));
    _isloadAvatar = true;
    final res = await _repo.getProfile();
    if (res.code == 200) {
      await AppSharedPreference.instance.setValue(
        PrefKeys.avatar,
        res.data?.avatar,
      );
      await AppSharedPreference.instance.setValue(
        PrefKeys.userFullName,
        res.data?.fullName,
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: res.data,
        ),
      );
    } else {
      emit(state.copyWith(status: BlocStatus.failure, msg: res.message));
    }
    _isloadAvatar = false;
  }

  Future<bool> setAvt(XFile? file) async {
    if (file == null) {
      return false;
    }
    // _isloadAvatar = true;
    // emit(state.copyWith(status: BlocStatus.success));
    // _avatar = file;
    final res = await _repo.changeAvatar(file: file);

    //_isloadAvatar = false;
    if (res.code == 200) {
      emit(state.copyWith(status: BlocStatus.submitSuccess));
      return true;
    } else {
      return false;
    }
  }

  Future<BaseResponseModel> inActiveAccount() async {
    final res = await _repo.inActiveAccount();
    return res;
  }
}
