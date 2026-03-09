import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:pharmago/presentation/base/barcode_widget.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features_v2/blocs/print_invoice/print_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/print_barcode_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/product_list_item.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/color_app.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

@RoutePage()
class PrintBarcodePage extends StatefulWidget {
  const PrintBarcodePage({super.key, required this.prds});
  final List<ProductV2Model> prds;

  @override
  State<PrintBarcodePage> createState() => _PrintBarcodePageState();
}

class _PrintBarcodePageState extends State<PrintBarcodePage> {
  List<ProductV2Model> get list => bloc.list;
  final bloc = PrintBarcodeBloc();
  final printBloc = PrintBloc();
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    bloc.init(widget.prds);
    printBloc.checkBluetoothStatus();
  }

  @override
  void dispose() {
    printBloc.stopScan();
    super.dispose();
  }

  TextEditingController nameCtrl = TextEditingController();

  final debouncer = DelayCallBack();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => bloc,
        ),
        BlocProvider(
          create: (context) => printBloc,
        ),
      ],
      child: BlocListener<PrintBloc, CubitState>(
        listener: _listener,
        child: Scaffold(
          appBar: AppBarTitleCenter(title: 'In Barcode', actions: [
            IconButton(
              icon: const Icon(
                Icons.print,
                color: AppColors.black,
              ),
              onPressed: _onSelectPrint,
            ),
          ]),
          body: BlocBuilder<PrintBarcodeBloc, CubitState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            BaseCheckbox(
                              value: bloc.isPrintName,
                              onChanged: (value) => bloc.onToggleName(),
                            ),
                            const Text('Tên sản phẩm', style: s12w500),
                          ],
                        ).expanded(),
                        8.width,
                        Row(
                          children: [
                            BaseCheckbox(
                              value: bloc.isPrintBarcode,
                              onChanged: (value) => bloc.onToggleBarcode(),
                            ),
                            const Text('Mã barcode', style: s12w500),
                          ],
                        ).expanded(),
                      ],
                    ),

                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            BaseCheckbox(
                              value: bloc.isPrintPrice,
                              onChanged: (value) => bloc.onTogglePrice(),
                            ),
                            const Text('Giá bán', style: s12w500),
                          ],
                        ).expanded(),
                        8.width,
                        Row(
                          children: [
                            BaseCheckbox(
                              value: bloc.isPrintUnit,
                              onChanged: (value) => bloc.onToggleUnit(),
                            ),
                            const Text('Đơn vị tiền', style: s12w500),
                          ],
                        ).expanded(),
                      ],
                    ),

                    8.height,
                    Row(
                      children: [
                        BaseCheckbox(
                          value: bloc.isPrintShopName,
                          onChanged: (value) => bloc.onToggleShopName(),
                        ),
                        const Text(
                          'Tên cửa hàng',
                          style: s12w500,
                        ),
                      ],
                    ),
                    8.height,
                    if (bloc.isPrintShopName)
                      Form(
                        key: key,
                        child: AppInputSupport(
                          controller: nameCtrl,
                          label: 'Tên cửa hàng',
                          hintText: 'Nhập tên cửa hàng',
                          backgroundColor: ColorApp.white,
                          borderColor: ColorApp.greyA7,
                          maxLines: 1,
                          required: true,
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập tên cửa hàng';
                            }
                            return null;
                          },
                          onChanged: (p0) =>
                              debouncer.debounce(() => bloc.setShopName(p0)),
                        ),
                      ),
                    24.height,
                    _buidSelectList(),
                    // 24.height,
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final prd = list[index];
                        if (prd.barcode.isEmptyOrNull) {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  children: [
                                    if (bloc.isPrintShopName) ...[
                                      Text(
                                        nameCtrl.text,
                                        style: s10w400,
                                        textAlign: TextAlign.center,
                                      ),
                                      4.height,
                                    ],
                                    if (bloc.isPrintName) ...[
                                      Text(
                                        prd.name ?? '',
                                        style: s12w700,
                                        textAlign: TextAlign.center,
                                      ),
                                      4.height,
                                    ],
                                    BarcodeWidget(
                                      prd.barcode ?? '',
                                      const Size(150, 30),
                                    ),
                                    if (bloc.isPrintName) ...[
                                      Text(
                                        '${prd.unitSell?.sellPrice.formatCurrency} ${bloc.isPrintUnit ? 'VNĐ' : ''}',
                                        style: s14w700,
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                DividerCustom(),
                            itemCount: prd.quantity ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          );
                        }
                        return SizedBox.fromSize();
                      },
                      separatorBuilder: (context, index) => DividerCustom(),
                      itemCount: list.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                  ],
                ).padding(16.pading),
              );
            },
          ),
          bottomNavigationBar: BlocBuilder<PrintBloc, CubitState>(
            bloc: printBloc,
            builder: (context, state) {
              return Container(
                padding: 16.pading,
                child: Row(
                  children: [
                    if (printBloc.printerSelect != null) ...[
                      ExtraButton(
                        borderColor: AppColors.border_disabled,
                        borderRadius: 999,
                        title: 'Huỷ bỏ',
                        event: () => context.pop(),
                      ).expanded(),
                      16.width,
                      MainButtonV2(
                        radius: 999,
                        title: 'In tem mã (${list.length})',
                        icon: const Icon(Icons.print),
                        onTap: () async {
                          // if (!key.currentState!.validate() &&
                          //     bloc.isPrintShopName) {
                          //   return;
                          // }
                          printBloc.onPrintBarCode(
                            list,
                            bloc.isPrintShopName,
                            bloc.isPrintName,
                            bloc.isPrintBarcode,
                            bloc.isPrintPrice,
                            bloc.isPrintUnit,
                            nameCtrl.text,
                          );
                        },
                      ).expanded(),
                    ] else
                      MainButtonV2(
                        radius: 999,
                        title: 'Chọn máy in',
                        icon: const Icon(Icons.print),
                        onTap: () {
                          // if (!key.currentState!.validate() &&
                          //     bloc.isPrintShopName) {
                          //   return;
                          // }
                          _onSelectPrint();
                        },
                      ).expanded(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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

  Column _buidSelectList() {
    return Column(
      children: [
        if (list.isEmpty == true)
          EmptyComfirm(text: 'Chưa có sản phẩm được chọn')
        else ...[
          ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final prd = list[index];

              return ProductListItem(
                showUpdateStock: true,
                model: prd,
                onUpdate: (p0) => bloc.onUpdatePrd(p0),
              );
            },
            separatorBuilder: (context, index) => DividerCustom(),
            itemCount: bloc.isShow ? (list.length ?? 0) : 1,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
          Row(
            children: [
              DividerCustom().padding(8.padingRight).expanded(),
              InkWell(
                onTap: () => bloc.showHide(),
                child: Row(
                  children: [
                    Icon(
                      bloc.isShow
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                    const Text(
                      'Chọn thêm sản phẩm',
                      style: s12w400,
                    ),
                    Visibility(
                      visible: list.isNotEmpty == true,
                      child: Text(
                        ' (${list.length})',
                        style: s12w400,
                      ),
                    ),
                  ],
                ),
              ),
              DividerCustom().padding(8.padingLeft).expanded(),
            ],
          ).padding(12.padingVer),
        ],
      ],
    );
  }

  void _onSelectPrint() async {
    final result = await context.router.push(SelectPrintRoute(bloc: printBloc));
    if (result is Printer) {
      printBloc.selectPrinter(result);
    }
  }
}
