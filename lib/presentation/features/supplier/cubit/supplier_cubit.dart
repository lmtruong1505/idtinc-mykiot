import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import 'package:pharmago/presentation/features/supplier/cubit/supplier_state.dart';
import 'package:pharmago/presentation/features/supplier/domain/entities/supplier_entity.dart';
import 'package:pharmago/presentation/features/supplier/domain/usecase/supplier_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

@injectable
class SupplierCubit extends Cubit<SupplierState> {
  SupplierCubit(this._useCase) : super(const SupplierState());

  final SupplierUseCase _useCase;
  final entityILC = InfiniteListController<SupplierEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<List<SupplierEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];

    final list = await _useCase.getList(company, state.search, page);
    emit(state.copyWith(total: list.length));
    return list;
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    final supplier =
        id == null ? SupplierEntity() : await _useCase.getDetail(id);
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) Navigator.of(context).pop();
    emit(state.copyWith(
        supplier: supplier.copyWith(company: company!.toString())));
  }

  void changeSearch(String value) {
    emit(state.copyWith(search: value));
    entityILC.onRefresh();
  }

  void changeCode(String code) {
    emit(state.copyWith(supplier: state.supplier.copyWith(code: code)));
  }

  void changeName(String name) {
    emit(state.copyWith(supplier: state.supplier.copyWith(name: name)));
  }

  void changeDeputyName(String deputyName) {
    emit(state.copyWith(
        supplier: state.supplier.copyWith(deputyName: deputyName)));
  }

  void changePhone(String phone) {
    emit(state.copyWith(supplier: state.supplier.copyWith(phone: phone)));
  }

  void changeEmail(String email) {
    emit(state.copyWith(supplier: state.supplier.copyWith(email: email)));
  }

  void updateAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    final address = AddressEntity(
        province: province, district: district, ward: ward, title: detail);
    emit(state.copyWith(supplier: state.supplier.copyWith(address: address)));
  }

  void create(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, "Xác nhận tạo nhà cung cấp??", () async {
      DialogUtils.showLoadingDialog(context, 'Đang tạo vui lòng đợi!');
      final res = await _useCase.create(state.supplier);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Tạo nhà cung cấp thành công', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Tạo nhà cung cấp thất bại');
      }
    });
  }

  void update(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, "Xác nhận update nhà cung cấp??", () async {
      DialogUtils.showLoadingDialog(context, 'Đang lưu vui lòng đợi!');
      final res = await _useCase.update(state.supplier);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Cập nhật nhà cung cấp thành công', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Cập nhật nhà cung cấp thất bại');
      }
    });
  }

  void delete(BuildContext context, int id) {
    DialogUtils.showDialogWithTitleAndOptionButton(context,
        "Bạn có chắc muốn xóa nhà cung cấp, hành động này sẽ không thể hoàn tác",
        () async {
      DialogUtils.showLoadingDialog(
          context, 'Đang xoá nhà cung cấp vui lòng đợi!');
      final res = await _useCase.delete(id);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Xoá nhà cung cấp thành công', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Xoá nhà cung cấp thất bại');
      }
    });
  }
}
