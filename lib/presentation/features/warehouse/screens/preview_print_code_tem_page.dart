import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/print_code_tem_cubit_cubit/print_code_tem_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/input/input_qty.dart';
import '../../../base/app_bar.dart';
import '../../../base/barcode_widget.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/colors.dart';
import '../../../features_v2/blocs/print_invoice/print_bloc.dart';
import '../../../router/router.gr.dart';
import '../cubit/print_code_tem_cubit_cubit/print_code_tem_cubit.dart';
import '../data/models/receipt_import_detail_model.dart';

@RoutePage()
class PreviewPrintCodeTemPage extends StatelessWidget {
  PreviewPrintCodeTemPage({
    super.key,
    required this.shipments,
  });

  final List<ReceiptImportDetailModel> shipments;
  final cubit = getIt.get<PrintCodeTemCubit>();
  final printBloc = PrintBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => cubit..init(shipments),
        ),
        BlocProvider(
          create: (context) => printBloc,
        ),
      ],
      child: BlocListener<PrintBloc, CubitState>(
        listener: _listener,
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: BaseAppBar(
            title: 'In mã tem',
            actions: [
              BlocBuilder<PrintCodeTemCubit, PrintCodeTemState>(
                builder: (context, state) {
                  if (state.shipments.indexWhere((e) => e.selected) != -1) {
                    return IconButton(
                      icon: const Icon(
                        Icons.print,
                        color: AppColors.black,
                      ),
                      onPressed: () async {
                        final result = await context.router
                            .push(SelectPrintRoute(bloc: printBloc));
                        if (result is Printer) {
                          printBloc.selectPrinter(result);
                        }
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
          body: _body(context),
          bottomNavigationBar: _bottomNavigationBar,
        ),
      ),
    );
  }

  Widget get _bottomNavigationBar {
    return BlocBuilder<PrintCodeTemCubit, PrintCodeTemState>(
      builder: (context, state) {
        if (state.shipments.indexWhere((e) => e.selected) == -1) {
          return const SizedBox();
        }
        return BlocBuilder<PrintBloc, CubitState>(
          builder: (context, state) {
            if (state.status != BlocStatus.submitSuccess) {
              return const SizedBox();
            }
            return Container(
              decoration: const BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: black5o,
                    offset: Offset(0, -1),
                    spreadRadius: sp4,
                    blurRadius: sp4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(sp16).copyWith(bottom: sp32),
              child: MainButton(
                title: 'In tem mã',
                event: () async {
                  final data = await cubit.dataPrint();
                  printBloc.onPrintData(data);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      height: heightDevice(context),
      padding: const EdgeInsets.symmetric(
        vertical: sp16,
        horizontal: sp16,
      ),
      child: Column(
        children: [
          BlocBuilder<PrintCodeTemCubit, PrintCodeTemState>(
            builder: (context, state) {
              return Row(
                children: [
                  BaseCheckbox(
                    value: cubit.isSelectedAll,
                    onChanged: (value) => cubit.selectAll(),
                  ),
                  sp8.width,
                  Text(
                    'Chọn tất cả (Đã chọn ${shipments.length} sản phẩm)',
                  ),
                ],
              );
            },
          ),
          const Divider(),
          Expanded(
            child: BlocSelector<PrintCodeTemCubit, PrintCodeTemState,
                List<ReceiptImportDetailModel>>(
              selector: (state) {
                return state.shipments;
              },
              builder: (context, shipments) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final data = shipments[index];
                    return _itemView(data);
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: sp24),
                  itemCount: shipments.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemView(ReceiptImportDetailModel data) {
    return GestureDetector(
      onTap: () => cubit.selectShipment(data),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: data.selected ? mainColor : whiteColor,
              width: sp2,
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: sp8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    BaseCacheImage(
                      url: '',
                      width: 36,
                      height: 36,
                      borderRadius: 999.radius,
                    ),
                    8.width,
                    Text(
                      data.productData?.productName ?? '',
                      maxLines: 2,
                      style: s14w500,
                    ).expanded(),
                  ],
                ).expanded(),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ngày sản xuất',
                      style: s12w400.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                    Text(
                      data.startDate.fomatCustom(),
                      style: s12w500.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ).expanded(),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Hạn sử dụng',
                      style: s12w400.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                    Text(
                      data.endDate.fomatCustom(),
                      style: s12w500.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ).expanded(),
              ],
            ),
            12.height,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.code ?? '', style: s14w500),
                    4.height,
                    Text(
                      '${data.storageQuantity.formatCurrency}/${data.inputQuantity.formatCurrency} đơn vị',
                      style: s12w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ),
                16.width,
                Visibility(
                  visible: data.selected,
                  child: InputQuantity(
                    controller: TextEditingController(
                      text: '${data.quantityPrint.toInt()}',
                    ),
                    action: (value) => update(data, value),
                    onChanged: (value) => null,
                    onConfirm: (value) => cubit.quantityChange(
                        data.copyWith(quantityPrint: int.tryParse(value) ?? 0)),
                  ).expanded(),
                ),
              ],
            ),
            AnimatedContainer(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: data.selected ? bg_4 : bg_4.withOpacity(0),
                borderRadius: BorderRadius.circular(sp12),
              ),
              duration: const Duration(milliseconds: 200),
              height: data.selected ? 24 : 0,
              width: 280,
              child: RepaintBoundary(
                key: cubit.keysShipments[data.id],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 140,
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: sp12,
                      ),
                      child: BarcodeWidget(
                        data.id.toString(),
                        const Size(120, 24),
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: sp12,
                      ), 
                      child: BarcodeWidget(
                        data.id.toString(),
                        const Size(120, 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void update(ReceiptImportDetailModel data, bool isPlus) {
    int amount = data.quantityPrint.toInt();
    if (isPlus) {
      amount++;
    } else if (!isPlus && amount > 1) {
      amount--;
    }
    cubit.quantityChange(data.copyWith(quantityPrint: amount));
  }

  void _listener(BuildContext context, CubitState state) {
    if (state.status == BlocStatus.error) {
      DialogUtils.showErrorDialog(
        context,
        content: state.msg,
        accept: () => context.pop(),
        close: () => context.pop(),
      );
    } else if (state.status == BlocStatus.submitSuccess) {
      context.pop();
      DialogUtils.showSuccessDialog(
        context,
        content: state.msg,
        accept: () => context.pop(),
        close: () => context.pop(),
        isClose: false,
      );
    } else if (state.status == BlocStatus.submitFailure) {
      context.pop();
      DialogUtils.showErrorDialog(
        context,
        content: state.msg,
        accept: () => context.pop(),
        close: () => context.pop(),
        isClose: false,
      );
    } else if (state.status == BlocStatus.submit) {
      DialogUtils.showLoadingDialog(context, state.msg);
    }
    // else if (state.status == BlocStatus.success) {
    //   DialogUtils.showLoadingDialog(context, state.msg);
    // }
  }
}
