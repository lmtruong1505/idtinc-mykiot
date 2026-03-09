import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features_v2/models/role/detail_role_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../customer/components/bg_action.dart';

class TabPermissionRole extends StatelessWidget {
  final DetailRoleModel model;
  const TabPermissionRole({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final list = model.items ?? [];
    final isShow = list.fold(
      false,
      (previousValue, element) =>
          previousValue == true ||
          element.subApp?.fold(
                false,
                (previousValue1, element1) =>
                    previousValue1 == true || element1.value == true,
              ) ==
              true,
    );

    if (!isShow) {
      return SingleChildScrollView(
        padding: 16.pading,
        child: const EmptyContainer(
          msg: 'Chưa có phân quyền nào cho vai trò này',
        ),
      );
    }
    return ListView.builder(
      padding: 16.pading,
      itemBuilder: (context, index) {
        final role = list[index];
        final isShow = list[index].subApp?.fold(
              false,
              (previousValue, element) =>
                  previousValue == true || element.value == true,
            );
        if (isShow == false) {
          return const SizedBox();
        }
        final items = list[index].subApp ?? [];
        items.removeWhere(
          (element) => element.value != true,
        );
        return BgAction(
          title: role.title ?? '',
          click: true,
          colorTitle: ColorApp.grey,
          isTextClick: false,
          fontSize: 14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              items.length,
              (index1) {
                final item = items[index1];
                return Text(
                  item.title ?? '',
                  style: StyleApp.medium(),
                ).padding(4.padingBottom);
              },
            ),
          ).container(),
        ).padding(16.padingBottom);
      },
      
      itemCount: list.length,
    );
  }
}
