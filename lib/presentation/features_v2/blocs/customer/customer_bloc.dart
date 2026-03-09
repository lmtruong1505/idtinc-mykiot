import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/customer/domain/repositories/customer_repository.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/param/customer_param.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../enum/bloc_status.dart';
import '../state/cubit_state.dart';

class CustomerBloc extends Cubit<CubitState> {
  CustomerBloc() : super(CubitState());
  final _repo = getIt<CustomerRepository>();

  final List<FileModel> files = [];

  CustomerModel? _customer;
  CustomerModel? get customer => _customer;

  create(
    CustomerParam param, {
    int? id,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final address = {
      'lat': param.customer?.address?.latitude,
      'lng': param.customer?.address?.longitude,
      'province': param.customer?.address?.address?.province?.code,
      'district': param.customer?.address?.address?.district?.code,
      'ward': param.customer?.address?.address?.ward?.code,
      'title': param.customer?.address?.address?.address,
    };
    final contactAddress = {
      'lat': param.relation?.address?.latitude,
      'lng': param.relation?.address?.longitude,
      'province': param.relation?.address?.address?.province?.code,
      'district': param.relation?.address?.address?.district?.code,
      'ward': param.relation?.address?.address?.ward?.code,
      'title': param.relation?.address?.address?.address,
    };

    address.removeWhere((key, value) => value == null);
    contactAddress.removeWhere((key, value) => value == null);
    final payload = {
      'company': getCompany,
      'code': param.customer?.customerCode?.trim(),
      'name': param.customer?.customerName?.trim(),
      'phone': param.customer?.customerPhone?.trim(),
      'address': address.isEmpty ? null : address,
      'birthday': param.customer?.dateOfBirth,
      'gender': param.customer?.gender,
      //'group': param.customer?.customerGroup,
      'email': param.customer?.email,

      'contact_name': param.relation?.fullname,
      'contact_title': param.relation?.prefixName,
      'contact_phone': param.relation?.phoneNumber,
      'contact_email': param.relation?.email,
      'contact_address': contactAddress.isEmpty ? null : contactAddress,
      'account_number': param.bank?.bankNumber,
      'bank_name': param.bank?.bankName,
      'bank_branch': param.bank?.bankBranch,

      'title': param.addition?.prefixName,
      'license': param.addition?.identifyNumber,
      'issued_by': param.addition?.providedPlace,
      'license_date': param.addition?.providedDate,
    };
    payload.removeWhere((key, value) => value == null);

    final res = id == null
        ? await _repo.create(payload)
        : await _repo.update(id, payload);

    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          msg: '${id != null ? "Cập nhật" : 'Tạo'} khách hàng thành công',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ??
              '${id != null ? "Cập nhật" : 'Tạo'} khách hàng không thành công',
        ),
      );
    }
  }

  fastCreate({
    required String phone,
    required String name,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final payload = {
      'company': getCompany,
      'name': name.trim(),
      'phone': phone.trim(),
    };
    final res = await _repo.create(payload);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
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

  detail(int id) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getDetail(id);
    _customer = res.data;
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  getFile({
    required int customerId,
    required TypeFileCustomer type,
  }) async {
    files.clear();
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getFile(
      customerId: customerId,
      type: type.code,
    );
    files.addAll(res.data ?? []);
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }
}
