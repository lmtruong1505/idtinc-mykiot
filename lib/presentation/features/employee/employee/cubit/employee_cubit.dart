import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import 'package:pharmago/presentation/features/authentication/domain/usecase/check_phone_use_case.dart';
import 'package:pharmago/presentation/features/employee/employee/cubit/employee_state.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/usecase/employee_use_case.dart';
import 'package:pharmago/presentation/features/employee/role/domain/usecase/role_use_case.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/usecase/employee_list_use_case.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/presentation/shared/utils/validate.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../authentication/domain/usecase/check_mail_use_case.dart';
import '../domain/entities/employee_entity.dart';

@injectable
class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit(
    this._employeeListUseCase,
    this._useCase,
    this._roleUseCase,
    this._checkPhoneUseCase,
    this._checkEmail,
  ) : super(const EmployeeState());

  final EmployeeListUseCase _employeeListUseCase;
  final EmployeeUseCase _useCase;
  final RoleUseCase _roleUseCase;
  final CheckPhoneUseCase _checkPhoneUseCase;
  final CheckMailUseCase _checkEmail;
  final delay = DelayCallBack(delay: 500.milliseconds);

  final entityILC = InfiniteListController<EmployeeEntity>.init();
  final ScrollController scrollController = ScrollController();

  Future<List<EmployeeEntity>> getList(int page) async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    if (company == null) return [];
    print('search2 ${state.search}');
    final input = EmployeeListInput(
      company: company,
      limit: state.limit,
      page: page,
      search: state.search,
    );
    final list = await _employeeListUseCase.execute(input);
    // emit(state.copyWith(total: list.length));
    return list.response.data ?? [];
  }

  Future<void> getDetail(BuildContext context, int? id) async {
    final employee =
        id == null ? const EmployeeEntity() : await _useCase.getDetail(id);
    emit(state.copyWith(employee: employee));
  }

  Future<void> getRoles() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final res = await _roleUseCase.getList(company!, state.search, 0);
    final list = res
        .map(
          (e) => DropdownMenuItem(
            value: e.id,
            child: Text(
              e.title,
              style: p5.copyWith(color: blackColor),
            ),
          ),
        )
        .toList();
    emit(state.copyWith(roles: list));
  }

  void roleChange(int? value) {
    emit(state.copyWith(employee: state.employee.copyWith(role: value)));
  }

  void changeSearch(String value) {
    delay.debounce(
      () {
        emit(state.copyWith(search: value));
        entityILC.onRefresh();
      },
    );
  }

  void changeActive(bool active) {
    emit(state.copyWith(employee: state.employee.copyWith(active: active)));
  }

  void changeCode(String code) {
    emit(state.copyWith(employee: state.employee.copyWith(code: code)));
  }

  void changeName(String name) {
    emit(
      state.copyWith(employee: state.employee.copyWith(fullName: name)),
    );
  }

  void changePassword(String value) {
    emit(
      state.copyWith(employee: state.employee.copyWith(password: value)),
    );
  }

  void dateChange(List<DateTime?>? dates) {
    if (dates != null) {
      emit(state.copyWith(employee: state.employee.copyWith(dob: dates[0]!)));
    }
  }

  void licenceChange(String value) {
    emit(
      state.copyWith(employee: state.employee.copyWith(password: value)),
    );
  }

  void changePhone(String phone) {
    if (phone.length == 10) {
      final input = CheckPhoneInput(phone: phone);
      _checkPhoneUseCase.execute(input).then((value) {
        if (value.response.code == 200) {
          emit(state.copyWith(isCheckPhone: true));
        } else {
          emit(state.copyWith(isCheckPhone: false));
        }
      });
    }
    emit(
      state.copyWith(
        employee: state.employee.copyWith(
          username: phone,
          accountType: 'EMPLOYEE',
        ),
      ),
    );
  }

  void changeEmail(String email) {
    if (isEmailValid(email)) {
      final input = CheckMailInput(email: email);
      _checkEmail.execute(input).then((value) {
        if (value.response.code == 200) {
          emit(state.copyWith(isCheckEmail: true));
        } else {
          emit(state.copyWith(isCheckEmail: false));
        }
      });
    }
    emit(state.copyWith(employee: state.employee.copyWith(email: email)));
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
    emit(state.copyWith(employee: state.employee.copyWith(address: address)));
  }

  Future<BaseResponseModel<int>> create(BuildContext context) async {
    return _useCase.create(state.employee.copyWith(company: getCompany));
  }

  void update(BuildContext context) {
    DialogUtils.showDialogWithTitleAndOptionButton(
      context,
      'Xác nhận update nhân viên??',
      () async {
        DialogUtils.showLoadingDialog(context, 'Đang lưu vui lòng đợi!');
        final res = await _useCase.update(state.employee);
        Navigator.of(context).pop();
        if (res.code == 200) {
          await DialogUtils.showSuccessDialog(
            context,
            content: 'Cập nhật nhân viên thành công',
            barrierDismissible: true,
          );
          Navigator.of(context).pop();
        } else {
          await DialogUtils.showErrorDialog(
            context,
            content: 'Cập nhật nhân viên thất bại',
          );
        }
      },
    );
  }

  void delete(BuildContext context, int id) {
    DialogUtils.showDialogWithTitleAndOptionButton(
        context,
        'Xác nhận vô hiệu hoá tài khoản?\n'
        'Vô hiệu hoá tài khoản này nhân viên sẽ không truy cập được vào hệ thống',
        () async {
      DialogUtils.showLoadingDialog(
        context,
        'Đang vô hiệu hoá tài khoản vui lòng đợi!',
      );
      final res = await _useCase.delete(id);
      Navigator.of(context).pop();
      if (res.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          content: 'Vô hiệu hoá tài khoản thành công',
          barrierDismissible: true,
        );
        Navigator.of(context).pop();
      } else {
        await DialogUtils.showErrorDialog(
          context,
          content: 'Vô hiệu hoá tài khoản thất bại',
        );
      }
    });
  }
}
