import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_shipments_bloc.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../constants/spacing.dart';
import '../../../models/product/product_detail_v2_model.dart';

class PrdShipmentWidget extends StatefulWidget {
  const PrdShipmentWidget({
    super.key,
    required this.bloc,
    required this.prod,
  });
  final ProductShipmentsBloc bloc;
  final ProductDetailV2Model prod;
  @override
  State<PrdShipmentWidget> createState() => _PrdShipmentWidgetState();
}

class _PrdShipmentWidgetState extends State<PrdShipmentWidget> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final shipments = bloc.shipmentsInfor;
    return SingleChildScrollView(
      child: Padding(
        padding: 16.padingTop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text.rich(
              TextSpan(
                text: 'Tổng tồn kho: ',
                style: s16w400,
                children: [
                  TextSpan(
                    text: shipments?.quantityInventory.formatCurrency ?? '0',
                    style: s18w700,
                  ),
                  TextSpan(
                    text: ' ${widget.prod.product!.unit.last.name}',
                    style: s18w700,
                  ),
                ],
              ),
            ).padding(16.pading),
            Padding(
              padding: 16.padingHor,
              child: Container(
                padding: 12.pading,
                decoration: BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Cận date',
                          style: s12w500.copyWith(
                            color: AppColors.text_primary,
                          ),
                        ),
                        8.height,
                        RichText(
                          text: TextSpan(
                            text: shipments?.quantityNearDate.formatCurrency,
                            style: s16w500.copyWith(
                              color: AppColors.text_warning,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    ' (trong ${shipments?.totalShipmentNearDate.formatCurrency} lô)',
                                style: s12w500.copyWith(
                                  color: AppColors.text_primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).expanded(),
                    Container(
                      color: AppColors.border_tertiary,
                      width: 1,
                      height: 44,
                    ),
                    Column(
                      children: [
                        Text(
                          'Hết hạn',
                          style: s12w500.copyWith(
                            color: AppColors.text_primary,
                          ),
                        ),
                        8.height,
                        Text(
                          shipments?.quantityExpDate.formatCurrency ?? '',
                          style: s16w500.copyWith(
                            color: AppColors.red60,
                          ),
                        ),
                      ],
                    ).expanded(),
                  ],
                ),
              ),
            ),
            16.height,
            Scrollbar(
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: BaseContainer(
                    child: DataTable(
                        headingRowHeight: 32,
                        dataRowHeight: sp64,
                        border: TableBorder(borderRadius: 32.radius),
                        headingRowColor: WidgetStateProperty.all(
                          AppColors.bg_secondary_subtle,
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Lô',
                              style: s14w500.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ngày nhập kho',
                              style: s14w500.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Hạn sử dụng',
                              style: s14w500.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tồn kho',
                              style: s14w500.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Đơn giá nhập',
                              style: s14w500.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                        ],
                        rows: bloc.list.map((item) {
                          // final status = row.statusLabel as String;
                          // final color = status == 'Hết hạn'
                          //     ? Colors.redAccent
                          //     : Colors.orangeAccent;
                          return DataRow(
                            cells: [
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sp8.height,
                                    BaseContainer(
                                      borderRadius: 999,
                                      borderColor: getTextColor(item.status),
                                      color: getTextColor(item.status)!
                                          .withOpacity(0.2),
                                      padding: 8.padingHor + 4.padingVer,
                                      child: Text(
                                        item.statusLabel ?? '',
                                        style: s14w500.copyWith(
                                          color: getTextColor(item.status),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    sp4.height,
                                    Text(item.id.toString()),
                                    sp4.height,
                                  ],
                                ),
                              ),
                              DataCell(Text(item.createdAt.fomatCustom())),
                              DataCell(Text(item.endDate.fomatCustom())),
                              DataCell(Text(
                                  '${item.quantity.formatCurrency} ${item.storageUnitData}')),
                              DataCell(
                                Text(
                                  '${item.importPrice.formatCurrency}đ/${item.inputUnitData}',
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                ),
              ),
            ).padding(16.padingLeft),
          ],
        ),
      ),
    );
  }
}

Color? getTextColor(num? code) {
  if (code == 1) {
    return AppColors.ultility_brand_60;
  } else {
    return AppColors.ultility_negative_60;
  }
  if (code == 1) {
    return AppColors.ultility_carrot_60;
  }
  if (code == 2) {
    return AppColors.ultility_negative_60;
  }

  return AppColors.ultility_brand_60;
}
