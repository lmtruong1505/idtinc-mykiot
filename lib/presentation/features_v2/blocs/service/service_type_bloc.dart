part of 'bloc_index.dart';

class ServiceTypeBloc extends Cubit<CubitState> {
  ServiceTypeBloc() : super(CubitState());

  final List<ServiceTypeV2Model> list = [];

  final _repo = ServiceV2Repository();

  getList() async {
    list.clear();
    // if (isAll) {
    //   list.add(ServiceTypeV2Model(title: 'Tất cả'));
    // }
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getType();
    list.addAll(res.data ?? []);

    emit(state.copyWith(status: BlocStatus.success));
  }
}
