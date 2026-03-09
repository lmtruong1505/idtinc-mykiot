import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_edit_cubit/warehouse_edit_state.dart';

import '../../../base/app_bar.dart';
import '../../../base/loading.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../address/screens/select_address.dart';
import '../cubit/warehouse_edit_cubit/warehouse_edit_cubit.dart';

@RoutePage()
class WarehouseEditPage extends StatefulWidget {
  const WarehouseEditPage({
    super.key,
    this.id,
  });

  final int? id;

  @override
  State<WarehouseEditPage> createState() => _WarehouseEditPageState();
}

class _WarehouseEditPageState extends State<WarehouseEditPage> {
  final myBloc = getIt.get<WarehouseEditCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: BlocBuilder<WarehouseEditCubit, WarehouseEditState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_5,
            appBar: const BaseAppBar(
              title: 'Chỉnh sửa kho',
            ),
            body: Container(
              width: widthDevice(context),
              margin: const EdgeInsets.all(sp16),
              padding: const EdgeInsets.all(sp16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp12),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.2),
                    blurRadius: sp2,
                  ),
                ],
              ),
              child: state.isLoading
                  ? const Center(
                      child: BaseLoading(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppInput(
                          initialValue: state.warehouseEntity?.code,
                          label: 'Mã kho',
                          hintText: 'Nhập mã kho',
                          backgroundColor: bg_5,
                          borderColor: bg_5,
                          onChanged: (value) => myBloc.infoChange(code: value),
                        ),
                        gapHeight(sp12),
                        AppInput(
                          initialValue: state.warehouseEntity?.title,
                          label: 'Tên kho',
                          required: true,
                          hintText: 'Nhập tên kho',
                          backgroundColor: bg_5,
                          borderColor: bg_5,
                          onChanged: (value) => myBloc.infoChange(name: value),
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
                            text:
                                state.warehouseEntity?.address?.province == null
                                    ? ''
                                    : SelectAddressView.formatAddress(
                                        state.warehouseEntity?.address,
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
            bottomNavigationBar: TwoButtonBox(
              mainTitle: 'Lưu lại',
              extraTitle: 'Huỷ bỏ',
              extraOnTap: Navigator.of(context).pop,
              mainOnTap: _updateHandle,
            ),
          );
        },
      ),
    );
  }

  void _updateHandle() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang cập nhật thông tin',
    );
    myBloc.update().then((value) {
      Navigator.of(context).pop();
      if (value?.code == 200) {
        return DialogUtils.showSuccessDialog(
          context,
          content: 'Chỉnh sửa thành công',
          barrierDismissible: true,
        );
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Chỉnh sửa thất bại',
      );
    });
  }
}
