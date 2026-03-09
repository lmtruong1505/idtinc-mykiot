import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../blocs/enum/enum_bloc.dart';
import '../../../../blocs/service/bloc_index.dart';
import '../../../../models/service/service.dart';

class BtsFilterService extends StatefulWidget {
  final StatusServiceV2Enum? status;
  final RangePriceV2Enum? rangePrice;

  final ServiceTypeV2Model? type;
  final Function(
    StatusServiceV2Enum? status,
    RangePriceV2Enum? rangePrice,
    ServiceTypeV2Model? type,
  ) onChanged;
  const BtsFilterService({
    super.key,
    this.status,
    this.rangePrice,
    this.type,
    required this.onChanged,
  });

  @override
  State<BtsFilterService> createState() => _BtsFilterServiceState();
}

class _BtsFilterServiceState extends State<BtsFilterService> {
  int status = 0;
  int rangePrice = 0;
  int type = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status = widget.status?.index ?? 0;
    rangePrice = widget.rangePrice?.index ?? 0;
    if (widget.type?.type != null) {
      type = context.read<ServiceTypeBloc>().list.indexWhere(
                (element) => element.type == widget.type?.type,
              ) +
          1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceTypeBloc, CubitState>(
      builder: (context, state) {
        final typesData = [
          ServiceTypeV2Model(title: 'Tất cả'),
          ...context.read<ServiceTypeBloc>().list,
        ];
        return BgBts(
          onCancel: () {
            widget.onChanged(
              null,
              null,
              null,
            );
            context.pop();
          },
          onConfirm: () {
            widget.onChanged(
              StatusServiceV2Enum.values[status],
              RangePriceV2Enum.values[rangePrice],
              type >= 0 ? typesData[type] : null,
            );
            context.pop();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilterItem(
                select: status,
                label: 'Trạng thái',
                onTap: (p0) {
                  status = p0;
                  setState(() {});
                },
                items: StatusServiceV2Enum.values
                    .map(
                      (e) => e.title,
                    )
                    .toList(),
              ),
              // 16.height,
              // FilterItem(
              //   select: 1,
              //   label: 'Danh mục dịch vụ',
              //   items: [
              //     'Tất cả',
              //     'Lâm sàng',
              //     'Tim mạch',
              //   ],
              // ),
              16.height,
              FilterItem(
                select: type,
                label: 'Loại giá dịch vụ',
                onTap: (p0) {
                  type = p0;
                  setState(() {});
                },
                items: typesData
                    .map(
                      (e) => e.title ?? '',
                    )
                    .toList(),
              ),
              16.height,
              FilterItem(
                select: rangePrice,
                label: 'Đơn giá (VND)',
                onTap: (p0) {
                  rangePrice = p0;
                  setState(() {});
                },
                items: RangePriceV2Enum.values
                    .map(
                      (e) => e.title,
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
