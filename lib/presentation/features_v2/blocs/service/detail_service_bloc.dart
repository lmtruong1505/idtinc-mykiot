part of 'bloc_index.dart';

class DetailServiceV2Bloc extends Cubit<CubitState> {
  DetailServiceV2Bloc() : super(CubitState());

  final _repo = ServiceV2Repository();

  DetailServiceV2Model _service = DetailServiceV2Model();
  DetailServiceV2Model get service => _service;
  List<ServiceTypeV2Model> groupPrices = [];

  getDetail(
    int id, {
    List<ServiceTypeV2Model> types = const [],
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.detail(id);
    if (res.data != null && res.code == 200) {
      _service = res.data!;

      final pricesData = _service.prices ?? [];

      groupPrices = ServiceTypeV2Model.mapListPrice(types, pricesData);

      emit(state.copyWith(status: BlocStatus.success));
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message ?? 'Không tìm thấy thông tin dịch vụ',
        ),
      );
    }
  }

  updateStatus(bool status) {
    _service.active = status;
    emit(state.copyWith(status: BlocStatus.success));
  }
}
