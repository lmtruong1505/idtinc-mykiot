import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';

import '../../../features/customer/data/models/customer_group_model.dart';
import '../../../features/customer/domain/repositories/customer_group_repository.dart';
import '../../models/local_model.dart';
import '../state/init_state.dart';

class CustomerGroupsBloc extends Cubit<CubitState> {
  CustomerGroupsBloc() : super(CubitState());

  final List<LocalModel> list = [];
  final _repo = getIt<CustomerGroupRepository>();

  LocalModel? value;
  setValue(LocalModel? val) {
    value = val;
    emit(state.copyWith(status: BlocStatus.success));
  }

  getList() async {
    emit(state.copyWith(status: BlocStatus.loading));
    list.clear();
    final response = await _repo.getList(
      company: getCompany,
      limit: 10000,
      page: 1,
    );

    list.addAll(_mapData(response.data ?? []));

    emit(state.copyWith(status: BlocStatus.success));
  }

  List<LocalModel> _mapData(List<CustomerGroupModel> data) {
    return data
        .map(
          (e) => LocalModel(
            id: e.id,
            name: e.name,
          ),
        )
        .toList();
  }
}
