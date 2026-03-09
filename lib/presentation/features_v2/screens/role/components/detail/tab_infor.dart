import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/bg_action.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../models/role/detail_role_model.dart';

class TabInforRole extends StatelessWidget {
  final DetailRoleModel model;
  const TabInforRole({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BgAction(
            title: 'Thông tin vai trò',
            click: true,
            colorTitle: ColorApp.grey,
            isTextClick: false,
            fontSize: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  model.role?.title ?? '',
                  style: StyleApp.medium(),
                ),
                4.height,
                Text(
                  '${model.role?.totalEmployee ?? 0} nhân viên',
                  style: StyleApp.medium(color: ColorApp.grey),
                ),
                16.height,
                TextRow2(
                  title: 'Người tạo',
                  content: model.role?.userCreatedName ?? '',
                ),
                8.height,
                TextRow2(
                  title: 'Thời gian tạo',
                  content: model.role?.createdAt
                      .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
                ),
                8.height,
                TextRow2(
                  title: 'Người cập nhật',
                  content: model.role?.userUpdatedName ?? '',
                ),
                8.height,
                TextRow2(
                  title: 'Thời gian cập nhật',
                  content: model.role?.updatedAt
                      .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
                ),
              ],
            ).container(),
          ),
        ],
      ),
    );
  }
}
