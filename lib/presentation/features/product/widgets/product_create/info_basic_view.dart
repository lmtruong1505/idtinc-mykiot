import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/widgets/product_create/unit_form_view.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/button.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../cubit/product_create_cubit/product_create_cubit.dart';
import '../../cubit/product_create_cubit/product_create_state.dart';

class InfoBasicView extends StatefulWidget {
  const InfoBasicView({
    super.key,
    required this.myBloc,
    //required this.formKey,
  });

  final ProductCreateCubit myBloc;
 // final GlobalKey<FormState> formKey;

  @override
  State<InfoBasicView> createState() => _InfoBasicViewState();
}

class _InfoBasicViewState extends State<InfoBasicView>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController priceSell;
  late TextEditingController priceImport;
  final List<GlobalKey<FormState>> keys = [];

  @override
  void initState() {
    priceSell = TextEditingController();
    priceImport = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    priceSell.dispose();
    priceImport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ProductCreateCubit, ProductCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: 12.pading,
                margin: 12.pading,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      offset: const Offset(1, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ..._buildBasicInfo(),
                    const Divider(
                      color: borderColor_1,
                    ),
                    ..._buildUnit(state),
                  ],
                ),
              ),
              _buildDescription(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBasicInfo() {
    return [
      _buildInput(
        title: 'Tên sản phẩm',
        isRequired: true,
        initValue: widget.myBloc.state.productPayload.name,
        onChange: (value) => widget.myBloc.infoFormChange(
          name: value,
        ),
      ),
      12.height,
      _buildInput(
        title: 'Mã sản phẩm',
        readOnly: widget.myBloc.state.isUpdate,
        initValue: widget.myBloc.state.productPayload.code,
        onChange: (value) => widget.myBloc.infoFormChange(
          code: value,
        ),
      ),
    ];
  }

  List<Widget> _buildUnit(ProductCreateState state) {
    return [
      _buildInput(
        title: 'Đơn vị tính',
        initValue: state.unitsPayload.name,
        isRequired: true,
        onChange: (value) => widget.myBloc.unitFormChange(
          name: value,
        ),
      ),
      8.height,
      Row(
        children: [
          Expanded(
            child: _buildInput(
              title: 'Giá bán',
              isRequired: true,
              initValue: state.unitsPayload.sellPrice?.toInt().toString().formatCurrency(),
              onChange: (value) => widget.myBloc.unitFormChange(
                sellPrice: double.tryParse(value.removeAllNonNumeric()),
              ),
              isPrice: true,
              textInputType: TextInputType.number,
              validate: (value) {
                if ((value?.isEmpty ?? true)) {
                  return 'Yêu cầu nhập giá bán';
                }
                try {
                  final valueWithoutSymbol = value.removeAllNonNumeric();
                  final sell = double.parse(valueWithoutSymbol);
                  print('===> sell: $sell');
                  print('===> import: ${state.unitsPayload.importPrice}');
                  if (sell <= state.unitsPayload.importPrice!) {
                    return 'Giá bán phải lớn hơn \n giá nhập';
                  }
                } catch (e) {
                  return 'Giá bán không hợp lệ';
                }
                return null;
              },
            ),
          ),
          gapWidth(sp8),
          Expanded(
            child: _buildInput(
              title: 'Giá nhập',
              isPrice: true,
              textInputType: TextInputType.number,
              initValue: state.unitsPayload.importPrice?.toInt().toString().formatCurrency(),
              onChange: (value) => widget.myBloc.unitFormChange(
                importPrice: double.tryParse(value.removeAllNonNumeric()),
              ),
            ),
          ),
        ],
      ),
      8.height,
      _buildInput(
        title: 'Trọng lượng cơ bản (g)',
        isRequired: true,
        textInputType: TextInputType.number,
        isPrice: true,
        initValue: state.unitsPayload.weight?.toInt().toString().formatCurrency(),
        onChange: (value) => widget.myBloc.unitFormChange(
          weight: double.tryParse(value.removeAllNonNumeric()),
          weightUnit: 'g',
        ),
      ),
      Divider(),
      _buildInput(
        title: 'Tồn kho',
        initValue: state.variantsPayload[0].initialInventory?.toInt().toString().formatCurrency(),
        onChange: (value) => widget.myBloc.variantFormChange(
          initialInventory: int.tryParse(value.removeAllNonNumeric()),
          index: 0,
        ),
        isRequired: true,
        isPrice: true,
        validate: (value) {
          if ((value?.isEmpty ?? true)) {
            return 'Yêu cầu nhập tồn';
          }
          return null;
        },
        textInputType: TextInputType.number,
      ),
      const Divider(height: sp24),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return UnitChangeItem(
            myBloc: widget.myBloc,
            index: index,
            //formKey: keys[index],
            onRemove: () {
              keys.removeAt(index);
              widget.myBloc.removeUnitChange(index);
            },
          );
        },
        separatorBuilder: (context, index) => gapHeight(sp16),
        itemCount: state.unitChangesPayload.length,
      ),
      Visibility(
        visible: state.unitChangesPayload.isNotEmpty,
        child: gapHeight(sp16),
      ),
      SizedBox(
        width: double.infinity,
        child: ExtraButton(
          largeButton: false,
          title: 'Thêm đơn vị',
          icon: const Icon(
            Icons.add_rounded,
            size: sp16,
            color: blackColor,
          ),
          event: () {
            keys.add(GlobalKey<FormState>());
            widget.myBloc.addUnitChange();
          },
        ),
      ),
    ];
  }

  Widget _buildDescription() {
    return Container(
      padding: 12.pading,
      margin: 12.pading,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: _buildInput(
        title: 'Mô tả sản phẩm',
        initValue: widget.myBloc.state.productPayload.moTa,
        onChange: (value) {
          widget.myBloc.infoFormChange(
            moTa: value,
          );
        },
      ),
    );
  }

  Widget _buildInput({
    required String title,
    bool isRequired = false,
    Function()? onTap,
    String? initValue,
    Function(String)? onChange,
    TextEditingController? controller,
    Icon? suffixIcon,
    String? Function(String? value)? validate,
    TextInputType? textInputType,
    bool? isPrice = false,
    bool? readOnly = false,
  }) {
    return AppInputSupport(
      label: title,
      hintText: 'Nhập ${title.toLowerCase()}',
      backgroundColor: whiteColor,
      borderColor: borderColor_2,
      onChanged: onChange,
      initialValue: initValue,
      onTap: onTap,
      inputFormatters: isPrice ?? false
          ? [
              CurrencyTextInputFormatter.currency(
                locale: 'vi',
                decimalDigits: 0,
                symbol: '',
              ),
            ]
          : null,
      required: isRequired,
      controller: controller,
      textInputType: textInputType ?? TextInputType.text,
      readOnly: onTap != null || readOnly == true,
      suffixIcon: suffixIcon,
      validate: validate ??
          (value) {
            if ((value?.isEmpty ?? true) && isRequired) {
              return 'Yêu cầu nhập ${title.toLowerCase()}';
            }
            return null;
          },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
