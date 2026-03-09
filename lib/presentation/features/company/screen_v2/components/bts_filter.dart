import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../cubit/create_company_cubit/create_company_cubit.dart';
import '../../cubit/create_company_cubit/create_company_state.dart';

// ignore: must_be_immutable
class BtsFilterWorkspace extends StatefulWidget {
  Function(
    StatusWorkSpace? status,
    String? type,
    TimeWorkSpace? time,
    RevenueWorkSpace? revenue,
  ) onChange;
  StatusWorkSpace? status;
  String? type;
  TimeWorkSpace? time;
  RevenueWorkSpace? revenue;

  BtsFilterWorkspace({
    super.key,
    required this.onChange,
    this.status,
    this.type,
    this.time,
    this.revenue,
  });

  @override
  State<BtsFilterWorkspace> createState() => _BtsFilterWorkspaceState();
}

class _BtsFilterWorkspaceState extends State<BtsFilterWorkspace> {
  final wpbloc = getIt<CreateCompanyCubit>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wpbloc.getType();
  }

  final statusData = StatusWorkSpace.values
      .where(
        (element) =>
            element != StatusWorkSpace.closed &&
            element != StatusWorkSpace.review &&
            element != StatusWorkSpace.suspenged,
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.status = null;
        widget.type = null;
        widget.time = null;
        widget.revenue = null;
        setState(() {});
        widget.onChange(
          null,
          null,
          null,
          null,
        );
        context.pop();
      },
      onConfirm: () {
        widget.onChange(
          widget.status,
          widget.type,
          widget.time,
          widget.revenue,
        );
        context.pop();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterItem(
            label: 'Trạng thái',
            select: widget.status == null
                ? 0
                : statusData.indexOf(
                    widget.status!,
                  ),
            onTap: (p0) {
              widget.status = statusData[p0];
              setState(() {});
            },
            items: List.generate(
              statusData.length,
              (index) => statusData[index].title,
            ),
          ),
          16.height,
          BlocBuilder<CreateCompanyCubit, CreateCompanyState>(
            bloc: wpbloc,
            builder: (context, state) {
              final list = [
                const BasicEntity(
                  name: 'Tất cả',
                ),
                ...state.companyTypes,
              ];
              final int select = list.indexWhere(
                (element) => element.code == widget.type,
              );
              return FilterItem(
                label: 'Loại Workspace',
                select: select,
                items: list
                    .map(
                      (e) => e.name ?? '',
                    )
                    .toList(),
                onTap: (p0) {
                  widget.type = list[p0].code;
                  setState(() {});
                },
              );
            },
          ),
          16.height,
          Row(
            children: [
              Text(
                'Sắp xếp',
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              8.width,
              const Divider().expanded(),
            ],
          ),
          16.height,
          FilterItem(
            label: 'Thời gian',
            isDivide: false,
            select: widget.time?.index,
            onTap: (p0) {
              widget.time = TimeWorkSpace.values[p0];
              widget.revenue = null;
              setState(() {});
            },
            items: List.generate(
              TimeWorkSpace.values.length,
              (index) => TimeWorkSpace.values[index].title,
            ),
          ),
          8.height,
          FilterItem(
            label: 'Doanh số',
            isDivide: false,
            select: widget.revenue?.index,
            onTap: (p0) {
              widget.revenue = RevenueWorkSpace.values[p0];
              widget.time = null;
              setState(() {});
            },
            items: List.generate(
              RevenueWorkSpace.values.length,
              (index) => RevenueWorkSpace.values[index].title,
            ),
          ),
        ],
      ),
    );
  }
}
