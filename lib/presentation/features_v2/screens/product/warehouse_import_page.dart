import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/params/warehouse_import_param.dart';
import 'package:pharmago/presentation/features_v2/models/product/unit_v2_model.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/bg/bg_btn_nav_bar.dart';
import '../../../../shared/components/button/double_button.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../../../features/warehouse/cubit/warehouse_cubit.dart';
import '../../../features/warehouse/cubit/warehouse_state.dart';
import '../../blocs/product/warehouse_bloc.dart';
import '../../models/product/product_v2_model.dart';

@RoutePage()
class WarehouseImportPage extends StatefulWidget {
  const WarehouseImportPage({super.key, required this.model});

  //final ProductDetailBloc bloc;
  final ProductV2Model model;

  @override
  State<WarehouseImportPage> createState() => _WarehouseImportPageState();
}

class _WarehouseImportPageState extends State<WarehouseImportPage> {
  late UnitV2Model? unit;
  final key = GlobalKey<FormState>();
  final param = WarehouseImportParam();
  final bloc = WarehouseBloc();
  final _warehouseCubit = getIt.get<WarehouseCubit>();
  late int valueUnit;

  @override
  void initState() {
    bloc.model = widget.model;
    unit = widget.model.unitSell ??
        widget.model.unit.where((element) => element.sellUnit == true).first;
    param.product = widget.model.id;
    valueUnit = widget.model.getLevelUnit(unit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _warehouseCubit..getList(0),
      child: Scaffold(
        appBar: AppBarCustom(
          title: 'Quản lý sản phẩm',
          subTitle: 'Nhập kho',
        ),
        body: Form(
          key: key,
          child: Container(
            padding: 16.pading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputColumn(
                    label: 'Số lượng nhập kho',
                    isRequired: true,
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                        locale: 'vi',
                        symbol: '',
                      ),
                    ],
                    onChanged: (value) {
                      final quantity = value.removeAllDot().toInt ?? 0;
                      param.initialStock = quantity;
                    },
                    padding: 0.pading,
                    suffixIcon: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.bg_secondary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      margin: 1.pading,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const VerticalDivider(
                            color: AppColors.input_borderDefault,
                            thickness: 1,
                            width: 0,
                          ).size(height: 48),
                          16.width,
                          Text(
                            unit?.name ?? '',
                          ),
                          16.width,
                          // const Icon(
                          //   Icons.arrow_drop_down_outlined,
                          //   color: AppColors.fg_quaternary,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  16.height,
                  InputColumn(
                    label: 'Giá nhập',
                    isRequired: true,
                    padding: 0.pading,
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                        locale: 'vi',
                        symbol: '',
                      ),
                    ],
                    onChanged: (value) {
                      param.importPrice = value.removeAllDot().toDouble;
                    },
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        16.width,
                        FaIcon(
                          iconCode: 'e169',
                          color: AppColors.input_iconDefault,
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  RichText(
                    text: TextSpan(
                      text: 'Kho nhập hàng',
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.input_label,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.text_warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  BlocBuilder<WarehouseCubit, WarehouseState>(
                    builder: (context, state) {
                      return CommonDropdown(
                        items: _warehouseCubit.warehousesSelected,
                        hintText: 'Chọn kho nhập hàng',
                        onChanged: (value) {
                          param.warehouse = value?.id;
                        },
                      );
                    },
                  ),
                  // SwitchLabel(
                  //   label: 'Đang bán',
                  //   value: true,
                  //   onChanged: (val) {
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  BgBtnNavBar _buildBottom() {
    return BgBtnNavBar(
      child: DoubleButton(
        cancelText: 'Hủy bỏ',
        confirmText: 'Xác nhận',
        onCancel: () {
          context.router.maybePop();
        },
        onConfirm: () {
          if (!key.currentState!.validate()) {
            return;
          }
          if (param.importPrice.validator > (unit?.sellPrice ?? 0)) {
            ToastCustom.show2(
              context,
              title: 'Cảnh báo',
              msg: 'Giá nhập của lô hàng mới cao hơn giá bán hiện tại!',
              svgIcon: Assets.svgWarningOutline,
              color: AppColors.fg_warning,
              onConfirm: () {
                _handle();
              },
            );
          } else {
            _handle();
          }
        },
      ),
    );
  }

  void _handle() {
    DialogUtils.showLoadingDialog(context, 'Đang tải...');
    bloc.warehouseImport(param).then((value) {
      context.pop();
      if (value.code == 200) {
        ToastCustom.show(
          context,
          title: 'Thành công',
          msg: 'Nhập kho thành công',
          svgIcon: Assets.svgSuccess,
          color: AppColors.ultility_positive_60,
          timeClose: 2.seconds,
        );
        context.pop(result: true);
      } else {
        ToastCustom.show(
          context,
          title: 'Thất bại',
          msg: value.message ?? '',
          svgIcon: Assets.svgWarningOutline,
          color: AppColors.ultility_negative_60,
        );
      }
    });
  }
}
