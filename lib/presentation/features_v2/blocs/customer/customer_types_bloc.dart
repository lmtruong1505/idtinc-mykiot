import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/local_model.dart';
import '../state/init_state.dart';

class CustomerTypesBloc extends Cubit<CubitState> {
  CustomerTypesBloc() : super(CubitState());


  LocalModel? value;
  setValue(LocalModel? val) {
    value = val;
    emit(state.copyWith(status: BlocStatus.success));
  }

  final List<LocalModel> list = [];

  getList() async {
    emit(state.copyWith(status: BlocStatus.loading));
    list.clear();
    // final response = await _repo.getTypes();

    // list.addAll(response.data ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }
}
