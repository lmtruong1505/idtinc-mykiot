import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecase/banner_get_use_case.dart';
import 'banner_state.dart';

@singleton
class BannerCubit extends Cubit<BannerState> {
  BannerCubit(
    this._bannerGetUseCase,
  ) : super(const BannerState()) {
    getBanner();
  }

  final BannerGetUseCase _bannerGetUseCase;

  void getBanner() async {
    final res = await _bannerGetUseCase.execute(
      BannerGetInput(typeBanner: 'ADVERTISE'),
    );
    emit(
      state.copyWith(
        urls: res.response.data ?? [],
      ),
    );
  }
}
