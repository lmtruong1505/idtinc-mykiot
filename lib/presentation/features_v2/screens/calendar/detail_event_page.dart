import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/detail_event_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../blocs/calendar/calendar_manager_bloc.dart';
import '../../blocs/calendar/create_event_bloc.dart';
import '../../blocs/calendar/delete_event_bloc.dart';
import '../customer/components/bg_action.dart';

@RoutePage()
class DetailEventPage extends StatefulWidget {
  final int id;
  const DetailEventPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage>
    with SingleTickerProviderStateMixin {
  final bloc = DetailEventBloc();
  final eventBloc = CreateEventBloc();
  final deleteBloc = DeleteEventBloc();
  final titleStyle = StyleApp.normal(color: ColorApp.grey79);
  final contentStyle = StyleApp.medium();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getData(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateEventBloc, CubitState>(
          bloc: eventBloc,
          listener: (context, state) {
            CheckStateBloc.check(
              context,
              state,
            );
          },
        ),
        BlocListener<DeleteEventBloc, CubitState>(
          bloc: deleteBloc,
          listener: (context, state) {
            CheckStateBloc.check(
              context,
              state,
              success: () {
                context.pop();
                context.pop();
                context.read<CalendarManagerBloc>().getList();
              },
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: const BaseAppBar(title: 'Chi tiết lịch hẹn'),
        body: BlocBuilder<DetailEventBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return LoadPage(
              state: state,
              height: null,
              child: _buildDetail(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetail() {
    if (bloc.event?.id == null) {
      return EmptyContainer(
        msg: bloc.state.msg,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          padding: sp16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfor(),
              sp16.height,
              _buildUserCreate(),
              context.padding.bottom.height,
            ],
          ),
        ).expanded(),
        if (bloc.event?.canceled == false)
          RowBtn(
            cancelText: 'Huỷ hẹn',
            confirmText: 'Tạo phiếu khám',
            onCancel: () {
              DialogUtils.showErrorDialog(
                context,
                content: 'Bạn có muốn huỷ lịch hẹn này',
                titleClose: 'Đóng',
                close: () => context.pop(),
                accept: () {
                  deleteBloc.delete(id: bloc.event?.id ?? 0);
                  context.pop();
                },
              );
            },
            onConfirm: () {
              // context.bottomSheet(
              //   BtsUpdateFile(event: bloc.event!),
              // );
              // context.pushRoute(
              //   CreateEventRoute(
              //     isEvent: false,
              //     event: bloc.event!,
              //   ),
              // );
              DialogUtils.showErrorDialog(
                context,
                content: 'Bạn có muốn tạo phiếu khám cho lịch hẹn này không',
                close: () => context.pop(),
                titleClose: 'Đóng',
                accept: () {
                  eventBloc.company = getCompany;
                  eventBloc.doctor = bloc.event?.doctorId;
                  eventBloc.customer = bloc.event?.customerId;
                  eventBloc.service = bloc.event?.services?.first.id;
                  eventBloc.createPhieuKham(
                    appointment: bloc.event?.id,
                  );
                  context.pop();
                },
              );
            },
          ).container(),
      ],
    );
  }

  Widget _buildUserCreate() {
    final style = StyleApp.normal();
    return BgAction(
      title: 'Thông tin tài khoản',
      isTextClick: false,
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      click: true,
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Người tạo',
              content: bloc.event?.userCreated?.fullName,
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Thời gian tạo',
              content: bloc.event?.createdAt.toDate
                  .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Người cập nhật',
              content: bloc.event?.userUpdated?.fullName,
              titleStyle: style,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Thời gian cập nhật',
              content: bloc.event?.updatedAt.toDate
                  .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: style,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfor() {
    return BgAction(
      title: 'Thông tin phiếu khám',
      isTextClick: false,
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      click: false,
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Mã cuộc hẹn',
              content: bloc.event?.code,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Khách hàng',
              content: bloc.event?.customer?.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            _textBtn(
              onTap: () {
                if (bloc.event?.customer != null) {
                  context.pushRoute(
                    RouteCustomerDetail(
                      customer: CustomerModel(
                        id: bloc.event?.customer?.id,
                        fullName: bloc.event?.customer?.fullName,
                      ),
                    ),
                  );
                }
              },
              title: 'Xem chi tiết khách hàng',
            ),
            TextRow2(
              title: 'Cơ sở',
              content: getCompanyName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Bác sĩ',
              content: bloc.event?.doctor?.fullName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            _textBtn(
              onTap: () {
                if (bloc.event?.doctor?.username != null) {
                  LaunchUrl.phone(bloc.event?.doctor?.username ?? '');
                }
              },
              title: 'Liên hệ bác sĩ',
            ),
            TextRow2(
              title: 'Dịch vụ',
              content: bloc.event?.services
                  ?.map(
                    (e) => e.title,
                  )
                  .toList()
                  .listToString,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            sp16.height,
            TextRow2(
              title: 'Thời gian',
              content: bloc.event?.meetingAt.toDate
                  .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textBtn({
    Function()? onTap,
    required String title,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        alignment: Alignment.centerRight,
        padding: 16.padingVer,
      ),
      child: Text(
        title,
        style: StyleApp.medium(
          color: ColorApp.blue20,
        ),
      ),
    );
  }
}
