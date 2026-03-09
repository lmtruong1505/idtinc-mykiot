import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../features/customer/data/models/medical_record_customer_model.dart';

class MedicalRecordItemView extends StatefulWidget {
  const MedicalRecordItemView({
    super.key,
    required this.data,
  });

  final MedicalRecordCustomerModel data;

  @override
  State<MedicalRecordItemView> createState() => _MedicalRecordItemViewState();
}

class _MedicalRecordItemViewState extends State<MedicalRecordItemView> {
  MedicalRecordCustomerModel get e => widget.data;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(sp12),
          decoration: BoxDecoration(
            color: _isExpanded ? AppColors.grey10 : whiteColor,
            borderRadius: _isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(sp16))
                : BorderRadius.circular(sp16),
            border: Border.all(color: AppColors.ultility_gray_20),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(sp4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp8),
                              border: Border.all(
                                color: AppColors.blue50,
                              ),
                            ),
                            child: Text(
                              e.code ?? '',
                              style: s12w500.copyWith(
                                color: AppColors.blue70,
                              ),
                            ),
                          ),
                          sp12.width,
                          Container(
                            padding: const EdgeInsets.all(sp4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp8),
                              color: AppColors.grey10,
                            ),
                            child: Text(
                              '${e.appointmentCount} lần khám',
                              style: s12w600.copyWith(
                                color: AppColors.grey90,
                              ),
                            ),
                          ),
                        ],
                      ),
                      sp4.height,
                      Text(
                        e.nameVn ?? '',
                        style: s14w500.copyWith(
                          color: AppColors.grey80,
                        ),
                      ),
                      sp4.height,
                      Text(
                        'Khám gần nhất: ${e.latestAppointmentDate?.fomatCustom()}',
                        style: s14w500.copyWith(
                          color: AppColors.grey60,
                        ),
                      ),
                    ],
                  ),
                ),
                sp4.width,
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isExpanded ? 0.5 : 0,
                  curve: Curves.bounceInOut,
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          height: _isExpanded ? null : 0,
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(sp12),
          margin: const EdgeInsets.only(bottom: sp12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(sp16),
            ),
            border: Border.all(color: AppColors.ultility_gray_20),
          ),
          child: Column(
            children: (e.appointmentData ?? []).map((e) {
              return _appoinmentView(e);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _appoinmentView(AppointmentDatum e) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.yellow60,
              size: sp20,
            ),
            sp4.width,
            Text(
              e.createdAt.fomatCustom(),
              style: s14w500.copyWith(
                color: AppColors.yellow60,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(sp4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp8),
                color: AppColors.green10,
                border: Border.all(
                  color: AppColors.green50,
                ),
              ),
              child: Text(
                e.code ?? '',
                style: s12w500.copyWith(
                  color: AppColors.green80,
                ),
              ),
            ),
          ],
        ),
        sp8.height,
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  FaIcon(
                    iconCode: 'f0f1',
                  ),
                  sp4.width,
                  Text(
                    '${e.serviceCount} dịch vụ',
                    style: s14w500.copyWith(
                      color: AppColors.grey60,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    iconCode: 'f03e',
                  ),
                  sp4.width,
                  Text(
                    '${e.imagesCount} ảnh',
                    style: s14w500.copyWith(
                      color: AppColors.grey60,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FaIcon(
                    iconCode: 'f0c6',
                  ),
                  sp4.width,
                  Text(
                    '${e.filesCount} file',
                    style: s14w500.copyWith(
                      color: AppColors.grey60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        sp8.height,
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp8,
            horizontal: sp12,
          ),
          decoration: BoxDecoration(
            color: ColorApp.greyF5,
            borderRadius: BorderRadius.circular(sp12),
            border: Border.all(color: AppColors.border_disabled),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Kết luận:',
                style: s12w500.copyWith(
                  color: AppColors.grey60,
                ),
              ),
              Text(
                e.conclusion ?? '',
                style: s14w400.copyWith(
                  color: AppColors.grey100,
                ),
              ),
              sp4.height,
              Text(
                'Lời dặn bác sĩ:',
                style: s12w500.copyWith(
                  color: AppColors.grey60,
                ),
              ),
              Text(
                e.conclusion ?? '',
                style: s14w400.copyWith(
                  color: AppColors.grey100,
                ),
              ),
            ],
          ),
        ),
        sp8.height,
        Row(
          children: [
            FaIcon(
              iconCode: 'f46b',
            ),
            sp4.width,
            Text(
              'Thuốc:',
              style: s14w500.copyWith(
                color: AppColors.grey60,
              ),
            ),
          ],
        ),
        ...(e.productData ?? []).map((e) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  e.name ?? '',
                  style: s12w500.copyWith(
                    color: AppColors.grey90,
                  ),
                ),
              ),
              sp16.width,
              Text(
                'x${e.quantity}',
                style: s12w500.copyWith(
                  color: AppColors.grey90,
                ),
              ),
            ],
          );
        }),
        sp12.height,
        ExtraButton(
          backgroundColor: whiteColor,
          title: 'Xem chi tiết phiếu khám',
          titleColor: AppColors.button_reversedBrand_solid_textDefault,
          borderRadius: sp24,
          borderColor: AppColors.border_tertiary,
          event: () {
            context.router.push(MedicalScheduleDetailRoute(id: e.id!));
          },
        ),
        const Divider(height: sp32),
      ],
    );
  }
}
