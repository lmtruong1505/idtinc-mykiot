part of 'bloc_index.dart';

@Singleton()
class ListServiceBloc extends Cubit<CubitState> {
  ListServiceBloc() : super(CubitState(status: BlocStatus.loading));
  final List<ServiceV2Model> list = [];
  final _repo = ServiceV2Repository();
  final _delay = DelayCallBack(delay: 500.milliseconds);

  init() {
    emit(
      CubitState(isFirst: true),
    );
    _page = 1;
    _search = null;
    _type = null;
    _status = null;
    _rangePrice = null;

    getList();
  }

  int _page = 1;
  final int limit = 20;
  String? _search;
  String? get search => _search;

  bool get isFilter =>
      _type?.type != null ||
      _status?.isActive != null ||
      _rangePrice?.min != null ||
      _rangePrice?.max != null;

  setSearch(String? value) {
    _search = value;
    _delay.debounce(
      () {
        getList();
      },
    );
  }

  StatusServiceV2Enum? _status;
  StatusServiceV2Enum? get status => _status;

  RangePriceV2Enum? _rangePrice;
  RangePriceV2Enum? get rangePrice => _rangePrice;

  ServiceTypeV2Model? _type;
  ServiceTypeV2Model? get type => _type;

  setParam({
    StatusServiceV2Enum? statusVal,
    RangePriceV2Enum? rangePriceVal,
    ServiceTypeV2Model? typeVal,
  }) {
    _status = statusVal;
    _rangePrice = rangePriceVal;
    _type = typeVal;
    getList();
  }

  Future<void> getList({
    bool isMore = false,
  }) async {
    if (isMore && list.length < limit) return;
    if (isMore && list.length >= limit) {
      _page++;
    } else {
      _page = 1;
      list.clear();
    }

    emit(state.copyWith(status: BlocStatus.loading));

    final res = await _repo.getList(
      companyId: getCompanyId,
      isActive: _status?.isActive,
      priceMax: _rangePrice?.max,
      priceMin: _rangePrice?.min,
      page: _page,
      search: _search,
      type: _type?.type,
      limit: limit,
    );
    int? count;
    if (res.extra is List) {
      for (final item in res.extra) {
        if (item['code'] == 'ALL') {
          count = int.tryParse(item['value'].toString());
        }
      }
    }

    list.addAll(res.data ?? []);
    final isFirst = list.isEmpty && _search.isEmptyOrNull && !isFilter;

    if (res.data.validator.isEmpty && isMore) {
      _page--;
    }

    emit(
      state.copyWith(
        status: BlocStatus.success,
        total: count,
        isFirst: isFirst,
        //isFirst: state.isFirst && list.isEmpty,
      ),
    );
  }
}
