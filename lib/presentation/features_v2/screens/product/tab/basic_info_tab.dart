import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/filter_prod_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/base_price_item.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_chose_extra.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_config_base_price.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_config_unit_sell.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/table_price_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../../shared/components/button/label_button.dart';
import '../../../../../shared/components/input/input_column.dart';
import '../../../../../shared/components/widgets/empty_view.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../blocs/product/config_sell_bloc.dart';
import '../../../blocs/product/params/prod_create_param.dart';
import '../../../models/product/unit_v2_model.dart';
import '../components/item_create_unit.dart';

class BasicInfoTab extends StatefulWidget {
  const BasicInfoTab({
    super.key,
    required this.param,
    required this.unitBloc,
    this.validate,
    required this.categoryBlc,
  });

  final ProdCreateParam param;
  final ConfigSellBloc unitBloc;
  final VoidCallback? validate;
  final FilterProdBloc categoryBlc;

  @override
  State<BasicInfoTab> createState() => _BasicInfoTabState();
}

class _BasicInfoTabState extends State<BasicInfoTab>
    with AutomaticKeepAliveClientMixin {
  final barcode = TextEditingController();
  final category = TextEditingController();

  @override
  void initState() {
    barcode.text = widget.param.product?.barcode ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoryBlc = widget.categoryBlc;
    super.build(context);
    return SingleChildScrollView(
      padding: 24.padingTop + 16.padingHor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin chung',
            style: AppStyle.headingLg,
          ),
          16.height,
          InputColumn(
            label: 'Tên sản phẩm',
            isRequired: true,
            padding: 0.pading,
            maxLength: 30,
            initialValue: widget.param.product?.name,
            onChanged: (val) {
              widget.param.product?.name = val.trim();
            },
          ),
          16.height,
          InputColumn(
            label: 'Danh mục sản phẩm',
            padding: 0.pading,
            suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
            controller: category,
            onTap: () {
              context.bottomSheet(
                BtsChoseExtra(
                  type: ExtraType.categories,
                  onChose: (value) {
                    widget.param.product?.category = value;
                    category.text = value.name ?? '';
                    widget.param.product?.categoryPrd = value.id;
                  },
                  id: widget.param.product?.category?.id ?? -1,
                ),
              );
            },
            readOnly: true,
          ),
          // BlocBuilder<FilterProdBloc, CubitState>(
          //   bloc: categoryBlc,
          //   builder: (context, state) {
          //     return CommonDropdown(
          //       showIconRemove: false,
          //       borderColor: AppColors.input_borderDefault,
          //       items: List.generate(
          //         categoryBlc.categories.length,
          //         (index) => DropdownMenuItem(
          //           value: categoryBlc.categories[index],
          //           child: Text(
          //             categoryBlc.categories[index].name ?? '',
          //           ),
          //         ),
          //       ),
          //       onChanged: (value) {
          //         widget.param.product?.categoryPrd = value?.id;
          //       },
          //       required: true,
          //       label: 'Danh mục sản phẩm',
          //       hintText: 'Chọn danh mục',
          //       color: AppColors.white,
          //     );
          //   },
          // ),
          16.height,
          InputColumn(
            label: 'Mã vạch sản phẩm',
            padding: 0.pading,
            onChanged: (val) {
              widget.param.product?.barcode = val;
            },
            controller: barcode,
            prefixIcon: InkWell(
              onTap: _handleQr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: 1.pading.copyWith(right: 0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.bg_secondary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      height: 48,
                      width: 48,
                      child: FaIcon(
                        iconCode: 'f465',
                        type: FaIconType.solid,
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: AppColors.input_borderDefault,
                    thickness: 1,
                    width: 0,
                  ).size(height: 48),
                  8.width,
                ],
              ),
            ),
          ),
          16.height,
          InputColumn(
            label: 'Mã sản phẩm',
            padding: 0.pading,
            initialValue: widget.param.product?.code,
            onChanged: (val) {
              widget.param.product?.code = val;
            },
          ),
          16.height,
          InputColumn(
            label: 'Mô tả',
            padding: 0.pading,
            minLines: 3,
            initialValue: widget.param.product?.description,
            onChanged: (val) {
              widget.param.product?.description = val;
            },
          ),
          16.height,
          _configSellUnit(),
          16.height,
          _configBaseSellPrice(),
          24.height,
          BlocBuilder<ConfigSellBloc, CubitState>(
            bloc: widget.unitBloc,
            builder: (context, state) {
              final base = widget.unitBloc.findBase;
              if (base == null) {
                return Container();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bảng quy đổi giá bán theo đơn vị',
                    style: AppStyle.headingLg,
                  ),
                  4.height,
                  Text(
                    'Giá thiết lập >= giá quy đổi của sản phẩm',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                  12.height,
                  TablePriceItem(bloc: widget.unitBloc),
                ],
              );
            },
          ),
          12.height,
        ],
      ),
    );
  }

  FormField<Object> _configSellUnit() {
    return FormField(
      validator: (val) {
        if (widget.unitBloc.list.isEmpty) {
          print('widget.unitBloc.list.isEmpty ${widget.unitBloc.list.isEmpty}');
          return 'Chưa cấu hình đơn vị bán';
        }
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Thiết lập đơn vị bán',
                  style: AppStyle.headingLg,
                ),
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.red50,
                  ),
                ),
              ],
            ),
          ),
          12.height,
          if (field.hasError)
            Text(
              field.errorText ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.start,
            ),
          BlocBuilder<ConfigSellBloc, CubitState>(
            bloc: widget.unitBloc,
            builder: (context, state) {
              if (widget.unitBloc.list.isEmpty) {
                return _buildEmpty();
              }
              return Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        color: AppColors.ultility_carrot_60,
                        size: 15,
                      ),
                      8.width,
                      Text(
                        'Giá cơ sở',
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  ItemCreateUnit(
                    units: widget.unitBloc.list,
                    onAdd: configSellUnit,
                    onRemove: (index) {
                      widget.unitBloc.remove(index);
                    },
                    onUpdate: (index) {
                      configSellUnit(index: index);
                    },
                    canEdit: widget.param.product?.canEditStock ?? true,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return EmptyComfirm(
      labelBtn: 'Cấu hình đơn vị bán',
      text: 'Chưa cấu hình đơn vị bán',
      onPressed: configSellUnit,
      btnColor: AppColors.button_neutral_solid_backgroundDefault,
      icon: FaIcon(
        iconCode: 'f02b',
        type: FaIconType.solid,
        size: 32,
        color: AppColors.fg_tertiary,
      ),
      suffixIcon: FaIcon(
        iconCode: 'f013',
        color: AppColors.button_neutral_solid_iconDefault,
      ),
    );
  }

  configSellUnit({int? index}) {
    context
        .bottomSheet(
      BtsConfigUnitSell(
        unit: index != null
            ? widget.unitBloc.list[index]
            : widget.unitBloc.list.lastOrNull,
        isUpdate: index != null,
        prev: index != null
            ? (index == 0 ? '1' : widget.unitBloc.list[index - 1].name ?? '1')
            : widget.unitBloc.list.lastOrNull?.name ?? '',
        name: widget.unitBloc.list.map((e) => e.name.validator).toList(),
      ),
    )
        .then((value) {
      if (value != null && value is UnitV2Model) {
        if (index != null) {
          widget.unitBloc.updateUnit(index, value);
        } else {
          widget.unitBloc.addTypes(value);
        }
        // widget.validate?.call();
      }
    });
  }

  FormField<Object> _configBaseSellPrice() {
    return FormField(
      validator: (val) {
        final base = widget.unitBloc.findBase;
        if (base == null) {
          return 'Chưa cấu hình giá cơ sở';
        }
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Thiết lập giá cơ sở',
                  style: AppStyle.headingLg,
                ),
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.red50,
                  ),
                ),
              ],
            ),
          ),
          12.height,
          if (field.hasError)
            Text(
              field.errorText ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.start,
            ),
          LabelButton(
            onPressed: () {
              context
                  .bottomSheet(BtsConfigBasePrice(bloc: widget.unitBloc))
                  .then((value) {
                widget.validate?.call();
              });
            },
            label: 'Thiết lập',
            suffixIcon: FaIcon(
              iconCode: 'f013',
              color: AppColors.button_neutral_solid_iconDefault,
            ),
            backgroundColor: AppColors.button_neutral_solid_backgroundDefault,
          ),
          12.height,
          BlocBuilder<ConfigSellBloc, CubitState>(
            bloc: widget.unitBloc,
            builder: (context, state) {
              if (widget.unitBloc.list.isEmpty) {
                return Container();
              }
              final base = widget.unitBloc.findBase;
              if (base == null) {
                return Container();
              }
              return BasePriceItem(
                model: base,
                vat: widget.unitBloc.vat,
                importPrice: widget.unitBloc.import_price,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _handleQr() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    ).then((value) {
      if (value != null && value is String) {
        widget.param.product?.barcode = value;
        barcode.text = value;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy mã vạch'),
          ),
        );
      }
    });
  }
}
