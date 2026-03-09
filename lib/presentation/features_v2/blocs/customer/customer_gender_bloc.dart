import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';

import '../state/init_state.dart';

class CustomerGenderBloc extends Cubit<CubitState> {
  CustomerGenderBloc() : super(CubitState());

  final list = GenderEnum.values;

  GenderEnum? value;

  setValue(GenderEnum? val) {
    value = val;
    emit(state.copyWith(status: BlocStatus.success));
  }

  setValueById(int? id) {
    final val = list
        .where(
          (element) => element.code == id,
        )
        .toList();
    if (val.isNotEmpty) {
      value = val.first;
    }
  }

  getList() async {
    // emit(state.copyWith(status: BlocStatus.loading));
    // list.clear();
    // final response = await _repo.getGenders();

    // list.addAll([
    //   LocalModel(id: 1, name: 'Nam'),
    //   LocalModel(id: 1, name: 'Nữ'),
    //   LocalModel(id: 1, name: 'Khác'),
    // ]);

    // emit(state.copyWith(status: BlocStatus.success));
  }
}
