import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_state.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../base/button.dart';
import '../../../constants/colors.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/work_space/work_space_cubit.dart';
import '../data/models/point_exchange_package_model.dart';
import '../domain/entities/setting_point_entity.dart';

@RoutePage()
class SettingPointPage extends StatefulWidget {
  const SettingPointPage({super.key});

  @override
  State<SettingPointPage> createState() => _SettingPointPageState();
}

class _SettingPointPageState extends State<SettingPointPage> {
  late SettingPointEntity settingPoint;
  final _wsCubit = getIt.get<WorkSpaceCubit>();
  int _pageIndex = 1;

  @override
  void initState() {
    super.initState();

    settingPoint = _wsCubit.state.company!.settingPoint!;
    _wsCubit.getListPointExchangePackage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const BaseAppBar(title: 'Tích điểm'),
        body: _bodyView,
      ),
    );
  }

  Widget get _bodyView {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(sp16),
          child: CupertinoSlidingSegmentedControl<int>(
            padding: 4.pading,
            thumbColor: borderColor_1,
            backgroundColor: whiteColor.withOpacity(0.2),
            groupValue: _pageIndex,
            children: {
              1: Text(
                'Tích điểm',
                style: p5.copyWith(
                  color: _pageIndex == 1 ? blackColor : greyFF2,
                ),
                textAlign: TextAlign.center,
              ),
              2: Text(
                'Gói đổi điểm',
                style: p5.copyWith(
                  color: _pageIndex == 2 ? blackColor : greyFF2,
                ),
                textAlign: TextAlign.center,
              ),
            },
            onValueChanged: (value) => setState(
              () => _pageIndex = value ?? 1,
            ),
          ),
        ),
        _pageIndex == 1 ? _settingView : _packageView,
        if (_pageIndex == 1)
          TwoButtonBox(
            mainTitle: 'Áp dụng',
            extraTitle: 'Đặt lại',
            mainOnTap: () {
              _wsCubit.updateSettingPoint(settingPoint);
              toastification.show(
                title: const Text('Cập nhật thành công'),
                type: ToastificationType.success,
                autoCloseDuration: const Duration(seconds: 3),
              );
            },
            extraOnTap: () {
              setState(() {
                settingPoint = _wsCubit.state.company!.settingPoint!;
              });
            },
          ),
      ],
    );
  }

  Widget get _settingView {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(sp16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: sp12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tích điểm theo sản phẩm',
                    style: s14w600.copyWith(color: AppColors.text_secondary),
                  ),
                  AppSwitch(
                    value: settingPoint.isApplyProductPoint,
                    onChanged: (value) {
                      setState(() {
                        settingPoint =
                            settingPoint.copyWith(isApplyProductPoint: value);
                      });
                    },
                  ),
                ],
              ),
              Row(
                spacing: sp12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.icon_iconSecondary,
                    size: sp20,
                  ),
                  Expanded(
                    child: Text(
                      'Cho phép tích điểm theo sản phẩm khách hàng mua.',
                      style: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tích điểm theo đơn hàng',
                    style: s14w600.copyWith(color: AppColors.text_secondary),
                  ),
                  AppSwitch(
                    value: settingPoint.isApplyOrderPoint,
                    onChanged: (value) {
                      setState(() {
                        settingPoint =
                            settingPoint.copyWith(isApplyOrderPoint: value);
                      });
                    },
                  ),
                ],
              ),
              if (!settingPoint.isApplyOrderPoint)
                Row(
                  spacing: sp12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.icon_iconSecondary,
                      size: sp20,
                    ),
                    Expanded(
                      child: Text(
                        'Cho phép tích điểm theo giá trị đơn hàng.',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              if (settingPoint.isApplyOrderPoint) ...[
                Text(
                  'Tỉ lệ tích điểm',
                  style: s16w400.copyWith(
                    color: AppColors.text_primary,
                  ),
                ),
                Text(
                  'Cứ mỗi X đồng thì cộng Y điểm',
                  style: s14w400.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                Row(
                  spacing: sp12,
                  children: [
                    Expanded(
                      child: InputCurrency(
                        controller: TextEditingController(
                          text: settingPoint.orderExchangeMoney.formatCurrency,
                        ),
                        hintText: 'hintText',
                        onChanged: (p0) {
                          settingPoint = settingPoint.copyWith(
                            orderExchangeMoney: int.tryParse(p0.removeAllDot()),
                          );
                        },
                      ),
                    ),
                    Text(
                      '=',
                      style: s14w400.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                    Expanded(
                      child: InputCurrency(
                        controller: TextEditingController(
                          text: settingPoint.orderExchangePoint.formatCurrency,
                        ),
                        onChanged: (p0) {
                          settingPoint = settingPoint.copyWith(
                            orderExchangePoint: int.tryParse(p0.removeAllDot()),
                          );
                        },
                        hintText: 'hintText',
                        suffixIcon: const SizedBox(
                          width: sp32,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('điểm'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(sp8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    border: Border.all(color: AppColors.border_secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cho phép thanh toán bằng điểm',
                        style:
                            s14w600.copyWith(color: AppColors.text_secondary),
                      ),
                      AppSwitch(
                        value: settingPoint.isApplyPaymentPoint,
                        onChanged: (value) {
                          setState(() {
                            settingPoint = settingPoint.copyWith(
                              isApplyPaymentPoint: value,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (settingPoint.isApplyPaymentPoint) ...[
                  Text(
                    'Quy đổi số điểm thưởng sang số tiền thanh toán',
                    style: s14w400.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  Row(
                    spacing: sp12,
                    children: [
                      Expanded(
                        child: InputCurrency(
                          controller: TextEditingController(
                            text: settingPoint
                                .paymentExchangePoint.formatCurrency,
                          ),
                          onChanged: (p0) {
                            settingPoint = settingPoint.copyWith(
                              paymentExchangePoint:
                                  int.tryParse(p0.removeAllDot()),
                            );
                          },
                          hintText: '0',
                          suffixIcon: const SizedBox(
                            width: sp32,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('điểm'),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '=',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                      Expanded(
                        child: InputCurrency(
                          controller: TextEditingController(
                            text: settingPoint
                                .paymentExchangeMoney.formatCurrency,
                          ),
                          hintText: '0',
                          onChanged: (p0) {
                            settingPoint = settingPoint.copyWith(
                              paymentExchangeMoney:
                                  int.tryParse(p0.removeAllDot()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget get _packageView {
    return BlocSelector<WorkSpaceCubit, WorkSpaceState,
        List<PointExchangePackageModel>>(
      bloc: _wsCubit,
      selector: (state) {
        return state.listPointExchangePackage;
      },
      builder: (context, listPointExchangePackage) {
        return Expanded(
          child: listPointExchangePackage.isEmpty
              ? Column(
                  children: [
                    MainButtonV2(
                      title: 'Thêm gói',
                      radius: sp16,
                      onTap: () {
                        context.router.push(
                          const PointExchangePackageCreateRoute(),
                        );
                      },
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(sp16).copyWith(
                    top: sp0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tất cả',
                            style: s14w500.copyWith(
                              color: AppColors.text_tertiary,
                            ),
                          ),
                          MainButton(
                            title: 'Thêm gói',
                            radius: sp16,
                            icon: const Icon(Icons.add_rounded),
                            largeButton: false,
                            event: () {
                              context.router.push(
                                const PointExchangePackageCreateRoute(),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return _itemView(listPointExchangePackage[index]);
                          },
                          separatorBuilder: (_, __) => sp12.height,
                          itemCount: listPointExchangePackage.length,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _itemView(PointExchangePackageModel item) {
    return Container(
      padding: const EdgeInsets.all(sp12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        border: Border.all(color: AppColors.border_tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: sp4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name ?? '',
                style: s14w600.copyWith(color: AppColors.text_secondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: sp8,
                  vertical: sp4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp16),
                  border: Border.all(color: AppColors.border_tertiary),
                ),
                child: Row(
                  spacing: sp8,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: blue_1,
                      size: sp8,
                    ),
                    Text(
                      'Đang sử dụng',
                      style: s10w500.copyWith(color: blue_1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            '${item.items?.length ?? 0} sản phẩm',
            style: s12w400.copyWith(color: AppColors.text_secondary),
          ),
          Row(
            spacing: sp8,
            children: [
              Image.asset(
                '${AssetsPath.image}/img_star.png',
                width: sp24,
              ),
              Text(
                '${item.point ?? 0} điểm',
                style: s14w600.copyWith(color: AppColors.text_secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
