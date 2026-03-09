import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/customer_bottom_sheet.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/color_app.dart';
import '../../../../../shared/style_app/style_text.dart';

// ignore: must_be_immutable
class CustomerView extends StatefulWidget {
  CustomerView({
    super.key,
    required this.item,
    required this.isSelected,
    this.onUpdated,
    this.onHide,
  });

  final CustomerEntity item;
  final bool isSelected;
  Function(CustomerEntity value)? onUpdated;
  Function()? onHide;

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: widget.isSelected ? ColorApp.main : ColorApp.greyE2,
            width: 1),
      ),
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.item.name ?? '',
                style: StyleApp.bold(fontSize: 16),
              ).expanded(),
              InkWell(
                onTap: () {
                  widget.onHide?.call();
                  context.bottomSheet(
                    CustomerBottomSheet(customerId: widget.item.id ?? -1),
                  );
                },
                child: IcSvg.asset('/ic_info.svg'),
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              const Icon(
                Icons.phone,
                color: ColorApp.blue99,
                size: 18,
              ),
              4.width,
              Text(widget.item.phone ?? '').expanded(),
              Text(
                '${widget.item.orders ?? 0} đơn - ${FormatCurrency(widget.item.revenue ?? 0)}đ',
                style: StyleApp.bold(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
