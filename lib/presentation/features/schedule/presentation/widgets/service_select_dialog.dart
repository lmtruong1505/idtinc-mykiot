import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pharmago/presentation/constants/size_device.dart';

import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/button/icon_btn.dart';
import '../../../../../shared/components/input/custom_drop_down.dart';
import '../../../../../shared/components/input/input_qty.dart';
import '../../../../../shared/components/input/overlay_input.dart';
import '../../../../../shared/components/widgets/divider_custom.dart';
import '../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../base/cache_image.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../features_v2/blocs/event/list_staff_bloc.dart';
import '../../../../features_v2/blocs/service/service_selection_bloc.dart';
import '../../../../features_v2/blocs/state/cubit_state.dart';
import '../../../../features_v2/models/employee/pre_emp_model.dart';
import '../../../../features_v2/models/service/service.dart';

class ServiceSelectDialog extends StatefulWidget {
  const ServiceSelectDialog({
    super.key,
    this.services,
    this.callBack,
  });

  final List<ServiceV2Model>? services;
  final Function(List<ServiceV2Model> services)? callBack;

  static void show(
    BuildContext context, {
    List<ServiceV2Model>? services,
    Function(List<ServiceV2Model> services)? callBack,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            margin: const EdgeInsets.all(sp16).copyWith(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(sp12),
            ),
            child: ServiceSelectDialog(
              services: services,
              callBack: callBack,
            ),
          ),
        );
      },
    );
  }

  @override
  State<ServiceSelectDialog> createState() => _ServiceSelectDialogState();
}

class _ServiceSelectDialogState extends State<ServiceSelectDialog> {
  final textCtrl = TextEditingController();
  final bloc = ServiceSelectionEventBloc();
  final _empBloc = ListStaffServiceBloc();

  final List<ServiceV2Model> services = [];

  @override
  void initState() {
    super.initState();

    _empBloc.getList();
    setState(() {
      services.addAll(widget.services ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(sp16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Chọn dịch vụ',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingLg,
                ).expanded(),
                12.width,
                IconBtn(
                  onTap: () => context.pop(),
                  padding: 0.pading,
                  size: const Size(24, 24),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.button_neutral_alpha_iconDefault,
                  ),
                ),
              ],
            ),
            sp16.height,
            DividerCustom(),
            sp16.height,
            _buildSearch,
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: sp0,
                maxHeight: heightDevice(context) / 2,
              ),
              child: _buildInfo,
            ),
            sp16.height,
            DoubleButton(
              cancelText: widget.services != null ? 'Huỷ' : 'Bỏ qua',
              onCancel: () {
                context.pop();
              },
              confirmText:
                  widget.services != null ? 'Cập nhật' : 'Tạo phiếu khám',
              onConfirm: () {
                context.pop();
                widget.callBack?.call(services);
              },
            ).size(height: 32),
          ],
        ),
      ),
    );
  }

  SizedBox get _buildSearch {
    return OverlayInput<ServiceV2Model>(
      itemBuilder: (BuildContext context, item, int index) {
        final priceName =
            servicePriceName(context, item.price?.priceName ?? '');
        return Row(
          children: [
            BaseCacheImage(
              url: item.images.validator.isEmpty ? '' : item.images!.first,
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
              ],
            ).padding(4.padingVer).expanded(),
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: sp12));
      },
      onChanged: (item) {
        final index = services.indexWhere((e) => e.id == item.id);
        if (index == -1) {
          setState(() {
            services.add(item);
          });
        }
      },
      header: Text(
        'Chọn dịch vụ',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      hintText: 'Tìm tên, mã dịch vụ',
      lazyLoad: (isMore) => bloc.getList(textCtrl.text, isMore: isMore),
      controller: textCtrl,
      borderRadius: 999,
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        size: 24,
      ),
    ).size(height: 40);
  }

  Widget get _buildInfo {
    if (services.isEmpty) {
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          12.height,
          _buildHuongDan,
          12.height,
          BlocBuilder<ListStaffServiceBloc, CubitState>(
            bloc: _empBloc,
            builder: (context, state) {
              return ListView.separated(
                padding: 0.pading,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Slidable(
                    key: Key(services[index].id.toString()),
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
                            setState(() {
                              services.removeAt(index);
                            });
                          },
                          backgroundColor: red_1,
                          foregroundColor: whiteColor,
                          icon: Icons.delete,
                          label: 'Xóa',
                        ),
                      ],
                    ),
                    child: _buildItem(
                      services[index],
                      onChanged: (p0) {
                        // widget.bloc.updateDoctor(index, p0!);
                      },
                      isChoose: true,
                    ),
                  );
                },
                separatorBuilder: (context, index) => 10.height,
                itemCount: services.length,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    ServiceV2Model item, {
    bool isChoose = false,
    Function(PreEmpModel?)? onChanged,
  }) {
    final priceName = servicePriceName(context, item.price?.priceName ?? '');
    final empId = _empBloc.list.indexWhere(
      (e) => e.id == item.employee?.id,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BaseCacheImage(
              url: item.images.validator.isEmpty ? '' : item.images!.first,
              height: 64,
              width: 64,
              borderRadius: 4.radius,
            ),
            sp8.width,
            Text(
              item.title ?? '',
              style: AppStyle.bodyBsMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        if (isChoose)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: item.price?.price.formatPrice(
                              type: ' đ',
                            ) ??
                            '0 đ',
                        style: s12w500.copyWith(color: AppColors.text_primary),
                        children: [
                          TextSpan(
                            text:
                                '/${priceName.toLowerCase().replaceAll('vé ', '').replaceAll('gói ', '')}',
                            style: s12w400.copyWith(
                              color: AppColors.text_tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    sp4.height,
                    InputQuantity(
                      controller: TextEditingController(
                        text: item.quantity.toString(),
                      ),
                      action: (value) {
                        setState(() {
                          if (value) {
                            item.quantity += 1;
                          } else {
                            if (item.quantity == 1) return;
                            item.quantity -= 1;
                          }
                        });
                      },
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              sp8.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Người thực hiện',
                      style: s12w400.copyWith(color: AppColors.text_tertiary),
                    ),
                    sp4.height,
                    CustomDropDown<int>(
                      onChanged: (p0) {
                        // onChanged?.call(_empBloc.list[p0!]);
                        setState(() {
                          if (p0 != null) {
                            item.employee = _empBloc.list[p0];
                          }
                        });
                      },
                      value: empId < 0 ? null : empId,
                      items: List.generate(
                        _empBloc.list.length,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(
                            _empBloc.list[index].userData?.fullName ?? '',
                            style: AppStyle.bodyBsRegular,
                          ),
                        ),
                      ),
                      hintText: 'Chọn người thực hiện',
                      prefixIcon: FaIcon(
                        iconCode: 'f0f1',
                        type: FaIconType.solid,
                      ).padding(const EdgeInsets.only(left: sp4)),
                      icon: FaIcon(
                        iconCode: 'f0d7',
                        type: FaIconType.solid,
                      ),
                      showIconRemove: false,
                      color: AppColors.bg_primary,
                      contentPadding: 5.padingVer,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    ).container(
          padding: 12.padingVer + 16.padingHor,
          radius: 12,
          border:
              isChoose ? Border.all(color: AppColors.border_tertiary) : null,
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
