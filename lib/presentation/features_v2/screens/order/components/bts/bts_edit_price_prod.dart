import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../base/cache_image.dart';
import '../../../../../config/app_style/init_app_style.dart';

class BtsEditPriceProd extends StatefulWidget {
  const BtsEditPriceProd({super.key, required this.model});

  final ProductV2Model model;

  @override
  State<BtsEditPriceProd> createState() => _BtsEditPriceProdState();
}

class _BtsEditPriceProdState extends State<BtsEditPriceProd> {
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: BgBts(
        label: 'Chỉnh sửa giá sản phẩm',
        cancelText: 'Hủy bỏ',
        confirmText: 'Xác nhận',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () {
          if(!key.currentState!.validate()) return;
          context.pop(result: widget.model);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInfo(),
              const Divider(
                thickness: 1,
                color: AppColors.bg_secondary,
              ),
              6.height,
              _buildBasePrice(),
              16.height,
              _buildInput(),
            ],
          ),
        ),
      ),
    );
  }

  _buildInfo() {
    return Row(
      children: [
        BaseCacheImage(
          url: widget.model.images?.firstOrNull?.url ?? '',
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
              widget.model.name ?? '',
              style: AppStyle.bodySmMedium,
            ).size(height: 36),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${(widget.model.unitSell?.realPrice ?? 0).formatCurrency} đ',
                    style: AppStyle.bodyBsSemiBold.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  TextSpan(
                    text: '/${widget.model.unitSell?.name ?? ''}',
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

  _buildBasePrice() {
    return Row(
      children: [
        Text(
          'Giá gốc',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ).expanded(),
        Text(
          '${(widget.model.unitSell?.sellPrice ?? 0).formatCurrency} đ',
          style: AppStyle.headingMd.copyWith(
            color: AppColors.text_brand_primary_variant1,
          ),
        ),
      ],
    ).container(bgColor: AppColors.bg_secondary);
  }

  _buildInput() {
    return Column(
      children: [
        InputColumn(
          label: 'Đơn giá mới',
          isRequired: true,
          padding: 0.pading,
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
          initialValue: (widget.model.unitSell?.realPrice ?? 0).formatCurrency,
          textInputType: TextInputType.number,
          onChanged: (p0) {
            widget.model.unitSell?.realPrice = p0.removeAllDot().toDouble;
          },
          validate: (p0) {
            if(p0?.isEmpty ?? true) return 'Vui lòng nhập giá sản phẩm';
            if((p0.removeAllDot().toDouble ?? 0) <= 0) return 'Giá sản phẩm phải lớn hơn 0';
            return null;
          },
        ),
        16.height,
        InputColumn(
          label: 'Chiết khấu',
          hintText: 'Thêm chiết khấu',
          padding: 0.pading,
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
          initialValue: (widget.model.chietKhau ?? 0).formatCurrency,
          textInputType: TextInputType.number,
          onChanged: (p0) {
            if((p0.removeAllDot().toDouble ?? 0) > (widget.model.unitSell?.realPrice ?? 0)) {
              widget.model.chietKhau = widget.model.unitSell?.realPrice ?? 0;
              return;
            }
            widget.model.chietKhau = p0.removeAllDot().toDouble;
          },
        )
      ],
    );
  }
}
