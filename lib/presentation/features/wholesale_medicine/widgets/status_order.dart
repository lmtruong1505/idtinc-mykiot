import 'package:flutter/material.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/order_wm_create_cubit/order_wm_create_state.dart';

// ignore: must_be_immutable
class StatusOrderCard extends StatelessWidget {
  StatusOrderCard({
    super.key,
    required this.title,
    required this.id,
    required this.typeOrder,
  });

  final String title;
  final int id;
  final TypeOrder? typeOrder;

  late IconData iconData;

  @override
  Widget build(BuildContext context) {
    switch (id) {
      case 1:
        iconData = Icons.access_time_rounded;
        break;
      case 3:
        iconData = Icons.close_rounded;
        break;
      case 5:
        iconData = Icons.close_rounded;
        break;
      default:
        iconData = Icons.check_circle_outline_sharp;
    }
    return Row(
      children: [
        Icon(
          iconData,
          size: 18,
          color: _getColorByStatus(
            id,
          ),
        ),
        const SizedBox(width: sp8),
        Text(
          title == 'Chờ NPT xác nhận' || title == 'NPT từ chối'
              ? 'Chờ xác nhận'
              : title,
          style: p5.copyWith(
            color: _getColorByStatus(
              id,
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorByStatus(int status) {
  switch (status) {
    case 1:
      return yellow_1;
    case 2:
      return blue_1;
    case 3:
      return red_1;
    case 4:
      return green_1;
    case 5:
      return red_1;
    case PrefKeys.idOrderDrafStatus:
      return greyColor;
    default:
      return yellow_1;
  }
}
}
