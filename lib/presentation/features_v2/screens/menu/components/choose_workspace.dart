part of './../menu_v2_page.dart';

class _ChooseWorkspace extends StatefulWidget {
  @override
  State<_ChooseWorkspace> createState() => _ChooseWorkspaceState();
}

class _ChooseWorkspaceState extends State<_ChooseWorkspace> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MenuCompanyBloc>();

    return Row(
      children: [
        Image.asset(
          Assets.logo,
          width: 32,
          height: 32,
        ),
        12.width,
        BlocBuilder<MenuCompanyBloc, CubitState>(
          builder: (context, state) {
            final title = isWorkspace ? 'Workspace' : 'Cơ sở';
            return Row(
              children: [
                Text(
                  !getCompanyName.isEmptyOrNull
                      ? '$title $getCompanyName'
                      : 'Chưa chọn ${isWorkspace ? 'Workspace' : "Cơ sở"}',
                  style: AppStyle.heading2xl,
                  overflow: TextOverflow.ellipsis,
                ).flexible(),
                PopupMenuButton(
                  color: AppColors.bg_primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: 8.radius,
                    side: const BorderSide(color: AppColors.border_tertiary),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: context.width,
                    minWidth: context.width,
                  ),
                  elevation: 3,
                  offset: const Offset(0, 45),
                  enabled: state.status == BlocStatus.success,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: state.status == BlocStatus.loading
                          ? const BaseLoading(
                              size: 22,
                            )
                          : const Icon(
                              Icons.swap_vert,
                            ),
                    ),
                  ),
                  itemBuilder: (context) => List.generate(
                    bloc.list.length,
                    (index) {
                      return PopupMenuItem(
                        onTap: () {
                          bloc.setCompany(bloc.list[index]);
                        },
                        child: Text(
                          '${bloc.list[index].parentId == null ? "Workspace" : 'Cơ sở'} ${bloc.list[index].workspaceName ?? ''}',
                          style: AppStyle.bodyBsMedium,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ).expanded(),
        IconBtn(
          onTap: () {
            context.pushRoute(const NotificationListRoute());
          },
          backgroundColor: AppColors.bg_primary,
          icon: const Icon(
            Icons.notifications_none_outlined,
          ),
        ),
      ],
    );
  }
}
