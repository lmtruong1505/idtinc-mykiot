import 'package:flutter/material.dart';

import '../../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/enum/enum_calendar_time.dart';

class ItemChipEvent extends StatelessWidget {
  final String status;
  const ItemChipEvent({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return statusToChip;
  }

//     (APPOINTMENT_BOOKED, 'Đã đặt'),
//     (APPOINTMENT_CONFIRMED, 'Đã xác nhận'),
//     (APPOINTMENT_ARRIVED, 'Đã đến'),
//     (APPOINTMENT_CONSULTING, 'Đang khám'),
//     (APPOINTMENT_COMPLETED, 'Đã hoàn thành'),
//     (APPOINTMENT_CANCELED, 'Đã hủy'),

  Widget get statusToChip {
    if (status == EnumCalendarTime.comfirmed.code) {
      return _buildChip(
        title: EnumCalendarTime.comfirmed.title,
        icon: 'f274',
        color: AppColors.ultility_positive_60,
      );
    }
    if (status == EnumCalendarTime.arrived.code) {
      return _buildChip(
        title: EnumCalendarTime.arrived.title,
        icon: 'e0d1',
        color: AppColors.ultility_carrot_60,
      );
    }

    if (status == EnumCalendarTime.consulting.code) {
      return ChipBadgeCustom(
        color: AppColors.ultility_brand_60,
        title: EnumCalendarTime.consulting.title,
      );
    }
    if (status == EnumCalendarTime.canceled.code) {
      return _buildChip(
        title: EnumCalendarTime.canceled.title,
        icon: 'f273',
        color: AppColors.ultility_negative_60,
      );
    }
    if (status == EnumCalendarTime.completed.code) {
      return _buildChip(
        title: EnumCalendarTime.completed.title,
        icon: 'f058',
        color: AppColors.ultility_gray_60,
      );
    }

    return _buildChip(
      title: EnumCalendarTime.booked.title,
      icon: 'e470',
      color: AppColors.ultility_blue,
    );
  }

  Widget _buildChip({
    required String title,
    required String icon,
    required Color color,
  }) {
    return ChipCustom(
      color: color,
      title: ' $title',
      titleStyle: AppStyle.bodyXsSemiBold.copyWith(
        color: color,
        height: 1.2,
      ),
      perfixIcon: FaIcon(
        iconCode: icon,
        size: 10,
        type: FaIconType.solid,
        color: color,
      ),
    );
  }
}
