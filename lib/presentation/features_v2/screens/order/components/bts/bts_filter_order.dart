import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_prod.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../../shared/components/widgets/fa_icon.dart';

// ignore: must_be_immutable
class BtsFilterOrder extends StatefulWidget {
  BtsFilterOrder({
    super.key,
    this.type,
    this.status,
    this.time,
    this.price,
    this.invoice,
    this.synchronizePhama,
    required this.onChange,
  });

  OrderTypeV2? type;
  OrderStatus? status;
  TimeCreated? time;
  RangePrice? price;
  ElectricInvoiceType? invoice;
  SynchronizePharmaceuticalType? synchronizePhama;

  final Function(
    OrderTypeV2? type,
    OrderStatus? status,
    TimeCreated? time,
    RangePrice? price,
    ElectricInvoiceType? invoice,
    SynchronizePharmaceuticalType? synchronizePhama,
  ) onChange;

  @override
  State<BtsFilterOrder> createState() => _BtsFilterOrderState();
}

class _BtsFilterOrderState extends State<BtsFilterOrder> {
  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.onChange(
          null,
          null,
          null,
          null,
          null,
          null,
        );
        context.pop();
      },
      onConfirm: () {
        widget.onChange(
          widget.type,
          widget.status,
          widget.time,
          widget.price,
          widget.invoice,
          widget.synchronizePhama,
        );
        context.pop();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterItem(
              label: 'Loại đơn hàng',
              items: OrderTypeV2.values.map((e) => e.title).toList(),
              select:
                  OrderTypeV2.values.indexOf(widget.type ?? OrderTypeV2.all),
              onTap: (index) => setState(
                () => widget.type = OrderTypeV2.values[index],
              ),
            ),
            16.height,
            FilterItem(
              label: 'Trạng thái HĐĐT',
              items: ElectricInvoiceType.values.map((e) => e.title).toList(),
              select: ElectricInvoiceType.values
                  .indexOf(widget.invoice ?? ElectricInvoiceType.all),
              onTap: (index) => setState(
                () {
                  widget.invoice = ElectricInvoiceType.values[index];
                  widget.synchronizePhama = SynchronizePharmaceuticalType.all;
                },
              ),
            ),
            16.height,
            FilterItem(
              label: 'Trạng thái đồng bộ CSDL Dược',
              items: SynchronizePharmaceuticalType.values
                  .map((e) => e.title)
                  .toList(),
              select: SynchronizePharmaceuticalType.values.indexOf(
                widget.synchronizePhama ?? SynchronizePharmaceuticalType.all,
              ),
              onTap: (index) => setState(
                () {
                  widget.synchronizePhama =
                      SynchronizePharmaceuticalType.values[index];
                  widget.invoice = ElectricInvoiceType.all;
                },
              ),
            ),
            16.height,
            FilterItem(
              label: 'Trạng thái đơn hàng',
              items: OrderStatus.values.map((e) => e.title).toList(),
              select:
                  OrderStatus.values.indexOf(widget.status ?? OrderStatus.all),
              onTap: (index) => setState(
                () => widget.status = OrderStatus.values[index],
              ),
            ),
            16.height,
            FilterItem(
              label: 'Thời gian tạo đơn',
              items: TimeCreated.values.map((e) => e.title).toList(),
              select:
                  TimeCreated.values.indexOf(widget.time ?? TimeCreated.all),
              onTap: (index) => setState(
                () => widget.time = TimeCreated.values[index],
              ),
            ),
            // if (widget.time == TimeCreated.option) ...[
            //   16.height,
            //   Text(
            //     'Chọn khoảng thời gian',
            //     style: AppStyle.bodyBsMedium.copyWith(
            //       color: AppColors.input_label,
            //     ),
            //   ),
            //   8.height,
            //   RangeInput(
            //     onChanged: (start, end) {
            //       print('start: $start, end: $end');
            //     },
            //     inputFormatters: [
            //       HourMinsFormatter(),
            //       LengthLimitingTextInputFormatter(5),
            //     ],
            //     validator: (value1, value2) {
            //       if (value1.isEmptyOrNull && value2.isEmptyOrNull) {
            //         return null;
            //       }
            //       if (!value1.isTimeOfDay) {
            //         return 'Thời gian mở cửa không đúng định đạng';
            //       }
            //       if (!value2.isTimeOfDay) {
            //         return 'Thời gian đóng cửa không đúng định đạng';
            //       }
            //       return null;
            //     },
            //     prefixIcon: const Icon(
            //       Icons.access_time_rounded,
            //       color: AppColors.input_iconDefault,
            //       size: 17,
            //     ),
            //     hintStart: '00:00',
            //     hintEnd: '00:00',
            //   )
            // ],
            16.height,
            FilterItem(
              label: 'Giá trị đơn hàng (VND)',
              items: RangePrice.values.map((e) => e.label).toList(),
              select: RangePrice.values.indexOf(widget.price ?? RangePrice.all),
              onTap: (index) => setState(
                () => widget.price = RangePrice.values[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OrderTypeV2 {
  all('Tất cả'),
  product('Sản phẩm'),
  service('Dịch vụ');

  final String title;

  const OrderTypeV2(this.title);
}

enum ElectricInvoiceType {
  all('Tất cả'),
  product('Đã phát hành'),
  service('Chưa phát hành');

  final String title;

  const ElectricInvoiceType(this.title);
}

enum SynchronizePharmaceuticalType {
  all('Tất cả'),
  product('Chưa đồng bộ'),
  service('Đã đồng bộ');

  final String title;

  const SynchronizePharmaceuticalType(this.title);
}

OrderTypeV2 type(String code) {
  switch (code.toLowerCase()) {
    case 'product':
      return OrderTypeV2.product;
    case 'service':
      return OrderTypeV2.service;
    default:
      return OrderTypeV2.all;
  }
}

enum OrderStatus {
  all('Tất cả', 'all'),
  waitPay('Chờ thanh toán', 'PENDING'),
  unpaid('Chưa thanh toán đủ', 'INCOMPLETE'),
  paid('Đã thanh toán', 'PAID'),
  cancel('Đã hủy', 'CANCELED');

  final String title;
  final String code;

  const OrderStatus(this.title, this.code);
}

enum TimeCreated {
  all('Tất cả'),
  today('Hôm nay'),
  week('Tuần này'),
  month('Tháng này'),
  option('Tùy chỉnh');

  const TimeCreated(this.title);

  final String title;
}

extension TimeCreatedExt on TimeCreated {
  List<DateTime>? get rangeDateTime {
    final now = DateTime.now();
    switch (this) {
      case TimeCreated.today:
        return [
          DateTime(now.year, now.month, now.day, 0, 0),
          DateTime(now.year, now.month, now.day, 23, 59),
        ];
      case TimeCreated.week:
        return [
          DateTime(now.year, now.month, now.day - now.weekday + 1, 0, 0),
          DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59),
        ];
      case TimeCreated.month:
        return [
          DateTime(now.year, now.month, 1, 0, 0),
          DateTime(now.year, now.month + 1, 0, 23, 59),
        ];
      default:
        return null;
    }
  }

  Widget? get icon {
    switch (this) {
      case TimeCreated.today:
        return CalendarFaIcon.day;
      case TimeCreated.week:
        return CalendarFaIcon.week;
      case TimeCreated.month:
        return CalendarFaIcon.month;
      default:
        return null;
    }
  }

  Map<String, String>? get range {
    final now = DateTime.now();
    switch (this) {
      case TimeCreated.today:
        return {
          'time_gte': DateTime(now.year, now.month, now.day, 0, 0)
              .fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss'),
          'time_lte': DateTime(now.year, now.month, now.day, 23, 59)
              .fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss'),
        };
      case TimeCreated.week:
        return {
          'time_gte':
              DateTime(now.year, now.month, now.day - now.weekday + 1, 0, 0)
                  .fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss'),
          'time_lte':
              DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59)
                  .fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss'),
        };
      case TimeCreated.month:
        return {
          'time_gte': DateTime(now.year, now.month, 1, 0, 0)
              .fomatCustom(fomat: 'YYYY-MM-DD HH:MM[:ss[.uuuuu]][TZ]'),
          'time_lte': DateTime(now.year, now.month + 1, 0, 23, 59)
              .fomatCustom(fomat: 'yyyy-MM-dd HH:mm:ss'),
        };
      default:
        return null;
    }
  }
}
