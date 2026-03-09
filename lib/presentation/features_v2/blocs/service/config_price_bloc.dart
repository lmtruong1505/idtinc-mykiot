part of 'bloc_index.dart';

class ConfigPriceBloc extends Cubit<CubitState> {
  ConfigPriceBloc() : super(CubitState());

  List<ServiceTypeV2Model> _list = [];
  List<ServiceTypeV2Model> get list => _list;

  bool get isError {
    final mapData = list
        .map((e) => e.prices?.map((e) => e.isActive) ?? [])
        .expand((element) => element)
        .toList();

    return !mapData.contains(true);
  }

  void addTypes(List<ServiceTypeV2Model> value) {
    _list = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void remove(int index) {
    _list.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }

  void setPriceDefault(int index, int index2) {
    _list = _list
        .map(
          (e) => e.copyWith(
            prices: e.prices
                ?.map(
                  (e) => e.copyWith(isActive: false),
                )
                .toList(),
          ),
        )
        .toList();
    _list[index].prices?[index2].isActive = true;

    emit(state.copyWith(status: BlocStatus.success));
  }

  void removePrice(int index, int index2) {
    _list[index].prices?.removeAt(index2);
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<PriceServiceModel> get mapDataPrices {
    final List<PriceServiceModel> data = [];

    for (final element in _list) {
      final prices = element.prices ?? [];
      for (final price in prices) {
        data.add(
          PriceServiceModel(
            price: price.price,
            isDefault: price.isActive,
            title: price.priceName,
            totalSession: price.count,
            type: element.type,
            priceName: price.type?.title,
            priceType: price.type?.type,
            id: price.id,
          ),
        );
      }
    }
    return data;
  }
}
