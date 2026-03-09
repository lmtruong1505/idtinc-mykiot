import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_list_use_case.dart';
import 'package:pharmago/presentation/features/register_company/cubit/register_company_state.dart';
import 'package:pharmago/presentation/features/register_company/domain/entities/register_company_entity.dart';
import 'package:pharmago/presentation/features/register_company/domain/usecase/register_company_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

@injectable
class RegisterCompanyCubit extends Cubit<RegisterCompanyState> {
  RegisterCompanyCubit(this._useCase, this._productListUseCase)
      : super(const RegisterCompanyState());

  final RegisterCompanyUseCase _useCase;
  final ProductListUseCase _productListUseCase;
  final entityILC = InfiniteListController<RegisterCompanyEntity>.init();
  final productsILC = InfiniteListController<ProductEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<List<RegisterCompanyEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];

    final list = await _useCase.getList(company, state.search, page);
    emit(state.copyWith(total: state.total + list.length));
    return list;
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    final item =
        id == null ? RegisterCompanyEntity() : await _useCase.getDetail(id);
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) Navigator.of(context).pop();
    emit(state.copyWith(item: item.copyWith(company: company!.toString())));
  }

  Future<List<ProductEntity>> getProducts(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = ProductListInput(
      search: state.search,
      limit: 10,
      page: page + 1,
      company: company,
    );
    final res = await _productListUseCase.execute(input);
    return res.response.data ?? [];
  }

  void changeSearch(String value) {
    emit(state.copyWith(search: value));
    entityILC.onRefresh();
  }

  void changeCode(String code) {
    emit(state.copyWith(item: state.item.copyWith(code: code)));
  }

  void changeName(String name) {
    emit(state.copyWith(item: state.item.copyWith(name: name)));
  }

  void changeCountry(String? country) {
    if (country == null) return;
    emit(state.copyWith(item: state.item.copyWith(country: country)));
  }

  void changeAddress(String address) {
    emit(state.copyWith(item: state.item.copyWith(address: address)));
  }

  void changeDescription(String description) {
    emit(state.copyWith(item: state.item.copyWith(description: description)));
  }

  void create(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, "Xác nhận tạo công ty đăng ký??", () async {
      DialogUtils.showLoadingDialog(context, 'Đang tạo vui lòng đợi!');
      final res = await _useCase.create(state.item);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content:
                'Bạn đã tạo công ty đăng ký thành công.\nVui lòng kiểm tra lại thông tin', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Tạo công ty đăng ký thất bại');
      }
    });
  }

  void update(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, "Xác nhận update công ty đăng ký??", () async {
      DialogUtils.showLoadingDialog(context, 'Đang lưu vui lòng đợi!');
      final res = await _useCase.update(state.item);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content:
                'Bạn đã chỉnh sửa thông tin thành công.\nVui lòng kiểm tra lại thông tin', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Cập nhật công ty đăng ký thất bại');
      }
    });
  }

  void delete(BuildContext context, int id, bool back) {
    DialogUtils.showDialogWithTitleAndOptionButton(context,
        "Bạn có chắc chắn xóa công ty đăng ký? \nThao tác này không thể hoàn tác.",
        () async {
      DialogUtils.showLoadingDialog(
          context, 'Đang xoá công ty đăng ký vui lòng đợi!');
      final res = await _useCase.delete(id);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Xoá công ty đăng ký thành công',barrierDismissible: true,);
        if (back) {
          Navigator.of(context).pop();
        } else {
          entityILC.onRefresh();
        }
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Xoá công ty đăng ký thất bại');
      }
    });
  }
}
