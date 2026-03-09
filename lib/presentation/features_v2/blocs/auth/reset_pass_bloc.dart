import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/auth/auth_repository.dart';

import '../state/init_state.dart';

class ResetPassBloc extends Cubit<CubitState> {
  ResetPassBloc() : super(CubitState());
  final _repo = AuthRepositoryV2();
  void sendOtp(String phone) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.otpResetPass(phone);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg:
              'Mã OTP đã được gửi tới tài khoản Zalo của số điện thoại: $phone',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Gửi OTP thất bại',
        ),
      );
    }
  }

  void verifyOtp({
    required String otp,
    required String phone,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.verifyResetPass(
      otp: otp,
      phone: phone,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Xác thực OTP thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Xác thực OTP thất bại',
        ),
      );
    }
  }

  void newPass({
    required String password,
    required String phone,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.newPass(phone: phone, password: password);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: 'Thiết lập mật khẩu mới thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Gửi OTP thất bại',
        ),
      );
    }
  }
}
