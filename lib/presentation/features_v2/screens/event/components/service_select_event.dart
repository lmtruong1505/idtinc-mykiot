import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/shared/components/input/custom_drop_down.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/overlay_input.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../blocs/service/service_selection_bloc.dart';
import '../../../blocs/state/init_state.dart';
import '../../../models/employee/pre_emp_model.dart';

class ServiceSelectionEvent extends StatefulWidget {
  final ServiceSelectionEventBloc bloc;
  final List<PreEmpModel> employees;
  const ServiceSelectionEvent({
    super.key,
    required this.bloc,
    required this.employees,
  });

  @override
  State<ServiceSelectionEvent> createState() => _ServiceSelectionEventState();
}

class _ServiceSelectionEventState extends State<ServiceSelectionEvent> {
  final textCtrl = TextEditingController();
  bool autoFocus = false;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceSelectionEventBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Dịch vụ',
                  style: AppStyle.headingLg,
                ).expanded(),
                if (widget.bloc.list.isNotEmpty)
                  ChipCustom(
                    color: AppColors.button_neutral_alpha_textDefault,
                    isBorder: false,
                    title: 'Chọn lại',
                    padding: 12.padingHor + 6.padingVer,
                    onTap: () {
                      autoFocus = true;
                      widget.bloc.removeList();
                    },
                  ),
              ],
            ),
            12.height,
            _buildSearch(),
            12.height,
            _buildInfo(),
          ],
        );
      },
    );
  }

  SizedBox _buildSearch() {
    return OverlayInput<ServiceV2Model>(
      focusNode: focusNode,
      itemBuilder: (BuildContext context, item, int index) {
        return _buildItem(item);
      },
      onChanged: (item) {
        widget.bloc.addService(item);
      },
      header: Text(
        'Chọn dịch vụ',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      hintText: 'Tìm tên, mã dịch vụ',
      itemHeight: 87,
      lazyLoad: (isMore) => widget.bloc.getList(textCtrl.text, isMore: isMore),
      controller: textCtrl,
      borderRadius: 999,
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        size: 24,
      ),
      autoFocus: autoFocus,
    ).size(height: 40);
  }

  Widget _buildInfo() {
    if (widget.bloc.list.isEmpty) {
      return Center(
        child: Text(
          'Chưa có dịch vụ\nVui lòng tìm và lựa chọn dịch vụ',
          style: AppStyle.bodyMdRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ).padding(40.pading);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        12.height,
        _buildHuongDan,
        12.height,
        ListView.separated(
          padding: 0.pading,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Slidable(
              key: Key(widget.bloc.list[index].id.toString()),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    flex: 1,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(sp12),
                      bottomRight: Radius.circular(sp12),
                    ),
                    onPressed: (context) {
                      widget.bloc.remove(index);
                    },
                    backgroundColor: red_1,
                    foregroundColor: whiteColor,
                    icon: Icons.delete,
                    label: 'Xóa',
                  ),
                ],
              ),
              child: _buildItem(
                widget.bloc.list[index],
                onChanged: (p0) {
                  widget.bloc.updateDoctor(index, p0!);
                },
                isChoose: true,
              ),
            );
          },
          separatorBuilder: (context, index) => 10.height,
          itemCount: widget.bloc.list.length,
        ),
      ],
    );
  }

  Widget _buildItem(
    ServiceV2Model item, {
    bool isChoose = false,
    Function(PreEmpModel?)? onChanged,
  }) {
    final priceName = servicePriceName(context, item.price?.priceName ?? '');
    final empId = widget.employees.indexWhere(
      (element) => element.employee == item.employee?.employee,
    );
    return Row(
      children: [
        BaseCacheImage(
          url: item.images.validator.isEmpty ? '' : item.images!.first,
          height: 64,
          width: 64,
          borderRadius: 4.radius,
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.title ?? '',
              style: AppStyle.bodyBsMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            2.height,
            RichText(
              text: TextSpan(
                text: item.price?.price.formatPrice(
                      type: ' đ',
                    ) ??
                    '0 đ',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_secondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text:
                        '/${priceName.toLowerCase().replaceAll('vé ', '').replaceAll('gói ', '')}',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isChoose) ...[
              8.height,
              CustomDropDown<int>(
                onChanged: (p0) {
                  onChanged?.call(widget.employees[p0!]);
                },
                value: empId < 0 ? null : empId,
                items: List.generate(
                  widget.employees.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(
                      widget.employees[index].userData?.fullName ?? '',
                      style: AppStyle.bodyBsRegular,
                    ),
                  ),
                ),
                hintText: 'Chọn người thực hiện',
                icon: FaIcon(
                  iconCode: 'f0d7',
                  type: FaIconType.solid,
                ),
                showIconRemove: false,
                color: AppColors.bg_primary,
                contentPadding: 6.padingVer,
              ),
            ],
          ],
        ).padding(4.padingVer).expanded(),
      ],
    ).container(
      padding: 12.padingVer + 16.padingHor,
      radius: 12,
      border: isChoose ? Border.all(color: AppColors.border_tertiary) : null,
    );
  }

  Widget get _buildHuongDan {
    return Stack(
      children: [
        Container(
          width: context.width,
          padding: 20.padingVer + 12.padingHor,
          decoration: BoxDecoration(
            color: greyFF,
            borderRadius: 12.radius,
          ),
        ),
        Container(
          width: context.width - sp48,
          padding: 20.padingVer + 12.padingHor,
          decoration: BoxDecoration(
            color: greyFF,
            borderRadius: 12.radius,
            border: const Border(
              right: BorderSide(
                color: whiteColor,
                width: sp2,
              ),
            ),
          ),
        ),
        Container(
          width: context.width - sp64,
          padding: 12.padingVer + 12.padingHor,
          decoration: BoxDecoration(
            color: greyFF4,
            borderRadius: 12.radius,
            border: const Border(
              right: BorderSide(
                color: whiteColor,
                width: sp2,
              ),
            ),
          ),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Trượt sang trái để xem thêm',
                      style: AppStyle.bodySmRegular.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                    TextSpan(
                      text: '  Tùy chọn',
                      style: AppStyle.bodyBsMedium.copyWith(
                        color: AppColors.text_tertiary,
                      ),
                    ),
                  ],
                ),
              ).expanded(),
              FaIcon(iconCode: 'f323', type: FaIconType.solid),
            ],
          ),
        ),
      ],
    );
  }
}
