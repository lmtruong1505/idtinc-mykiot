import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/screens/create_warehouse_receipt_page.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../base/select.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../features_v2/models/employee/user_data_model.dart';
import '../../address/screens/select_address.dart';
import '../cubit/warehouse_create_cubit/warehouse_create_cubit.dart';
import '../cubit/warehouse_create_cubit/warehouse_create_state.dart';
import '../domain/entities/warehouse_entity.dart';

@RoutePage()
class WarehouseCreatePage extends StatefulWidget {
  const WarehouseCreatePage({
    super.key,
    this.warehouse,
  });

  final WarehouseEntity? warehouse;

  @override
  State<WarehouseCreatePage> createState() => _WarehouseCreatePageState();
}

class _WarehouseCreatePageState extends State<WarehouseCreatePage> {
  final myBloc = getIt.get<WarehouseCreateCubit>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.warehouse != null) {
      myBloc.infoChange(
        name: widget.warehouse?.title,
        code: widget.warehouse?.code,
        manager: widget.warehouse?.userManageData,
        typeWarehouse: TypeWarehouse.values.firstWhereOrNull(
          (e) => e.codePayload == widget.warehouse?.typeWarehouseData?['id'],
        ),
        listEmployee: widget.warehouse?.warehouseStaffData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WarehouseCreateCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<WarehouseCreateCubit, WarehouseCreateState>(
        builder: (context, state) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBarCustom(
              onBack: () => context.pop(),
              height: 90,
              title: 'Quản lý kho',
              subTitle:
                  widget.warehouse != null ? 'Chỉnh sửa kho' : 'Tạo mới kho',
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(sp16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInputSupport(
                      initialValue: state.payload.name,
                      label: 'Tên kho',
                      hintText: 'Nhập tên kho',
                      backgroundColor: whiteColor,
                      borderColor: borderColor_3,
                      onChanged: (value) => myBloc.infoChange(name: value),
                      radius: sp12,
                      required: true,
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập tên kho';
                        }
                        return null;
                      },
                    ),
                    gapHeight(sp12),
                    Row(
                      children: [
                        Expanded(
                          child: AppInputSupport(
                            initialValue: state.payload.code,
                            label: 'Mã kho',
                            required: true,
                            hintText: 'Nhập mã kho',
                            backgroundColor: whiteColor,
                            borderColor: borderColor_3,
                            onChanged: (value) => myBloc.infoChange(
                              code: value,
                            ),
                            radius: sp12,
                            validate: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Vui lòng nhập mã kho';
                              }
                              return null;
                            },
                          ),
                        ),
                        sp16.width,
                        Expanded(
                          child: AppInputSupport(
                            label: 'Diện tích kho',
                            hintText: 'Nhập diện tích ',
                            backgroundColor: whiteColor,
                            borderColor: borderColor_3,
                            radius: sp12,
                            onChanged: (value) =>
                                myBloc.infoChange(code: value),
                            suffixIcon: Container(
                              width: sp48,
                              decoration: BoxDecoration(
                                color: AppColors.bg_secondary,
                                border: Border.all(color: borderColor_3),
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(sp12),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'm²',
                                  style: s12w500.copyWith(
                                    color: AppColors.text_secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapHeight(sp16),
                    CommonDropdown(
                      showIconRemove: false,
                      value: state.typeWarehouse,
                      borderColor: AppColors.input_borderDefault,
                      items: List.generate(
                        TypeWarehouse.values.length,
                        (index) => DropdownMenuItem(
                          value: TypeWarehouse.values[index],
                          child: Text(
                            TypeWarehouse.values[index].title,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        myBloc.infoChange(typeWarehouse: value);
                      },
                      required: true,
                      label: 'Loại kho',
                      hintText: 'Chọn loại kho',
                      color: AppColors.white,
                    ),
                    gapHeight(sp16),
                    CommonDropdown(
                      showIconRemove: false,
                      value: state.manager,
                      borderColor: AppColors.input_borderDefault,
                      items: List.generate(
                        state.listUser.length,
                        (index) => DropdownMenuItem(
                          value: state.listUser[index],
                          child: Text(
                            state.listUser[index].fullName ?? '',
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        myBloc.infoChange(manager: value);
                      },
                      required: true,
                      label: 'Quản lý kho',
                      hintText: 'Chọn quản lý',
                      color: AppColors.white,
                    ),
                    gapHeight(sp16),
                    CommonDropdown(
                      showIconRemove: false,
                      borderColor: AppColors.input_borderDefault,
                      items: List.generate(
                        state.listUser.length,
                        (index) => DropdownMenuItem(
                          value: state.listUser[index],
                          child: Text(
                            state.listUser[index].fullName ?? '',
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        final listCopy =
                            List<UserDataModel>.from(state.listEmployee);
                        if (listCopy.contains(value)) {
                          listCopy.remove(value);
                        } else {
                          listCopy.add(value);
                        }
                        myBloc.infoChange(listEmployee: listCopy);
                      },
                      label: 'Nhân viên kho',
                      hintText: 'Chọn nhân viên kho',
                      color: AppColors.white,
                    ),
                    gapHeight(sp8),
                    Wrap(
                      children: state.listEmployee.map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: sp4,
                            horizontal: sp8,
                          ),
                          margin: const EdgeInsets.only(right: sp8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp8),
                            color: AppColors.grey10,
                            border: Border.all(
                              color: AppColors.border_tertiary,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e.fullName ?? '',
                              ),
                              sp4.width,
                              GestureDetector(
                                onTap: () {
                                  final listCopy = List<UserDataModel>.from(
                                    state.listEmployee,
                                  );
                                  listCopy.remove(e);
                                  myBloc.infoChange(listEmployee: listCopy);
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: sp20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    gapHeight(sp16),
                    AppInputSupport(
                      label: 'Địa chỉ kho',
                      hintText: 'Chọn địa chỉ',
                      readOnly: true,
                      backgroundColor: bg_5,
                      borderColor: bg_5,
                      radius: sp12,
                      maxLines: 1,
                      controller: TextEditingController(
                        text: state.addressEntity.province == null
                            ? ''
                            : SelectAddressView.formatAddress(
                                state.addressEntity,
                              ),
                      ),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(sp16),
                          ),
                        ),
                        builder: (context) => SizedBox(
                          height: 0.9 * heightDevice(context),
                          child: SelectAddressView(
                            onConfirm: myBloc.updateAddress,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: TwoButtonBox(
              mainTitle: widget.warehouse == null ? 'Tạo mới' : 'Cập nhật',
              extraTitle: 'Huỷ bỏ',
              mainOnTap: _createWarehouse,
              extraOnTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
  }

  void _createWarehouse() async {
    final validate = _formKey.currentState!.validate();
    if (!validate) return;
    if (myBloc.state.listEmployee.isEmpty || myBloc.state.manager == null) {
      DialogUtils.showWarningDialog(
        context,
        content: 'Vui lòng chọn quản lý kho và nhân viên kho',
      );
    }
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo kho, vui lòng đợi',
    );
    final value = widget.warehouse == null
        ? await myBloc.createWarehouse()
        : await myBloc.updateWarehouse(widget.warehouse!.id);

    if (!mounted) return;
    Navigator.of(context).pop();
    if (value.code == 200) {
      DialogUtils.showSuccessDialog(
        context,
        content: widget.warehouse == null
            ? 'Tạo kho thành công'
            : 'Cập nhật thành công',
        titleClose: 'Danh sách',
        titleConfirm: 'Chi tiết',
        close: () => Navigator.of(context)
          ..pop()
          ..pop(),
        accept: () {
          Navigator.of(context)
            ..pop()
            ..pop();
          if (widget.warehouse == null) {
            context.router.push(
            WarehouseDetailRoute(warehouse: value.data!),
          );
          }
        },
      );
      return;
    }
    DialogUtils.showErrorDialog(
      context,
      content: 'Tạo kho thất bại ${value.message}',
    );
  }
}

enum TypeWarehouse {
  kgd('Kho giao dịch', 1),
  knb('Kho nội bộ', 2);

  final String title;
  final int codePayload;
  const TypeWarehouse(this.title, this.codePayload);
}
