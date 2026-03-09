import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/service/bloc_index.dart';
import '../../../../models/service/service.dart';

class BtsConfigService extends StatefulWidget {
  final List<ServiceTypeV2Model>? types;
  const BtsConfigService({
    super.key,
    this.types,
  });

  @override
  State<BtsConfigService> createState() => _BtsConfigServiceState();
}

class _BtsConfigServiceState extends State<BtsConfigService> {
  List<ServiceTypeV2Model> types = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.types != null) {
      types = widget.types ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Cấu hình giá dịch vụ',
      cancelText: 'Huỷ bỏ',
      confirmText: 'Xác nhận',
      onCancel: () => context.pop(),
      onConfirm: () {
        context.pop(result: types);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Danh sách',
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              8.width,
              const Divider().expanded(),
            ],
          ),
          12.height,
          ...List.generate(
            context.read<ServiceTypeBloc>().list.length,
            (index) => _buildItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final list = context.read<ServiceTypeBloc>().list;
    return InkWell(
      onTap: () {
        if (types.contains(list[index])) {
          types.remove(list[index]);
        } else {
          types.add(list[index].copyWith(prices: []));
        }
        setState(() {});
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            types.contains(list[index])
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank,
            size: 20,
            color: types.contains(list[index])
                ? AppColors.ultility_positive_60
                : AppColors.border_tertiary,
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                list[index].title ?? '',
                style: AppStyle.bodyBsMedium.copyWith(
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                list[index].description ?? '',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                  height: 1.5,
                ),
              ),
            ],
          ).expanded(),
        ],
      ).padding(16.padingBottom),
    );
  }
}
