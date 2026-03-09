import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmago/presentation/base/app_text.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/models/variant_kafa/variant_kafa_model.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class DrugProdWidget extends StatelessWidget {
  const DrugProdWidget({
    super.key,
    required this.variant,
    this.onAdd,
    this.onMinus,
    this.onUpdate,
  });
  final VariantKafaPreviewModel variant;
  final void Function(int)? onAdd;
  final void Function(int)? onMinus;
  final void Function(String?)? onUpdate;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      borderRadius: 16,
      borderColor: AppColors.border_tertiary,
      height: 250,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                BaseCacheImage(
                  loadPharmagoLogo: true,
                  url: variant.image ?? '',
                  height: 164,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: 32,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.red60,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        iconCode: 'f145',
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        padding: 8.padingHor,
                        decoration:
                            const BoxDecoration(color: AppColors.green80),
                        child: Row(
                          children: [
                            FaIcon(
                              iconCode: 'f543',
                              color: AppColors.white,
                              type: FaIconType.solid,
                              size: 18,
                            ),
                            8.width,
                            Text(
                              'Hoá đơn',
                              style: s10w400.copyWith(
                                color: AppColors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: (variant.promotion ?? 0) > 0,
                        child: Container(
                          height: 20,
                          padding: 8.padingHor,
                          decoration:
                              const BoxDecoration(color: AppColors.red60),
                          child: Center(
                            child: Text(
                              'Khuyến mãi',
                              style: s10w400.copyWith(
                                color: AppColors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            variant.price.formatPrice(type: ' đ'),
            style: s14w600.copyWith(color: AppColors.brand),
          ).padding(8.pading),
          Text(
            variant.title ?? '',
            style: s12w600,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).padding(8.padingHor),
          AppText(
            variant.title ?? '',
            maxLines: 1,
          ).padding(8.padingHor),
          const Spacer(),
          _changQuantityInput(),
        ],
      ),
    );
  }

  Widget _changQuantityInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(color: AppColors.border_tertiary, width: 0),
      ),
      height: 32,
      width: double.infinity,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              print('======Childtap');

              onMinus?.call(variant.quantity - 1);
            },
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border_tertiary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.remove,
                size: 18,
              ),
            ),
          ),
          Container(
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border_tertiary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.border_tertiary,
                        border: Border.all(color: AppColors.text_disable),
                      ),
                      child: FaIcon(
                        iconCode: 'f217',
                        color: AppColors.white,
                        size: 12,
                      ),
                    ),
                  ],
                ).expanded(),
                8.width,
                QuantityInput(
                  onUpdate: onUpdate,
                  quantity: variant.quantity,
                ).expanded(),
              ],
            ),
          ).expanded(),
          InkWell(
            onTap: () {
              print('======Childtap');
              onAdd?.call(variant.quantity + 1);
            },
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border_tertiary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityInput extends StatefulWidget {
  const QuantityInput({
    super.key,
    required this.onUpdate,
    required this.quantity,
    this.textAlign,
  });

  final void Function(String? p1)? onUpdate;
  final int quantity;
  final TextAlign? textAlign;

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.quantity.formatNumber.trim(),
    );
  }

  @override
  void didUpdateWidget(covariant QuantityInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.formatNumber.trim();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      maxLength: 5,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyTextInputFormatter.currency(
          locale: 'vi',
          symbol: '',
        ),
      ],
      style: s16w400.copyWith(height: 1),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        counterText: '',
        isDense: true,
      ),
      textAlign: widget.textAlign ?? TextAlign.start,
      onChanged: widget.onUpdate,
    );
  }
}
