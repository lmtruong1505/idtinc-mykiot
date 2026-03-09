import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../base/cache_image.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../domain/entities/shipment_data_entity.dart';
import 'create_warehouse_receipt_page.dart';

@RoutePage()
class ShipmentDetailPage extends StatelessWidget {
  const ShipmentDetailPage({
    super.key,
    required this.shipment,
  });

  final ShipmentItemEntity shipment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        onBack: () => context.pop(),
        height: 90,
        title: 'Quản lý kho hàng',
        subTitle: 'Chi tiết lô hàng',
      ),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(
          vertical: sp32,
          horizontal: sp16,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp2,
                  horizontal: sp12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brand5,
                  borderRadius: BorderRadius.circular(sp8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.bg_black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: sp2,
                      spreadRadius: sp2,
                    ),
                  ],
                ),
                child: Text(
                  'Lô ${shipment.code}',
                  style: s18w500.copyWith(
                    color: AppColors.green80,
                  ),
                ),
              ),
              12.height,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border_primary_hover),
                  borderRadius: 56.radius,
                ),
                child: ClipRRect(
                  borderRadius: 56.radius,
                  child: BaseCacheImage(
                    loadPharmagoLogo: true,
                    url: (shipment.productData?.images?.isNotEmpty ?? false)
                        ? (shipment.productData?.images?.first.url ?? '')
                        : '',
                    width: sp80,
                    height: sp80,
                    borderRadius: 56.radius,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.height,
              Text(
                shipment.product?.productName ?? '',
                style: s14w500.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ngày sản xuất',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    'Hạn sử dụng',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    shipment.startDate.fomatCustom(),
                    style: s14w500.copyWith(color: AppColors.text_secondary),
                  ),
                  Text(
                    shipment.endDate.fomatCustom(),
                    style: s14w500.copyWith(color: AppColors.text_secondary),
                  ),
                ],
              ),
              const Divider(height: sp32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã phiếu nhập kho đi kèm',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  InkWell(
                    onTap: () => context.router.push(
                      ReceiptImportDetailRoute(
                        id: shipment.importReceiptData!.id!,
                        warehouseId: shipment.warehouseImportId!,
                      ),
                    ),
                    child: Text(
                      shipment.importReceiptData?.code ?? '',
                      style: s14w500.copyWith(
                        color: AppColors.green60,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nhà cung cấp',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    'Chưa có thông tin',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Người kiểm tra',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    'Chưa có thông tin',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Lý do nhập',
                      style: s14w400.copyWith(color: AppColors.text_tertiary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Chưa có thông tin',
                      style: s14w400.copyWith(color: AppColors.text_tertiary),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const Divider(height: sp32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trạng thái',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: sp2,
                      horizontal: sp8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: shipment.borderChip),
                      borderRadius: BorderRadius.circular(sp12),
                      color: shipment.bgChip,
                    ),
                    child: Text(
                      shipment.titleChip,
                      style: s12w500.copyWith(
                        color: shipment.colorTitleChip,
                      ),
                    ),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số lượng nhập',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    shipment.inputQuantity.formatCurrency,
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đơn giá nhập',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    '${shipment.importPrice.formatCurrency}đ/${shipment.inputUnitData}',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VAT(%)',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    '${shipment.vat.formatCurrency}%',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chiết khấu',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    'Chưa có thông tin',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thành tiền',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    '${shipment.totalMoney.formatCurrency}đ',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Giá trị nhập',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    '${shipment.totalImportPrice.formatCurrency}đ',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tồn kho',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: sp4,
                      horizontal: sp12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brand5,
                      borderRadius: BorderRadius.circular(sp8),
                      border: Border.all(
                        color: AppColors.border_brandSolid.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      '${shipment.currentQuantity.formatCurrency} ${shipment.storageUnitData}',
                      style: s16w400.copyWith(
                        color: AppColors.green60,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: sp32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Người tạo',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    shipment.userCreated.formatCurrency,
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thời gian tạo',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    '${shipment.createdAt.fomatCustom()}đ',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Người cập nhật',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    shipment.userUpdated.formatCurrency,
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thời gian cập nhật',
                    style: s14w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  Text(
                    '${shipment.updatedAt.fomatCustom()}đ',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TwoButtonBox(
        mainTitle: 'Xuất kho',
        extraTitle: 'Chuyển kho',
        mainOnTap: () {
          context.router.push(ReceiptExportCreateRoute(shipments: [shipment]));
        },
      ),
    );
  }
}
