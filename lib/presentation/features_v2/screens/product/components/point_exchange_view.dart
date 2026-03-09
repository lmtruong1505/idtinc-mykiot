import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../base/button.dart';
import '../../../../constants/asset_path.dart';
import '../../../../constants/spacing.dart';

class PointExchangeProductView extends StatefulWidget {
  const PointExchangeProductView({
    super.key,
    this.point,
    this.exchangePoint,
    this.callBack,
  });

  final num? point;
  final num? exchangePoint;
  final Function(num? point, num? exchangePoint)? callBack;

  @override
  State<PointExchangeProductView> createState() =>
      _PointExchangeProductViewState();
}

class _PointExchangeProductViewState extends State<PointExchangeProductView>
    with TickerProviderStateMixin {
  bool isPointExchange = false;

  late num point;
  late num exchangePoint;

  @override
  void initState() {
    super.initState();

    point = widget.point ?? 0;
    exchangePoint = widget.exchangePoint ?? 0;
    isPointExchange = point != 0 || exchangePoint != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset('${AssetsPath.image}/bg_v4.png'),
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(sp8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp12),
                color: AppColors.bg_white,
                border: Border.all(color: AppColors.border_tertiary),
              ),
              child: Row(
                children: [
                  Text(
                    'Tích điểm',
                    style: s14w500.copyWith(color: AppColors.text_primary),
                  ),
                  const Spacer(),
                  AppSwitch(
                    value: isPointExchange,
                    onChanged: (value) {
                      setState(() {
                        isPointExchange = !isPointExchange;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: _exchangePointView),
          ],
        ).padding(const EdgeInsets.all(sp16)),
      ],
    );
  }

  Widget get _exchangePointView {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: isPointExchange ? null : 0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.height,
            Row(
              children: [
                FaIcon(iconCode: 'f05a', color: AppColors.fg_quaternary),
                sp16.width,
                Expanded(
                  child: Text(
                    'Số điểm tích lũy khi mua 1 sản phẩm',
                    style: s14w400.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ),
              ],
            ),
            12.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Quy tắc tích điểm = ',
                    style: s14w500.copyWith(
                      color: AppColors.text_primary,
                    ),
                  ),
                ),
                sp16.width,
                Expanded(
                  flex: 5,
                  child: AppInputV2(
                    initialValue: point == 0 ? null : point.formatCurrency,
                    hintText: 'Nhập số điểm tích lũy',
                    backgroundColor: AppColors.bg_white,
                    onChanged: (val) {
                      point = num.tryParse(val) ?? 0;
                    },
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ),
            4.height,
            Text(
              'Tích điểm theo đơn vị nhỏ nhất',
              style: s14w400.copyWith(
                color: AppColors.brand,
              ),
            ),
            16.height,
            Row(
              children: [
                FaIcon(iconCode: 'f05a'),
                sp16.width,
                Expanded(
                  child: Text(
                    'Số điểm để quy đổi 1 sản phẩm',
                    style: s14w400.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ),
              ],
            ),
            12.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Quy tắc đổi điểm = ',
                    style: s14w500.copyWith(
                      color: AppColors.text_primary,
                    ),
                  ),
                ),
                sp16.width,
                Expanded(
                  flex: 5,
                  child: AppInputV2(
                    initialValue: exchangePoint == 0
                        ? null
                        : exchangePoint.formatCurrency,
                    hintText: 'Nhập số điểm quy đổi',
                    backgroundColor: AppColors.bg_white,
                    onChanged: (val) {
                      exchangePoint = num.tryParse(val) ?? 0;
                    },
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ),
            4.height,
            Text(
              'Quy đổi theo đơn vị nhỏ nhất',
              style: s14w400.copyWith(
                color: AppColors.brand,
              ),
            ),
            16.height,
            Row(
              children: [
                MainButton(
                  title: widget.exchangePoint != 0 || widget.point != 0
                      ? 'Cập nhật điểm'
                      : 'Lưu & Áp dụng',
                  event: () {
                    if (point == 0 && exchangePoint == 0) return;
                    widget.callBack?.call(point, exchangePoint);
                  },
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
