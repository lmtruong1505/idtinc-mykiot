import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features/address/cubit/location/location_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/bg_action.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import 'build_infor.dart';

class TabInforStaff extends StatefulWidget {
  final EmployeeModel model;
  const TabInforStaff({super.key, required this.model});

  @override
  State<TabInforStaff> createState() => _TabInforStaffState();
}

class _TabInforStaffState extends State<TabInforStaff>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildInfor(widget.model),
              16.height,
              _buildAccount(),
              16.height,
              _buildUser(),
              context.padding.bottom.height,
            ],
          ),
        ).expanded(),
        MainButtonV2(
          onTap: () {
            context.pushRoute(ChangePassStaffRoute(staff: widget.model));
          },
          title: 'Đổi mật khẩu',
        ).container()
      ],
    );
  }

  BgAction _buildAccount() {
    return BgAction(
      title: 'Thông tin tài khoản',
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      isTextClick: false,
      click: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextRow2(
            title: 'Vai trò nhân viên',
            content: widget.model.roleData?.title,
          ),
          8.height,
          TextRow2(
            crossAxisAlignment: CrossAxisAlignment.start,
            title: 'Cơ sở',
            content: widget.model.companyName,
          ),
          8.height,
          TextRow2(
            title: 'Người tạo',
            content: widget.model.roleData?.userCreatedName,
          ),
          8.height,
          TextRow2(
            title: 'Thời gian tạo',
            content: widget.model.roleData?.createdAt
                .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
          ),
          8.height,
          TextRow2(
            title: 'Người cập nhật',
            content: widget.model.roleData?.userUpdatedName,
          ),
          8.height,
          TextRow2(
            title: 'Thời gian cập nhật',
            content: widget.model.roleData?.updatedAt
                .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
          ),
        ],
      ).padding(
        16.pading,
      ),
    );
  }

  BgAction _buildUser() {
    return BgAction(
      title: 'Thông tin cá nhân',
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      isTextClick: false,
      click: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextRow2(
            title: 'Email',
            content: widget.model.email,
          ),
          8.height,
          TextRow2(
            crossAxisAlignment: CrossAxisAlignment.start,
            title: 'Vị trí',
            content: BackAddress.mapData(widget.model.address).addressDetail,
          ),
          8.height,
          TextRow2(
            title: 'Số điện thoại',
            content: widget.model.username,
          ),
          8.height,
          TextRow2(
            title: 'Ngày sinh',
            content: widget.model.dob.fomatDefaulft,
          ),
          8.height,
          TextRow2(
            title: 'Số CMND/CCCD',
            content: widget.model.licence,
          ),
        ],
      ).padding(
        16.pading,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
