import 'package:bloc/bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/ingredient_v2_model.dart';

import '../enum/bloc_status.dart';

class ConfigIngredientBloc extends Cubit<CubitState> {
  ConfigIngredientBloc() : super(CubitState());

  final List<IngredientV2Model> _list = [];
  set list(List<IngredientV2Model> value) {
    _list.clear();
    _list.addAll(value);
    emit(state.copyWith(status: BlocStatus.success));
  }
  List<IngredientV2Model> get list => _list;

  void addTypes(IngredientV2Model value) {
    _list.add(value);
    emit(state.copyWith(status: BlocStatus.success));
  }

  void remove(int index) {
    _list.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }

  void update(int index, IngredientV2Model value) {
    _list[index] = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

}