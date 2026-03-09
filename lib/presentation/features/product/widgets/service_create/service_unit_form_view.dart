import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';

import '../../../../base/svg.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../cubit/service_create_cubit/service_create_state.dart';

class ServiceUnitFormView extends StatefulWidget {
  const ServiceUnitFormView({required this.myBloc, super.key});

  final ServiceCreateCubit myBloc;

  @override
  State<ServiceUnitFormView> createState() => _ServiceUnitFormViewState();
}

class _ServiceUnitFormViewState extends State<ServiceUnitFormView> {
  late TextEditingController _tec;
  late ExpandableController _expandableController;

  @override
  void initState() {
    super.initState();

    _expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
    
    _tec = TextEditingController();
  }

  @override
  void dispose() {
    _expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        return ExpandableNotifier(
          controller: _expandableController,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              hasIcon: false,
            ),
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
                    'Đơn vị tính',
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
            expanded: _buildExpanded(context),
          ),
        );
      },
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
      decoration: BoxDecoration(
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(sp12)),
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
          gapHeight(sp12),
          AppInput(
            label: 'Đơn vị',
            required: true,
            hintText: 'Nhập tên đơn vị',
            backgroundColor: bg_4,
            borderColor: bg_4,
            textInputType: TextInputType.text,
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Nhập đơn vị cơ bản';
              }
            },
            onChanged: (value) {
              widget.myBloc.infoFormChange(unit: value.trim());
            },
          ),
          gapHeight(sp16),
          InputCurrency(
            controller: _tec,
            label: 'Đơn giá',
            required: true,
            hintText: 'Nhập giá bán',
            backgroundColor: bg_4,
            borderColor: bg_4,
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Nhập đơn vị cơ bản';
              }
            },
            onChanged: (value) {
              widget.myBloc.infoFormChange(price: double.parse(value.trim()));
            },
          ),
          gapHeight(sp16),
          AppInput(
            label: 'Mô tả',
            hintText: 'Nhập mô tả',
            backgroundColor: bg_4,
            borderColor: bg_4,
            textInputType: TextInputType.text,
            onChanged: (value) {
              widget.myBloc.infoFormChange(description: value.trim());
            },
          ),
        ],
      ),
    );
  }
}
