import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../base/svg.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../cubit/service_detail_cubit/service_detail_cubit.dart';
import '../../cubit/service_detail_cubit/service_detail_state.dart';

class ServiceDetailReminder extends StatefulWidget {
  const ServiceDetailReminder({required this.myBloc, super.key});

  final ServiceDetailCubit myBloc;

  @override
  State<ServiceDetailReminder> createState() => _ServiceDetailReminderState();
}

class _ServiceDetailReminderState extends State<ServiceDetailReminder> {
  late ExpandableController _expandableController;

  @override
  void initState() {
    _expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return ExpandableNotifier(
          controller: _expandableController,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(hasIcon: false),
            header: Container(
              padding: const EdgeInsets.all(sp16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(sp8),
                  bottom: Radius.circular(
                    _expandableController.expanded ? sp0 : sp8,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nhắc hẹn',
                    style: p3.copyWith(color: blackColor),
                  ),
                  AnimatedRotation(
                    turns: !_expandableController.expanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: IcSvg.asset('/ic_arrow_down.svg'),
                  ),
                ],
              ),
            ),
            collapsed: Container(),
            expanded: _buildExpanded(context, state),
          ),
        );
      },
    );
  }

  Widget _buildExpanded(BuildContext context, ServiceDetailState state) {
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(sp12),
        ),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            offset: const Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thời gian nhắc hẹn', style: p6.copyWith(color: blackColor)),
              Text(
                reminder ? '${state.service?.reminderTime ?? ''} ${state.service?.frequency?.toLowerCase()}/lần' : 'Không',
                style: p5.copyWith(color: blackColor),
              ),
            ],
          ),
          gapHeight(sp8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gửi tin nhắc hẹn qua',
                style: p6.copyWith(color: blackColor),
              ),
              Text('Zalo', style: p5.copyWith(color: blackColor)),
            ],
          ),
          gapHeight(sp8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lời nhắn', style: p6.copyWith(color: blackColor))
                  .expanded(),
              Text(
                state.service?.message ?? '',
                style: p5.copyWith(color: blackColor),
                textAlign: TextAlign.right,
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }
  bool get reminder {
    return widget.myBloc.state.service?.reminderTime != null &&
        widget.myBloc.state.service?.frequency != null;
  }
}
