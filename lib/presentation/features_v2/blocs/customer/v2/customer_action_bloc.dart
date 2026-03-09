import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features_v2/models/customer/v2/create_model.dart';

import '../../../models/customer/v2/customer_point_item_model.dart';
import '../../../repositories/customer/customer_repository_v2.dart';
import '../../state/init_state.dart';

class CustomerActionV2Bloc extends Cubit<CubitState> {
  CustomerActionV2Bloc() : super(CubitState());

  final _repo = CustomerRepositoryV2();

  List<CustomerPointItemModel> _listPoints = [];

  List<CustomerPointItemModel> get listPoints => _listPoints;

  void create(CreateCustomerV2Model param) async {
    emit(state.copyWith(status: BlocStatus.loading));
    param.company = getCompanyId;
    final res = await _repo.create(param);
    if (res.code == 200 && res.data != null) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: res.data,
          msg: 'Tạo khách hàng thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Tạo khách hàng không thành công',
        ),
      );
    }
  }

  void update(int id, CreateCustomerV2Model param) async {
    emit(state.copyWith(status: BlocStatus.loading));
    param.company = getCompanyId;
    final res = await _repo.update(id, param);
    if (res.code == 200 && res.data != null) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: res.data,
          msg: 'Cập nhật khách hàng thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Cập nhật khách hàng không thành công',
        ),
      );
    }
  }

  void delete(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final res = await _repo.delete(id);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: res.data,
          msg: 'Xoá khách hàng thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Xoá khách hàng không thành công',
        ),
      );
    }
  }

  void detail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detail(id);
    if (res.code == 200 && res.data?.id != null) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          data: res.data,
          msg: 'Lấy thông tin khách hàng thành công',
        ),
      );
      customerPoint(0);
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Không tìm thấy thông tin khách hàng',
        ),
      );
    }
  }

  void customerPoint(int page) async {
    final res = await _repo.customerPoint(state.data.id, page);
    _listPoints = res.data ?? [];
    emit(
      state.copyWith(
        status: BlocStatus.success,
        data: state.data,
      ),
    );
  }
}
