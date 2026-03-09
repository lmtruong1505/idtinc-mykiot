import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/check_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/emp_info_popup.dart';
import 'package:pharmago/presentation/features_v2/screens/event/components/tab_list.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../shared/components/dialog/dialog_message.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/employee/emp_information_bloc.dart';
import 'tabs/info_tab.dart';

@RoutePage()
class EmpInformationPage extends StatefulWidget {
  const EmpInformationPage({
    super.key,
    required this.id,
    this.onRefresh,
  });

  final int id;
  final VoidCallback? onRefresh;

  @override
  State<EmpInformationPage> createState() => _EmpInformationPageState();
}

class _EmpInformationPageState extends State<EmpInformationPage> {
  final bloc = EmpInformationBloc();

  @override
  void initState() {
    bloc.init(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmpInformationBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.success) {
          widget.onRefresh?.call();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBarCustom(
            title: 'Quản lý nhân viên',
            subTitle: 'Thông tin nhân viên',
            actions: [
              EmpInfoPopup(
                child: IconBtn(
                  backgroundColor: AppColors.bg_primary,
                  icon: const Icon(
                    Icons.more_vert,
                    size: 15,
                  ),
                ),
                onTap: (value) {
                  switch (value) {
                    case EmpInfoEvent.edit:
                      if (bloc.model != null) {
                        final m = bloc.model!;
                        context.router.push(
                          EditEmpRoute(
                            model: m,
                            onRefresh: () {
                              bloc.init(widget.id);
                            },
                          ),
                        );
                      }
                      break;
                    case EmpInfoEvent.quit:
                      if (bloc.model == null) {
                        return;
                      }
                      _buildDialog();
                      break;
                  }
                },
              ),
            ],
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  _buildDialog() {
    context.dialog(
      DialogConfirm(
        title: 'Xác nhận xóa nhân viên',
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Bạn có chắc chắn muốn xóa nhân viên (Cho nghỉ việc) ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
            children: [
              TextSpan(
                text: bloc.model!.userData?.fullName.validator,
                style: AppStyle.bodyBsSemiBold.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              TextSpan(
                text: ' không?',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
            ],
          ),
        ),
        actionConfirmBorder: true,
        colorConfirmBtn: AppColors.button_negative_outlined_textDefault,
        icon: IconDiaLog(
          color: AppColors.fg_negative.withOpacity(0.1),
          icon: const Icon(
            Icons.delete,
            color: AppColors.fg_negative,
            size: 32,
          ),
        ),
        confirm: () {
          bloc.terminate(widget.id).then((value) {
            if (value.code == 200) {
              context.pop();
              bloc.init(widget.id);
              CheckStateBloc.showSnackBar(context, 'Nghỉ việc thành công');
            } else {
              context.pop();
              CheckStateBloc.showSnackBar(
                context,
                'Xoá nhân viên ${bloc.model?.userData?.fullName ?? ''} thất bại',
                colorBg: AppColors.ultility_negative_60,
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<EmpInformationBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return LoadPage(
          state: state,
          height: null,
          errorView: EmptyComfirm(
            text: 'Không tìm thấy thông tin nhân viên',
            onPressed: null,
          ),
          child: Column(
            children: [
              Container(
                height: 45,
                padding: 20.padingHor,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border_tertiary),
                  ),
                ),
                child: TabBar(
                  labelStyle: AppStyle.bodyBsMedium.copyWith(height: 1.2),
                  labelColor: AppColors.text_primary,
                  unselectedLabelStyle:
                      AppStyle.bodyBsRegular.copyWith(height: 1.2),
                  unselectedLabelColor: AppColors.text_tertiary,
                  indicatorColor: AppColors.border_primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.zero,
                  tabs: const [
                    Tab(
                      text: 'Thông tin',
                    ),
                    Tab(
                      text: 'Lịch hẹn',
                    ),
                  ],
                ),
              ),
              TabBarView(
                children: [
                  InfoTab(
                    bloc: bloc,
                    onTerminated: () {
                      context.router.maybePop(true);
                    },
                  ),
                  TabListEvent(
                    doctorId: widget.id,
                    workingData: bloc.model?.workingData,
                  ),
                ],
              ).expanded(),
            ],
          ),
        );
      },
    );
  }
}
