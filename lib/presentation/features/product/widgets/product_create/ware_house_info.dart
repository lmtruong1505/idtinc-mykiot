import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/switch_row.dart';
import 'package:pharmago/presentation/features/product/cubit/product_create_cubit/product_create_state.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../cubit/product_create_cubit/product_create_cubit.dart';

class WarehouseInfo extends StatefulWidget {
  const WarehouseInfo({required this.myBloc, super.key});

  final ProductCreateCubit myBloc;

  @override
  State<WarehouseInfo> createState() => _WarehouseInfoState();
}

class _WarehouseInfoState extends State<WarehouseInfo>
    with AutomaticKeepAliveClientMixin {

  final barcodeController = TextEditingController();
  @override
  void dispose() {
    barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    barcodeController.text = widget.myBloc.state.variantsPayload[0].barcode ?? '';
    return Column(
      children: [
        _buildWarehouseInfo(),
      ],
    );
  }

  Widget _buildWarehouseInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildInput(
                  title: 'Mã vạch',
                  controller: barcodeController,
                  onChange: (value) => widget.myBloc.variantFormChange(
                    index: 0,
                    barcode: value,
                  ),
                  isRequired: false,
                ),
              ),
              8.width,
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: borderColor_2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ),
                    ).then((res) {
                      if (res != null) {
                        barcodeController.text = res ?? '';
                        widget.myBloc.variantFormChange(
                          index: 0,
                          barcode: res.toString(),
                        );
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          8.height,
          _buildInput(
            title: 'Số quyết định',
            isRequired: false,
            initialValue: widget.myBloc.state.variantsPayload[0].decisionNumber,
            onChange: (value) => widget.myBloc.variantFormChange(
              index: 0,
              decisionNumber: value,
            ),
          ),
          8.height,
          _buildInput(
            title: 'Số đăng ký',
            initialValue: widget.myBloc.state.variantsPayload[0].registerNumber,
            onChange: (value) => widget.myBloc.variantFormChange(
              index: 0,
              registerNumber: value,
            ),
            isRequired: false,
          ),
          8.height,
          _buildInput(
            title: 'Tuổi thọ',
            initialValue: widget.myBloc.state.variantsPayload[0].longevity,
            onChange: (value) => widget.myBloc.variantFormChange(
              index: 0,
              longevity: value,
            ),
            isRequired: false,
          ),
          8.height,
          BlocBuilder<ProductCreateCubit, ProductCreateState>(
            builder: (context, state) {
              return SwitchRow(
                title: 'Đang bán',
                value: state.productPayload.active,
                onChanged: (value) {
                  widget.myBloc.infoFormChange(
                    active: value,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String title,
    bool isRequired = false,
    Function()? onTap,
    Function(String)? onChange,
    String? initialValue,
    TextEditingController? controller,
    Icon? suffixIcon,
  }) {
    return AppInputSupport(
      label: title,
      hintText: 'Nhập ${title.toLowerCase()}',
      backgroundColor: whiteColor,
      borderColor: borderColor_2,
      onChanged: onChange,
      onTap: onTap,
      initialValue: initialValue,
      required: isRequired,
      controller: controller,
      readOnly: onTap != null,
      suffixIcon: suffixIcon,
      validate: (value) {
        if ((value?.isEmpty ?? true) && isRequired) {
          return 'Yêu cầu nhập ${title.toLowerCase()}  $isRequired';
        }
        return null;
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
