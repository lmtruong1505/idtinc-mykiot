import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_list_use_case.dart';
import 'package:pharmago/presentation/features/product_standard/cubit/product_standard_state.dart';
import 'package:pharmago/presentation/features/product_standard/domain/entities/product_standard_entity.dart';
import 'package:pharmago/presentation/features/product_standard/domain/usecase/product_standard_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

@injectable
class ProductStandardCubit extends Cubit<ProductStandardState> {
  ProductStandardCubit(this._useCase, this._productListUseCase)
      : super(const ProductStandardState());

  final ProductStandardUseCase _useCase;
  final ProductListUseCase _productListUseCase;
  final entityILC = InfiniteListController<ProductStandardEntity>.init();
  final productsILC = InfiniteListController<ProductEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<List<ProductStandardEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];

    final list = await _useCase.getList(company, state.search, page);
    emit(state.copyWith(total: state.total + list.length));
    return list;
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    final item =
        id == null ? ProductStandardEntity() : await _useCase.getDetail(id);
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

  void changeDescription(String description) {
    emit(state.copyWith(item: state.item.copyWith(description: description)));
  }

  void create(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, "Xác nhận tiêu chuẩn sản xuất??", () async {
      DialogUtils.showLoadingDialog(context, 'Đang tạo vui lòng đợi!');
      final res = await _useCase.create(state.item);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content:
                'Bạn đã tạo tiêu chuẩn sản xuất thành công.\nVui lòng kiểm tra lại thông tin', barrierDismissible: true,);
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Tạo tiêu chuẩn sản xuất thất bại');
      }
    });
  }

  void update(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, "Xác nhận update tiêu chuẩn sản xuất??", () async {
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
            content: 'Cập nhật tiêu chuẩn sản xuất thất bại');
      }
    });
  }

  void delete(BuildContext context, int id, bool back) {
    DialogUtils.showDialogWithTitleAndOptionButton(context,
        "Bạn có chắc muốn xóa TCSX này, hành động này sẽ không thể hoàn tác",
        () async {
      DialogUtils.showLoadingDialog(context, 'Đang xoá TCSX vui lòng đợi!');
      final res = await _useCase.delete(id);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(context,
            content: 'Xoá tiêu chuẩn sản xuất thành công', barrierDismissible: true,);
        if (back) {
          Navigator.of(context).pop();
        } else {
          entityILC.onRefresh();
        }
      } else {
        await DialogUtils.showErrorDialog(context,
            content: 'Xoá tiêu chuẩn sản xuất thất bại');
      }
    });
  }
}
