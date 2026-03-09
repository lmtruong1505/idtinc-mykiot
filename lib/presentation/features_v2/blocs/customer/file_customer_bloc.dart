import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/repositories/customer/customer_repository_v2.dart';

import '../../models/customer/file_model.dart';
import '../enum/enum_bloc.dart';
import '../state/init_state.dart';

class FileCustomerBloc extends Cubit<CubitState> {
  FileCustomerBloc() : super(CubitState());

  final _repo = CustomerRepositoryV2();

  final List<FileModel> list = [];

  getList({
    required int customerId,
    required int companyId,
    String? uuidBill,
    String? uuidEvent,
    TypeFileCustomer? type,
  }) async {
    list.clear();
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getFiles(
      customerId: customerId,
      companyId: companyId,
      type: type,
      uuidBill: uuidBill,
      uuidEvent: uuidEvent,
    );
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
