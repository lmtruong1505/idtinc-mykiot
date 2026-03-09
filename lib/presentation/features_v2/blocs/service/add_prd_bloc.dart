part of 'bloc_index.dart';

class AddPrdServiceBloc extends Cubit<CubitState> {
  AddPrdServiceBloc() : super(CubitState());

  List<ProductV2Model> searchList = [];
  List<ProductV2Model> _list = [];
  List<ProductV2Model> get list => _list;

  List<int> get ids => _list.map((e) => e.id!).toList();

  setList(List<ProductV2Model> value) {
    print('set: $value');
    searchList = value;
    _list = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void add(List<ProductV2Model> value) {
    print('List:  ${searchList.length}  ${_list.length}');
    print('add: $value');
    _list.addAll(value);
    searchList = _list;
    print('List:  ${searchList.length}  ${_list.length}');
    emit(state.copyWith(status: BlocStatus.success));
  }

  void removeById(int id) {
    _list.removeWhere(
      (element) => element.id == id,
    );
    searchList.removeWhere(
      (element) => element.id == id,
    );
    emit(state.copyWith(status: BlocStatus.success));
  }

  filterPrd(String value) {
    searchList = _list
        .where((prd) => prd.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    emit(state.copyWith(status: BlocStatus.success));
  }

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  set tabIndex(int val) {
    _tabIndex = val;
    emit(state.copyWith(status: BlocStatus.success));
  }
}
