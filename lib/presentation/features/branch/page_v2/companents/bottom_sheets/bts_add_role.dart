import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/input/app_input.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../features_v2/models/role/role_model.dart';

class BtsAddRole extends StatefulWidget {
  final List<RoleListModel> roles;
  const BtsAddRole({
    super.key,
    required this.roles,
  });

  @override
  State<BtsAddRole> createState() => _BtsAddRoleState();
}

class _BtsAddRoleState extends State<BtsAddRole> {
  List<RoleListModel> roles = [];

  List<int> get ids => roles.map((e) => e.id!).toList();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roles.addAll(widget.roles);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ListRoleBloc>();
    return BlocBuilder<ListRoleBloc, CubitState>(
      builder: (context, state) {
        return BgBts(
          label: 'Chọn vai trò',
          cancelText: 'Huỷ',
          confirmText: 'Xác nhận',
          onCancel: () => context.pop(),
          onConfirm: () {
            context.pop(result: roles);
          },
          subChild: ExpandedSection(
            isSelected: ids.isNotEmpty,
            child: Row(
              children: [
                Text(
                  'Đã chọn ',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
                Text(
                  '(${ids.length})',
                  style: AppStyle.headingMd,
                ),
              ],
            ).container(
              padding: 28.padingHor + 12.padingVer,
              radius: 0,
              border: const Border(
                top: BorderSide(
                  color: AppColors.border_tertiary,
                ),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppInputV2(
                hintText: 'Tìm vai trò',
                radius: 40,
                onChanged: bloc.search,
                contentPadding: 12.padingHor,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.input_iconDefault,
                ),
              ).size(height: 40),
              20.height,
              LoadPage(
                state: state,
                listEmpty: bloc.list.isEmpty,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    bloc.list.length,
                    (index) {
                      return _item(
                        isActive: ids.contains(bloc.list[index].id),
                        title: bloc.list[index].title ?? '',
                        onPressed: () {
                          if (ids.contains(bloc.list[index].id)) {
                            roles.removeWhere(
                              (element) => element.id == bloc.list[index].id,
                            );
                          } else {
                            roles.add(bloc.list[index]);
                          }
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _item({
    bool isActive = false,
    required String title,
    required Function() onPressed,
  }) {
    return Padding(
      padding: 10.padingHor,
      child: LabelButton(
        label: title,
        onPressed: onPressed,
        padding: 6.pading,
        backgroundColor:
            isActive ? AppColors.bg_primary_active : AppColors.bg_primary,
        labelStyle: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.text_secondary,
        ),
        radius: 6.radius,
        fit: FlexFit.tight,
        suffixIcon: isActive
            ? const Icon(
                Icons.check_circle,
                size: 15,
                color: AppColors.fg_positive,
              )
            : null,
      ),
    );
  }
}
