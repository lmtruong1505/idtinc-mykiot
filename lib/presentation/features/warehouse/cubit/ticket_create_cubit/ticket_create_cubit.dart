import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_use_case.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import 'ticket_create_state.dart';

@injectable
class TicketCreateCubit extends Cubit<TicketCreateState> {
  TicketCreateCubit(this._useCase) : super(const TicketCreateState());

  final WarehouseUseCase _useCase;
  final InfiniteListController<VariantWarehouseEntity> variantsILC =
      InfiniteListController<VariantWarehouseEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<void> getList() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return;
    final input = WarehouseInput(
      search: state.search,
      limit: state.limit,
      page: 1,
      company: company,
    );
    List<WarehouseEntity> warehouses = await _useCase.getList(input);
    List<DropdownMenuItem> warehouseDrops = [];
    for (final item in warehouses) {
      warehouseDrops.add(
        DropdownMenuItem(value: item.id, child: Text(item.title, style: p6)),
      );
    }
    emit(state.copyWith(warehouses: warehouses));
    emit(state.copyWith(warehouseDrops: warehouseDrops));
  }

  Future<void> setVariants(BuildContext context) async {
    final rs = await context.router
        .push(ProductsRoute(idSelecteds: state.idSelecteds));
    if (rs == null) return;
    List<int> idSelecteds = [];
    List<VariantWarehouseEntity> variants = [];
    for (final itemNew in rs as List<VariantWarehouseEntity>) {
      for (final item in state.variants) {
        if (itemNew.id == item.id) {
          idSelecteds.add(item.id);
          variants.add(item);
        }
      }
      if (!idSelecteds.contains(itemNew.id)) {
        idSelecteds.add(itemNew.id);
        variants.add(itemNew);
      }
    }
    emit(state.copyWith(variants: variants));
    emit(state.copyWith(idSelecteds: idSelecteds));
  }

  void setIdSeleceds(List<int> idSelecteds) {
    emit(state.copyWith(idSelecteds: idSelecteds));
  }

  void setState(TicketCreateState state1) {
    emit(state1);
  }

  List<VariantWarehouseEntity> variantSelecteds() {
    return state.variants;
  }

  void searchChange(String value) {
    emit(state.copyWith(search: value));
    variantsILC.onRefresh();
  }

  Future<List<VariantWarehouseEntity>> getVariantList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];
    final input = VariantListInput(
      search: state.search,
      limit: state.limit,
      page: page + 1,
      company: company,
    );
    final variants = await _useCase.getVariantList(input);
    emit(state.copyWith(variants: variants));
    return state.variants;
  }

  void removeVariant(VariantWarehouseEntity item) {
    final variants = List<VariantWarehouseEntity>.from(state.variants);
    variants.remove(item);
    emit(state.copyWith(variants: variants));
    final idSelecteds = List<int>.from(state.idSelecteds);
    idSelecteds.remove(item.id);
    emit(state.copyWith(idSelecteds: idSelecteds));
  }

  void changeStatus(int id, bool value) {
    final idSelecteds = List<int>.from(state.idSelecteds);
    value ? idSelecteds.add(id) : idSelecteds.remove(id);
    emit(state.copyWith(idSelecteds: idSelecteds));
  }

  Future<void> changeBatchs(BuildContext context, VariantWarehouseEntity item,
      int index, bool isAdd) async {
    List<BatchEntity> batchs = [];
    batchs.addAll(item.batchs);
    if (batchs.isEmpty || isAdd) batchs.add(BatchEntity());
    final rs =
        await context.router.push(BatchCreateRoute(item: item, batchs: batchs));
    if (rs == null) return;
    final variants = List<VariantWarehouseEntity>.from(state.variants);
    variants[index] = variants[index].copyWith(batchs: rs as List<BatchEntity>);
    emit(state.copyWith(variants: variants));
  }

  void changeCode(String code) {
    emit(state.copyWith(code: code));
  }

  void changeNote(String note) {
    emit(state.copyWith(note: note));
  }

  void changeSupplierId(int? supplierId) {
    emit(state.copyWith(supplierId: supplierId!));
  }

  void changeWarehouseId(dynamic warehouseId) {
    emit(state.copyWith(warehouseId: warehouseId));
  }

  void onTapDone(BuildContext context) async {
    List<VariantWarehouseEntity> variants = [];
    for (final item in state.variants) {
      if (state.idSelecteds.contains(item.id)) variants.add(item);
    }
    Navigator.of(context).pop(variants);
  }

  void createWarehouse(BuildContext context) async {
    DialogUtils.showLoadingDialog(context, 'Đang thêm dữ liệu, vui lòng đợi!');
    List<BatchEntity> batchs = [];
    for (final item in state.variants) {
      for (final b in item.batchs) {
        batchs.add(b.copyWith(variantId: item.id));
      }
    }
    final res = await _useCase.create(WarehouseCreateInput(
        code: state.code,
        type: "IMPORT",
        status: "NEW",
        note: state.note,
        totalPrice: 100000,
        exportTo: 1,
        importFrom: 1,
        warehouse: state.warehouseId,
        batchs: batchs));
    Navigator.of(context).pop();
    if (res.response.code == 200) {
      await DialogUtils.showSuccessDialog(
        context,
        content:
            'Bạn đã tạo đơn nhập kho thành công. Vui lòng kiểm tra lại thông tin!',
        barrierDismissible: true,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      DialogUtils.showErrorDialog(context,
          content: res.response.message ?? 'Tạo phiếu nhập kho thất bại');
    }
  }

  Future<void> getTicket(BuildContext context, int id) async {
    final ticket = await _useCase.getTicket(id);
    if (ticket == null) Navigator.of(context).pop();
    emit(state.copyWith(ticket: ticket));
  }

  Future<void> saveStatus(BuildContext context, int id) async {
    DialogUtils.showLoadingDialog(
        context, 'Thay đổi trạng thái, vui lòng đợi!');
    final res = await _useCase.updateTicketStatus(id, 'COMPLETE');
    Navigator.of(context).pop();
    if (res.code == 200) {
      await DialogUtils.showSuccessDialog(
        context,
        content: 'Thay đổi trạng tái thành công!',
        barrierDismissible: true,
      );
      Navigator.of(context).pop();
    } else {
      DialogUtils.showErrorDialog(context,
          content: 'Thay đổi trạng tái không thành công');
    }
  }
}
