import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/create_prescription_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../models/prescription/prescription_model.dart';
import 'components/choose_prd.dart';

@RoutePage()
class CreatePrescriptionPage extends StatefulWidget {
  final EventModel item;
  final PrescriptionModel? model;
  const CreatePrescriptionPage({
    required this.item,
    this.model,
  });

  @override
  State<CreatePrescriptionPage> createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  final bloc = CreatePrescriptionBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.param.mbUuid = widget.item.uuid;
    bloc.param.doctorId = widget.item.doctorId;
    bloc.param.company = getCompany;
    bloc.param.customerId = widget.item.customerId;

    if (widget.model != null) {
      bloc.param.code = widget.model?.code;
      bloc.param.diagnostic = widget.model?.diagnostic;
      bloc.setDataItems(widget.model?.items ?? []);
    }
  }

  _handleCreate() async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tải...',
    );
    final res = widget.model == null
        ? await bloc.create()
        : await bloc.update(widget.model?.uuid ?? '');
    Navigator.pop(context);
    if (res.data != null && res.code == 200) {
      DialogUtils.showSuccessDialog(
        context,
        content:
            '${widget.model == null ? "Tạo" : "Cập nhật"} đơn thuốc thành công',
        accept: () => context.pop(result: StatusNoti.SUCCESS),
        titleConfirm: 'Chi tiết',
        close: () => context.pop(),
        isClose: false,
      ).then(
        (value) {
          if (StatusNoti.SUCCESS == value) {
            context.pop(result: res.data);
          }
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content:
            '${widget.model == null ? "Tạo" : "Cập nhật"} đơn thuốc thất bại',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.greyF5,
      appBar: BaseAppBar(
        title:
            widget.model != null ? 'Chỉnh sửa đơn thuốc' : 'Tạo đơn thuốc mới',
      ),
      bottomNavigationBar: MainButtonV2(
        onTap: () async {
          bool isError = false;
          for (final element in bloc.items) {
            if (element.lieuDung.isEmptyOrNull ||
                element.variantId == null ||
                element.quantity == null) {
              isError = true;
            }
          }
          if (!isError && bloc.items.isNotEmpty) {
            _handleCreate();
          } else if (bloc.items.isEmpty) {
            CheckStateBloc.showSnackBar(
              context,
              'Vui lòng chọn sản phẩm cần thiết cho đơn thuốc',
              colorBg: ColorApp.red,
            );
          } else {
            CheckStateBloc.showSnackBar(
              context,
              'Vui lòng nhập đầy đủ thông tin sản phẩm',
              colorBg: ColorApp.red,
            );
          }
        },
        title: 'Lưu',
      ).container(),
      body: BlocBuilder<CreatePrescriptionBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: 16.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputColumn(
                      padding: EdgeInsets.zero,
                      label: 'Mã đơn thuốc',
                      initialValue: widget.model?.code,
                      onChanged: (p0) => bloc.param.code = p0,
                    ),
                    sp16.height,
                    InputColumn(
                      padding: EdgeInsets.zero,
                      label: 'Khách hàng',
                      initialValue: widget.item.customer?.fullName,
                      readOnly: true,
                    ),
                    sp16.height,
                    InputColumn(
                      padding: EdgeInsets.zero,
                      label: 'Chuẩn đoán',
                      initialValue: widget.model?.diagnostic,
                      onChanged: (p0) => bloc.param.diagnostic = p0,
                    ),
                  ],
                ).container(),
                sp16.height,
                if (bloc.items.isNotEmpty) ...[
                  ...List.generate(
                    bloc.items.length,
                    (index) => ChoosePrdPk(
                      item: bloc.items[index],
                      onRemove: () {
                        bloc.removeItem(index);
                      },
                      onChanged: (p0) {
                        bloc.editItem(
                          index: index,
                          item: p0,
                        );
                      },
                    ).padding(16.padingBottom),
                  ),
                ],
                CustomOutlineBtn(
                  onPressed: bloc.addPrd,
                  backgroundColor: ColorApp.white,
                  borderColor: ColorApp.greyE2,
                  title: 'Thêm sản phẩm',
                  icon: const Icon(
                    Icons.add,
                    color: ColorApp.black,
                  ),
                ),
                context.padding.bottom.height,
              ],
            ),
          );
        },
      ),
    );
  }
}
