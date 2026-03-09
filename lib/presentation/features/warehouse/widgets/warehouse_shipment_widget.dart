import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/row_custom.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/receipt_import_detail_cubit.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class WarehouseShipmentWidget extends StatelessWidget {
  const WarehouseShipmentWidget({
    super.key,
    required this.cubit,
  });

  final ReceiptImportDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptImportDetailCubit, CubitState>(
      bloc: cubit,
      builder: (context, state) {
        return Column(
          children: [
            SearchFilterCustom(
              suffixIcon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: 1.pading.copyWith(left: 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.bg_secondary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(999),
                        bottomRight: Radius.circular(999),
                      ),
                    ),
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    child: FaIcon(iconCode: 'f465', type: FaIconType.solid),
                  ),
                ),
              ),
              hintText: 'Tìm kiếm sản phẩm',
              onChange: (p0) {},
              isActive: true,
              onTap: () {},
            ),
            24.height,
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = cubit.list[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        BaseContainer(
                          borderRadius: 999,
                          padding: 4.pading,
                          color: getBgColorByDate(data.endDate),
                          borderColor: getTextColorByDate(data.endDate),
                          child: Text(
                            getTextByDate(data.endDate),
                            style: s12w500.copyWith(
                              color: getTextColorByDate(data.endDate),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          data.currentQuantity.formatCurrency,
                          style: s18w700.copyWith(
                            color: getTextColorByDate(data.endDate),
                          ),
                        ),
                      ],
                    ),
                    RowCustom(
                      titleStyle: s18w700,
                      dataStyle: s14w400.copyWith(
                        color: AppColors.text_quaternary,
                      ),
                      title: data.code,
                      data: '/${data.inputQuantity.formatCurrency} ${data.inputUnitData}',
                    ),
                    Text(
                      data.importPrice.formatPrice(type: ' đ'),
                      style: s12w400.copyWith(color: AppColors.text_primary),
                    ),
                    12.height,
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
                            4.width,
                            Text(
                              data.productData?.productName ?? '',
                              maxLines: 2,
                              style: s12w400,
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
                              style: s14w500.copyWith(
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
                              style: s14w500.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                          ],
                        ).expanded(),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) =>
                  const Divider().padding(16.padingVer),
              itemCount: cubit.list.length,
            ),
          ],
        );
      },
    ).padding(16.pading);
  }
}

Color getTextColorByDate(DateTime? expiresDate) {
  if (expiresDate == null) {
    return AppColors.ultility_brand_60;
  }
  final now = DateTime.now();
  final difference = expiresDate.difference(now).inDays;

  if (expiresDate.isBefore(now)) {
    return AppColors.text_negative;
  } else if (difference <= 7) {
    return AppColors.ultility_carrot_60;
  } else {
    return AppColors.ultility_brand_60;
  }
}

Color getBgColorByDate(DateTime? expiresDate) {
  if (expiresDate == null) {
    return AppColors.ultility_brand_60;
  }
  final now = DateTime.now();
  final difference = expiresDate.difference(now).inDays;

  if (expiresDate.isBefore(now)) {
    return AppColors.ultility_negative_20;
  } else if (difference <= 7) {
    return AppColors.ultility_carrot_20;
  } else {
    return AppColors.ultility_brand_20;
  }
}

String getTextByDate(DateTime? expiresDate) {
  if (expiresDate == null) {
    return 'Còn hạn';
  }
  final now = DateTime.now();
  final difference = expiresDate.difference(now).inDays;

  if (expiresDate.isBefore(now)) {
    return 'Hết hạn';
  } else if (difference <= 7) {
    return 'Cận date';
  } else {
    return 'Còn hạn';
  }
}
