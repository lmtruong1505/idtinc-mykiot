import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../base/customer_search.view.dart';
import '../../../models/customer/v2/customer_model.dart';

class EventSelectCustomer extends StatefulWidget {
  const EventSelectCustomer({
    super.key,
    this.model,
    this.type,
    this.onEdit,
    this.onChanged,
  });
  final CustomerV2Model? model;
  final String? type;
  final Function()? onEdit;
  final Function(CustomerV2Model?)? onChanged;
  @override
  State<EventSelectCustomer> createState() => _EventSelectCustomerState();
}

class _EventSelectCustomerState extends State<EventSelectCustomer> {
  final textCtrl = TextEditingController();
  bool autoFocus = false;
  // final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: sp4, horizontal: sp12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: widget.model == null
                    ? AppColors.border_primary
                    : AppColors.green50,
                width: sp2,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Khách hàng',
                style: s18w700.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              Text(
                ' *',
                style: s18w700.copyWith(
                  color: AppColors.red50,
                ),
              ),
            ],
          ),
        ),
        if (widget.model == null) ...[
          sp16.height,
          _buildSearch,
        ],
        sp16.height,
        _buildInfo,
      ],
    );
  }

  Widget get _buildSearch {
    return CustomerSearchView(
      model: widget.model,
      onChanged: widget.onChanged,
      type: widget.type,
    );
  }

  Widget get _buildInfo {
    if (widget.model == null) {
      return Center(
        child: Text(
          'Chưa có khách hàng\nVui lòng tìm hoặc thêm khách hàng',
          style: AppStyle.bodyMdRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ).padding(40.pading);
    }
    return _infoView;
  }

  Widget get _infoView {
    final customer = widget.model;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg_white,
        borderRadius: BorderRadius.circular(sp16),
        border: Border.all(color: AppColors.border_primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.07),
            offset: const Offset(1, 2),
            spreadRadius: sp2,
            blurRadius: sp2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(sp12),
        minTileHeight: sp0,
        minVerticalPadding: sp0,
        title: Text(
          customer?.fullName ?? 'Không có thông tin',
          style: s14w600.copyWith(
            color: AppColors.text_primary,
          ),
        ),
        subtitle: Text(
          customer?.phone ?? 'Không có thông tin',
          style: s12w500.copyWith(
            color: AppColors.blue60,
            decoration: TextDecoration.underline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: sp12,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp4,
                horizontal: sp8,
              ),
              decoration: BoxDecoration(
                color: AppColors.bg_white,
                borderRadius: BorderRadius.circular(sp16),
                border: Border.all(color: AppColors.border_primary),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.07),
                    offset: const Offset(1, 2),
                    spreadRadius: sp2,
                    blurRadius: sp2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    iconCode: 'f890',
                    color: AppColors.carrot60,
                    size: sp12,
                  ),
                  sp4.width,
                  Text(
                    'Mới',
                    style: s10w500.copyWith(color: AppColors.carrot60),
                  ),
                ],
              ),
            ),
            if (widget.onEdit != null) InkWell(
              onTap: () {
                widget.onEdit?.call();
              },
              child: const CircleAvatar(
                radius: sp16,
                backgroundColor: AppColors.bg_disable,
                child: Icon(
                  Icons.edit_rounded,
                  color: AppColors.icon_iconSecondary,
                  size: sp20,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.onChanged?.call(null);
              },
              child: const CircleAvatar(
                radius: sp16,
                backgroundColor: AppColors.bg_disable,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.icon_iconSecondary,
                  size: sp20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
