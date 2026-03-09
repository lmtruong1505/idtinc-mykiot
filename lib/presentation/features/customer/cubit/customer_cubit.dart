import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/customer/domain/usecase/customer_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../../data/models/base/response.dart';
import '../../../router/router.gr.dart';
import 'customer_state.dart';

@injectable
class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit(this._useCase) : super(const CustomerState());

  final CustomerUseCase _useCase;

  final scrollController = ScrollController();
  final entityILC = InfiniteListController<CustomerEntity>.init();

  Timer? timerSearch;

  void init({CustomerEntity? dataInit}) {
    if (dataInit == null) return;
    emit(state.copyWith(customer: dataInit));
  }

  void changeSearch(String value) {
    emit(state.copyWith(search: value));
    if (timerSearch != null) {
      timerSearch?.cancel();
    }
    timerSearch = Timer(const Duration(milliseconds: 500), () {
      entityILC.onRefresh();
    });
    timerSearch;
  }

  void selectCustomer(CustomerEntity? value) {
    emit(
      state.copyWith(
        dataSelected: state.dataSelected == value ? null : value,
      ),
    );
  }

  void changeCode(String code) {
    emit(state.copyWith(customer: state.customer.copyWith(code: code)));
  }

  void changeName(String name) {
    emit(state.copyWith(customer: state.customer.copyWith(name: name)));
  }

  void changePhone(String phone) {
    emit(state.copyWith(customer: state.customer.copyWith(phone: phone)));
  }

  void changeEmail(String email) {
    emit(state.copyWith(customer: state.customer.copyWith(email: email)));
  }

  void changeInfo({
    String? contactName,
    String? contactTitle,
    String? contactPhone,
    String? contactEmail,
    String? accountNumber,
    String? bankName,
    String? bankBranch,
  }) {
    emit(
      state.copyWith(
        customer: state.customer.copyWith(
          contactName: contactName ?? state.customer.contactName,
          contactTitle: contactTitle ?? state.customer.contactTitle,
          contactPhone: contactPhone ?? state.customer.contactPhone,
          contactEmail: contactEmail ?? state.customer.contactEmail,
          accountNumber: accountNumber ?? state.customer.accountNumber,
          bankName: bankName ?? state.customer.bankName,
          bankBranch: bankBranch ?? state.customer.bankBranch,
        ),
      ),
    );
  }

  void updateAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    final address = AddressEntity(
      province: province,
      district: district,
      ward: ward,
      title: detail,
      detail: detail,
    );
    emit(state.copyWith(customer: state.customer.copyWith(address: address)));
  }

  void updateContactAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    final address = AddressEntity(
      province: province,
      district: district,
      ward: ward,
      title: detail,
      detail: detail,
    );
    emit(state.copyWith(customer: state.customer.copyWith(contactAddress: address)));
  }

  void changeBirthday(DateTime birthday) {
    emit(state.copyWith(customer: state.customer.copyWith(birthday: birthday)));
  }

  void changeGender(int gender) {
    emit(state.copyWith(customer: state.customer.copyWith(gender: gender)));
  }

  void changeGroup(int group) {
    emit(state.copyWith(customer: state.customer.copyWith(group: group)));
  }

  Future<List<CustomerEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];
    final res = await _useCase.getList(company, state.search, page);
    emit(state.copyWith(total: res.extra ?? 0));
    return res.data ?? [];
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    var customer =
        id == null ? const CustomerEntity() : await _useCase.getDetail(id);
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    // ignore: use_build_context_synchronously
    if (company == null) Navigator.of(context).pop();
    if (customer.company == 0) customer = customer.copyWith(company: company!);
    emit(state.copyWith(customer: customer));
  }

  Future<BaseResponseModel<CustomerEntity>> fastCreate(String name, String phone) async {
    return _useCase.fastCreate(
      phone: name,
      name: phone,
    );
  }

  Future<BaseResponseModel> fastUpdate(CustomerEntity customer) async {
    final res = await _useCase.update(customer);
    return res;
  }

  Future<void> create(BuildContext context) async {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, 'Xác nhận tạo khách hàng??', () async {
      DialogUtils.showLoadingDialog(context, 'Đang tạo vui lòng đợi!');
      final res = await _useCase.create(state.customer);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          titleConfirm: 'Xem chi tiết',
          titleClose: 'Về danh sách',
          accept: () {
            Navigator.of(context).popUntil(
                (route) => route.settings.name == 'CustomerListRoute');
            context.router.push(
              CustomerDetailRoute(id: res.data as int),
            );
          },
          close: () {
            Navigator.of(context).pop();
            context.router.maybePop();
          },
          content:
              'Bạn đã tạo khách hàng thành công.\nVui lòng kiểm tra lại thông tin',
        );
      } else {
        await DialogUtils.showErrorDialog(
          context,
          content: 'Tạo khách hàng thất bại',
        );
      }
    });
  }

  void update(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context, 'Xác nhận update khách hàng??', () async {
      DialogUtils.showLoadingDialog(context, 'Đang lưu vui lòng đợi!');
      final res = await _useCase.update(state.customer);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          content:
              'Bạn đã cập nhật thành công.\nVui lòng kiểm tra lại thông tin',
          barrierDismissible: true,
        );
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(
          context,
          content: 'Cập nhật khách hàng thất bại',
        );
      }
    });
  }

  void delete(BuildContext context, int id) {
    DialogUtils.showDialogWithTitleAndOptionButton(context,
        'Bạn có chắc muốn xóa khách hàng, hành động này sẽ không thể hoàn tác',
        () async {
      DialogUtils.showLoadingDialog(
        context,
        'Đang xoá khách hàng vui lòng đợi!',
      );
      final res = await _useCase.delete(id);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          content: 'Xoá khách hàng thành công',
          barrierDismissible: true,
        );
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(
          context,
          content: 'Xoá khách hàng thất bại',
        );
      }
    });
  }
}
