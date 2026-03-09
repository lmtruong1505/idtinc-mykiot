import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';

class NavHomeBloc extends Cubit<CubitState<TabCodeNav>> {
  NavHomeBloc() : super(CubitState(data: TabCodeNav.home));

  void onChanged(TabCodeNav value) {
    emit(state.copyWith(data: value, status: BlocStatus.reload));
    print('======onChanged====TabCodeNav');
  }
}

enum TabCodeNav {
  home('Trang chủ', 'f015'),
  warehouse('Kho', 'f494'),
  appointment('Lịch hẹn', 'f133'),
  createOrder('Tạo đơn', '2b'),
  order('Đơn hàng', 'e489'),
  menu('Khác', 'f0c9');

  const TabCodeNav(
    this.title,
    this.iconCode,
  );

  final String title;
  final String iconCode;
}
