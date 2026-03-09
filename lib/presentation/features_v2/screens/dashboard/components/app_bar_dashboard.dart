import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_state.dart';
import 'package:pharmago/presentation/features/home/cubit/nav_home_bloc.dart';
import 'package:pharmago/shared/components/input/custom_drop_down.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/icon_btn.dart';
import '../../../../../shared/style_app/init_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../features/company/cubit/work_space/work_space_cubit.dart';
import '../../../../router/router.gr.dart';

class AppbarDashboard extends StatelessWidget implements PreferredSizeWidget {
  final Function(int?)? onChanged;
  final Function(List<DateTime?>)? dateChanged;
  final List<DateTime?>? dateFilter;
  AppbarDashboard({
    super.key,
    this.onChanged,
    this.dateChanged,
    this.dateFilter,
  });
  final myBloc = getIt.get<WorkSpaceCubit>();

  @override
  Widget build(BuildContext context) {
    final paddingStatusBar = context.padding.top;

    return BlocBuilder<WorkSpaceCubit, WorkSpaceState>(
      bloc: myBloc,
      builder: (context, state) {
        return Container(
          padding: paddingStatusBar.padingTop,
          decoration: BoxDecoration(
            color: ColorApp.white.withOpacity(0.5),
            borderRadius: 16.radiusBottom,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(32, 16, 24, 40),
                blurRadius: sp4,
                offset: Offset(0, 1),
                spreadRadius: sp2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              16.height,
              Row(
                children: [
                  CustomDropDown<int>(
                    value: state.companyId,
                    items: state.companies
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(
                              e.name ?? '',
                              style: StyleApp.medium(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (p0) async {
                      await myBloc.setComapny(p0 ?? 0);
                      context.read<NavHomeBloc>().onChanged(TabCodeNav.home);

                      onChanged?.call(p0);
                    },
                    icon: const Icon(Icons.swap_horiz_rounded),
                    hintText: 'Chọn Workspace',
                    borderColor: ColorApp.white,
                    color: ColorApp.white,
                    radius: sp24,
                    showIconRemove: false,
                    contentPadding: sp8.padingVer,
                  ).expanded(),
                  8.width,
                  IconBtn(
                    onTap: () {
                      context.router.push(const WalletRoute());
                    },
                    backgroundColor: ColorApp.white,
                    count: 0,
                    icon: FaIcon(iconCode: 'f555', type: FaIconType.solid)
                        .padding(const EdgeInsets.all(4)),
                  ),
                  8.width,
                  IconBtn(
                    onTap: () {
                      DialogUtils.showCalendarDialog(
                        context,
                        selectedDate: dateFilter ?? [null, null],
                        onConfirm: (p0) {
                          dateChanged?.call(p0);
                        },
                      );
                    },
                    backgroundColor: ColorApp.white,
                    count: 0,
                    icon: Badge(
                      isLabelVisible: dateFilter != null,
                      child: FaIcon(iconCode: 'e0d6')
                          .padding(const EdgeInsets.all(4)),
                    ),
                  ),
                  8.width,
                  IconBtn(
                    onTap: () =>
                        context.router.push(const NotificationListRoute()),
                    count: 0,
                    backgroundColor: ColorApp.white,
                    icon: Badge(
                      child: FaIcon(iconCode: 'f0f3')
                          .padding(const EdgeInsets.all(4)),
                    ),
                  ),
                ],
              ).padding(16.padingHor),
              8.height,
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
