import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../base/cache_image.dart';
import '../../../../../config/app_style/init_app_style.dart';

class BtsEditPriceService extends StatefulWidget {
  const BtsEditPriceService({super.key, required this.model});

  final ServiceV2Model model;

  @override
  State<BtsEditPriceService> createState() => _BtsEditPriceServiceState();
}

class _BtsEditPriceServiceState extends State<BtsEditPriceService> {
  final key = GlobalKey<FormState>();
  late ServiceV2Model service;

  @override
  void initState() {
    super.initState();

    service = widget.model.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: BgBts(
        label: 'Chỉnh sửa giá dịch vụ',
        cancelText: 'Hủy bỏ',
        confirmText: 'Xác nhận',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () {
          if (service.discount >
              (service.priceCustom?.price ?? service.price?.price ?? 0)) {
            setState(() {});
            return;
          }
          if (!key.currentState!.validate()) return;
          context.pop(result: service);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInfo,
              const Divider(
                thickness: 1,
                color: AppColors.bg_secondary,
              ),
              6.height,
              _buildBasePrice,
              16.height,
              _buildInput,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildInfo {
    return Row(
      children: [
        BaseCacheImage(
          url: service.images?.firstOrNull ?? '',
          width: 56,
          height: 56,
          borderRadius: 4.radius,
          fit: BoxFit.cover,
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.title ?? '',
              style: AppStyle.bodySmMedium,
            ).size(height: 36),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${(service.priceCustom?.price ?? service.price?.price ?? 0).formatCurrency} đ',
                    style: AppStyle.bodyBsSemiBold.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  TextSpan(
                    text: '/${service.price?.priceNameSub ?? ''}',
                    style: AppStyle.bodySmRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Widget get _buildBasePrice {
    return Row(
      children: [
        Text(
          'Giá gốc',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(),
        Text(
          '${(service.price?.price ?? 0).formatCurrency} đ',
          style: AppStyle.headingMd.copyWith(
            color: AppColors.text_brand_primary_variant1,
          ),
        ),
      ],
    ).container(bgColor: AppColors.bg_secondary);
  }

  Widget get _buildInput {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputColumn(
          label: 'Đơn giá mới',
          isRequired: true,
          padding: 0.pading,
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
          initialValue: service.priceCustom != null
              ? FormatCurrency(service.priceCustom?.price)
              : FormatCurrency(service.price?.price),
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
          textInputType: TextInputType.number,
          onChanged: (value) {
            final newPrice =
                service.price?.copyWith(price: value.removeAllDot().toDouble);
            service.priceCustom = newPrice;
          },
        ),
        16.height,
        InputColumn(
          label: 'Chiết khấu',
          hintText: 'Thêm chiết khấu',
          padding: 0.pading,
          initialValue:
              service.discount != 0 ? FormatCurrency(service.discount) : null,
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
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
          textInputType: TextInputType.number,
          onChanged: (value) {
            service.discount = value.removeAllDot().toDouble ?? 0;
          },
        ),
        if (service.discount >
            (service.priceCustom?.price ?? service.price?.price ?? 0))
          Text(
            'Giá chiết khẩu phải nhỏ hơn giá bán',
            style: p5.copyWith(color: red_3),
          ),
      ],
    );
  }
}
