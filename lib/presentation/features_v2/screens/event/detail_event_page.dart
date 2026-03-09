import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_calendar_time.dart';
import 'package:pharmago/presentation/features_v2/blocs/role_v2/role_per_ws_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/service/service.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/bg/bg_btn_nav_bar.dart';
import 'package:pharmago/shared/components/bg/bg_detail.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_list.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/zalo_oa_resend.dart';
import '../../../base/cache_image.dart';
import '../../../config/role/check_role_per.dart';
import '../../../config/role/permission/index.dart';
import '../../../features/company/screen_v2/components/menu_action_dialog.dart';
import '../../../features/company/screen_v2/components/menu_popup.dart';
import '../../blocs/event/action_event_bloc.dart';
import '../../blocs/event/detail_event_bloc.dart';
import '../../blocs/event/list_event_bloc.dart';
import '../../models/event/detail_event_model.dart';
import 'components/dialog_cancel_event.dart';
import 'components/items/base_event.dart';
import 'components/reminder_zalo_event.dart';

@RoutePage()
class DetailEventV2Page extends StatefulWidget {
  final int id;
  const DetailEventV2Page({super.key, required this.id});

  @override
  State<DetailEventV2Page> createState() => _DetailEventV2PageState();
}

class _DetailEventV2PageState extends State<DetailEventV2Page> {
  final _bloc = DetailEventV2Bloc();
  final _blocAction = ActionEventV2Bloc();

  @override
  void initState() {
    super.initState();
    _bloc.getData(widget.id);
  }

  void reSendEventZalo() {
    _blocAction.reSendEventZalo(widget.id);
  }

  void cancelEvent() {
    context.dialog(const DialogCancelEvent()).then(
      (value) {
        if (value is String) {
          _blocAction.cancel(widget.id, value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionEventV2Bloc, CubitState>(
      bloc: _blocAction,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          success: () {
            if (state.data != 'resend-event-zalo') {
              getIt<ListEventV2Bloc>().getList();
              if (state.data == 'remove') {
                context.router.popUntil(
                  (route) => route.settings.name == ListEventRoute.name,
                );
              } else {
                _bloc.getData(widget.id);
              }
            }
          },
        );
      },
      child: BlocBuilder<DetailEventV2Bloc, CubitState<DetailEventV2Model>>(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarCustom(
              title: 'Trở về',
              subTitle: 'Chi tiết lịch hẹn',
              actions: [if (state.data != null) _buildMenu()],
            ),
            bottomNavigationBar:
                state.data?.status == EnumCalendarTime.comfirmed.code
                    ? BgBtnNavBar(
                        child: LabelButton(
                          onPressed: () {
                            if (checkPermission(PerOrderEnum.CREATE.code)) {
                              context
                                  .pushRoute(
                                CreateOrderRoute(
                                  type: 'service',
                                  services: _bloc.state.data?.services,
                                  customer: _bloc.state.data?.customerId,
                                  appointment: _bloc.state.data?.id,
                                ),
                              )
                                  .then(
                                (value) {
                                  if (value == true) {
                                    _blocAction.updateStatus(
                                      widget.id,
                                      EnumCalendarTime.arrived.code,
                                    );
                                  }
                                },
                              );
                            }
                          },
                          prefixIcon: FaIcon(
                            iconCode: 'f274',
                            color: AppColors.bg_primary,
                          ),
                          label: 'Tạo đơn hàng dịch vụ',
                        ),
                      )
                    : null,
            body: LoadPage(
              state: state,
              height: null,
              errorView: EmptyComfirm(text: state.msg, onPressed: null),
              child: BgDetail(
                child: SingleChildScrollView(
                  padding: 16.pading + context.padding.bottom.padingBottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BaseEvent(
                        code: state.data?.code ?? '',
                        status: state.data?.status ?? '',
                        date: state.data?.meetingAt,
                        patient: state.data?.customer?.fullName ?? '',
                        isDetail: true,
                      ).container(
                        bgColor: AppColors.bg_secondary_subtle,
                        padding: 12.padingHor + 6.padingVer,
                      ),
                      8.height,
                      _buildInfor(),
                      24.height,
                      ReSendZaloOaWidget(
                        reSend: reSendEventZalo,
                      ),
                      24.height,
                      DividerCustom(),
                      24.height,
                      Text(
                        'Danh sách dịch vụ',
                        style: AppStyle.headingLg,
                      ),
                      12.height,
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _buildService(index),
                        separatorBuilder: (context, index) => DividerCustom(),
                        itemCount: (state.data?.services ?? []).length,
                      ),
                      24.height,
                      _buildReminder(),
                      if (_bloc.state.data?.status ==
                          EnumCalendarTime.comfirmed.code)
                        LabelButton(
                          onPressed:
                              checkPermission(PerAppointmentEnum.CANCEL.code)
                                  ? cancelEvent
                                  : null,
                          prefixIcon: FaIcon(
                            iconCode: 'f273',
                            color: AppColors.button_negative_alpha_iconDefault,
                          ),
                          label: 'Hủy lịch hẹn',
                          backgroundColor:
                              AppColors.button_negative_alpha_backgroundDefault,
                          labelStyle: AppStyle.bodyBsMedium.copyWith(
                            color: AppColors.ultility_negative_60,
                          ),
                        ).size(height: 32),
                    ],
                  ).container(
                    padding: 12.pading,
                    radius: 16,
                    border: Border.all(color: AppColors.border_tertiary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool get isEdit =>
      _bloc.state.data?.status == EnumCalendarTime.comfirmed.code ||
      _bloc.state.data?.status == EnumCalendarTime.canceled.code;
  Widget _buildMenu() {
    print(getIt<RolePermissionWsBloc>().permission);
    return MenuPopupWorkSpace(
      onTap: (value) {
        if (value == StatusMenuWorkspace.edit) {
          if (!isEdit) {
            ToastCustom.show(
              context,
              title: 'Thông báo',
              msg:
                  'Chỉ được sửa lịch hẹn khi ở trạng thái đã xác nhận hoặc đã huỷ',
            );
            return;
          }

          context.pushRoute(CreateEventV2Route(event: _bloc.state.data!));
          return;
        }
        menuActionDialog(
          context,
          value: value,
          title: 'lịch hẹn',
          typeName: 'lịch hẹn',
          contentText:
              'Bạn có chắc chắn muốn ${value.title.toLowerCase()} này không',
          confirm: () {
            context.pop();

            if (value == StatusMenuWorkspace.remove) {
              _blocAction.remove(widget.id);
              return;
            }
          },
        );
      },
      isDetail: true,
      isStatus: false,
      isEdit: isEdit && checkPermission(PerAppointmentEnum.EDIT.code),
      isDelete: _bloc.state.data?.status == EnumCalendarTime.canceled.code &&
          checkPermission(PerAppointmentEnum.DELETE.code),
      child: IconBtn(
        backgroundColor: AppColors.bg_primary,
        icon: const Icon(
          Icons.more_vert,
          size: 15,
        ),
      ),
    );
  }

  Widget _buildReminder() {
    final reminders = _bloc.state.data?.reminders ?? [];
    if (reminders.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DividerCustom(),
        24.height,
        Text(
          'Nhắc hẹn',
          style: AppStyle.headingLg,
        ),
        12.height,
        GridView.count(
          crossAxisCount: ((context.width - 46) / 110).floor(),
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            reminders.length,
            (index) => ReminderZalo(
              reminders[index],
              resend: () {
                _blocAction.reminderZalo(reminders[index].id!);
              },
            ),
          ),
        ),
        Text(
          'Lời nhắn',
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
            height: 1.5,
          ),
        ),
        Text(
          reminders.first.message ?? '',
          style: AppStyle.bodyBsMedium,
        ),
        24.height,
      ],
    );
  }

  Widget _buildService(int index) {
    final service = (_bloc.state.data?.services ?? [])[index];
    final price = service.price;

    final priceName = servicePriceName(
      context,
      price?.priceName ?? '',
    );
    return Padding(
      padding: 12.padingVer,
      child: Row(
        children: [
          Text(
            '${index + 1}.',
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          6.width,
          BaseCacheImage(
            url: service.serviceData!.images.validator.isEmpty
                ? ''
                : service.serviceData!.images!.first,
            width: 40,
            height: 40,
            borderRadius: 4.radius,
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                service.serviceData!.title ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.bodyBsMedium.copyWith(
                  height: 1.5,
                ),
              ),
              if (price != null) 8.height,
              if (price != null)
                RichText(
                  text: TextSpan(
                    text: price.price.formatPrice(type: ' đ'),
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.text_secondary,
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
              8.height,
              RichText(
                text: TextSpan(
                  text: 'Bác sĩ ',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                  children: [
                    TextSpan(
                      text: service.employeeData?.fullName ?? '',
                      style: AppStyle.headingBs.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildInfor() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FaIcon(
                  iconCode: 'f0c0',
                  type: FaIconType.solid,
                  size: 8,
                ),
                6.width,
                Text(
                  'Khách hàng',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ).expanded(),
              ],
            ),
            Text(
              _bloc.state.data?.customer?.fullName ?? '',
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyBsSemiBold.copyWith(
                color: AppColors.text_secondary,
                height: 1.5,
              ),
            ),
            Text(
              _bloc.state.data?.customer?.phone ?? '',
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ).expanded(flex: 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FaIcon(
                  iconCode: 'f54f',
                  type: FaIconType.solid,
                  size: 8,
                ),
                6.width,
                Text(
                  'Cơ sở',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ).expanded(),
              ],
            ),
            Text(
              _bloc.state.data?.workspace?.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodyBsSemiBold.copyWith(
                color: AppColors.text_secondary,
                height: 1.5,
              ),
            ),
          ],
        ).expanded(),
      ],
    ).padding(12.padingHor);
  }
}
