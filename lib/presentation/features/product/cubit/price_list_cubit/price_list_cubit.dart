import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/product/domain/entities/inventory_voucher_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/price_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_warehouse_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/inventory_voucher_create_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/price_list_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/unit_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/variant_list_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/variant_warehouse_list_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../screens/product_manager_page.dart';
import 'price_list_state.dart';

@injectable
class PriceListCubit extends Cubit<PriceListState> {
  PriceListCubit(
    this._variantListUseCase,
    this._priceListUseCase,
    this._unitUseCase,
    this._variantWarehouseListUseCase,
    this._inventoryVoucherCreateUsecase,
  ) : super(const PriceListState());

  final PriceListUseCase _priceListUseCase;
  final UnitUseCase _unitUseCase;
  final VariantListUseCase _variantListUseCase;
  final VariantWarehouseListUseCase _variantWarehouseListUseCase;
  final InventoryVoucherCreateUsecase _inventoryVoucherCreateUsecase;

  final InfiniteListController<VariantEntity> priceLibraryILC =
      InfiniteListController<VariantEntity>.init();
  final InfiniteListController<PriceEntity> priceILC =
      InfiniteListController<PriceEntity>.init();
  final ScrollController scrollController = ScrollController();

  void searchChange(String value) {
    emit(state.copyWith(search: value));
    priceILC.onRefresh();
  }

  void tabChange(TabProductManagerPage? value) {
    emit(state.copyWith(tabSelected: value ?? state.tabSelected));
  }

  void quantityActionChange(int? id, int value) {
    final list = List<UnitConversionEntity>.from(state.unit?.conversions ?? []);
    final index = list.indexWhere((e) => e.id == id);
    if (index != -1) {
      list[index] = list[index].copyWith(quantityAction: value);
    }
    final unit = state.unit?.copyWith(conversions: list);
    emit(state.copyWith(unit: unit));
  }

  Future<List<PriceEntity>> getPriceList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = PriceListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final res = await _priceListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<void> getUnit(int id) async {
    final input = UnitInput(idProduct: id);
    final res = await _unitUseCase.execute(input);
    emit(state.copyWith(unit: res.response.data));
  }

  Future<List<VariantEntity>> getVariant(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int? ?? 2;
    final input = VariantListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final res = await _variantListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<List<VariantWarehouseEntity>> getVariantWarehouse(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int? ?? 2;
    final input = VariantWarehouseListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final res = await _variantWarehouseListUseCase.execute(input);
    return res.response.data ?? [];
  }

  Future<BaseResponseModel> importVariant(int variant) async {
    final account =
        AppSharedPreference.instance.getValue(PrefKeys.accountId) as int?;
    final warehouse =
        AppSharedPreference.instance.getValue(PrefKeys.warehouseId) as int?;
    final amount = (state.unit?.conversions ?? []).fold(0, (total, e) {
      total += (e.times ?? 0) * e.quantityAction;
      return total;
    });
    final inventoryVoucherItems = [
      InventoryItemPayloadEntity(
        variant: variant,
        unit: state.unit?.id,
        price: 0,
        quantity: amount,
      )
    ];
    final payload = InventoryVoucherPayloadEntity(
      type: TypeInventoryVoucher.import,
      status: StatusInventoryVoucher.complete,
      account: account ?? 1,
      warehouse: warehouse ?? 1,
      partner: 1,
      reason: 'Nhập hàng vì thiếu hàng',
      note: 'Đã thanh toán, hàng sẵn sàng',
      amount: amount,
      inventoryVoucherItems: inventoryVoucherItems,
    );
    final input = InventoryVoucherCreateInput(payload);
    final res = await _inventoryVoucherCreateUsecase.execute(input);
    return res.response;
  }
}
