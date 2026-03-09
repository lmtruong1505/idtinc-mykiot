import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';

import '../../models/product/unit_v2_model.dart';
import '../enum/bloc_status.dart';

class ConfigSellBloc extends Cubit<CubitState> {
  ConfigSellBloc() : super(CubitState());

  double _vat = 0;
  double get vat => _vat;

  double _import_price = 0;
  double get import_price => _import_price;
  set import_price(double value) {
    _import_price = value;
  }

  set vat(double value) {
    _vat = value;
  }

  final List<UnitV2Model> _list = [];
  set list(List<UnitV2Model> value) {
    _list.clear();
    _list.addAll(value);
    emit(state.copyWith(status: BlocStatus.success));
  }
  List<UnitV2Model> get list => _list;

  final List<UnitV2Model> _listDelete = [];
  List<UnitV2Model> get listDelete => _listDelete;
  set listDelete(List<UnitV2Model> value) {
    _listDelete.clear();
    _listDelete.addAll(value);
  }
  void addDelete(UnitV2Model value) {
    value.isDelete = true;
    _listDelete.add(value);
  }

  void addTypes(UnitV2Model value) {
    _list.add(value);
    emit(state.copyWith(status: BlocStatus.success));
  }

  void updateUnit(int index, UnitV2Model value) {
    _list[index] = value;
    final base = findBase;
    if(base == null) {
      emit(state.copyWith(status: BlocStatus.success));
    }
    else {
      updatePrice(base.level ?? -1 , base.sellPrice ?? 0, base.importPrice ?? 0, 0);
    }
  }

  void remove(int index) {
    for(int i = index + 1; i < _list.length; i++) {
      _list[i].level =( _list[i].level ?? 0) - 1;
    }
    addDelete(_list[index]);
    _list.removeAt(index);
    final base = findBase;
    if(base == null) {
      emit(state.copyWith(status: BlocStatus.success));
    }
    else {
      updatePrice(base.level ?? -1 , base.sellPrice ?? 0, base.importPrice ?? 0, 0);
    }
  }

  UnitV2Model? get findBase => _list.firstWhereOrNull((element) => element.sellUnit ?? false,);

  void updatePrice(int level, double sell, double import, double vat) {
    final index = _list.indexWhere((element) => element.level == level);
    if (index != -1) {
      _list[index].sellPrice = sell;
      _list[index].importPrice = import;
      _list[index].sellUnit = true;
      for(int i = index + 1; i < _list.length; i++) {
        _list[i].sellPrice = (_list[i - 1].sellPrice ?? 0) / (_list[i].value ?? 0);
        _list[i].sellUnit = false;
      }
      for(int i = index - 1; i >= 0; i--) {
        _list[i].sellPrice = (_list[i + 1].sellPrice ?? 0) * (_list[i + 1].value ?? 0);
        _list[i].sellUnit = false;
      }
      emit(state.copyWith(status: BlocStatus.success));
    }
  }


}
