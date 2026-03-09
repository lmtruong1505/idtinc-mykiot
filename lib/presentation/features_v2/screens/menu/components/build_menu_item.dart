part of './../menu_v2_page.dart';

class _BuildMenuItem extends StatelessWidget {
  final Map<String, List<MenuModel>> item;
  _BuildMenuItem({
    required this.item,
  });
  final boolBloc = BoolBloc();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoolBloc, bool>(
      bloc: boolBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabelButton(
              onPressed: () {
                boolBloc.change(!state);
              },
              label: item.keys.first,
              radius: 0.radius,
              backgroundColor: AppColors.bg_primary,
              labelAlign: TextAlign.start,
              fit: FlexFit.tight,
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_quaternary,
              ),
              padding: EdgeInsets.zero,
              suffixIcon: AnimatedRotation(
                turns: !state ? 0 : -0.5,
                duration: const Duration(milliseconds: 300),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  key: ValueKey('icon2'),
                  size: 20,
                  color: AppColors.fg_quaternary,
                ),
              ),
            ).size(height: 35),
            ExpandedSection(
              isSelected: state,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  item.values.first.length,
                  (index) {
                    return itemClick(
                      context,
                      item.values.first[index],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget itemClick(BuildContext context, MenuModel menu) {
    return LabelButton(
      onPressed: () {
        if (menu.routePage.routeName == ListWorkspaceRoute.name) {
          getIt<CompanyChooseBloc>().company = null;
          context.router.replaceAll([menu.routePage]);
        } else {
          context.pushRoute(menu.routePage);
        }
      },
      label: menu.title,
      radius: 0.radius,
      backgroundColor: AppColors.bg_primary,
      labelAlign: TextAlign.start,
      fit: FlexFit.tight,
      labelStyle: AppStyle.bodyBsMedium.copyWith(
        color: AppColors.text_secondary,
      ),
      padding: 12.padingHor,
      spaceIcon: 12,
      prefixIcon: SizedBox(
        width: 20,
        height: 20,
        child: Center(child: menu.leading),
      ),
    ).size(height: 40);
  }
}
