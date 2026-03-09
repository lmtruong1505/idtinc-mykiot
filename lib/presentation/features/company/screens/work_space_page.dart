import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/check_version/check_vesion.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/create_company_cubit/create_company_state.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_cubit.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../cubit/work_space/work_space_state.dart';

@RoutePage()
class WorkSpacePage extends StatefulWidget {
  const WorkSpacePage({
    super.key,
  });

  @override
  State<WorkSpacePage> createState() => _WorkSpacePageState();
}

class _WorkSpacePageState extends State<WorkSpacePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckVersion.checkAndPush(context);
  }

  @override
  void dispose() {
    super.dispose();

    myBloc.timer?.cancel();
  }

  final myBloc = getIt.get<WorkSpaceCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkSpaceCubit, WorkSpaceState>(
      bloc: myBloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(title: 'Workspace'),
          body: Container(
            padding: const EdgeInsets.symmetric(
              vertical: sp24,
              horizontal: sp16,
            ),
            height: heightDevice(context),
            width: widthDevice(context),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: InkWell(
                      //onTap: () => context.navPush(const AccountInfoRoute()),
                      onTap: () => context.router.push(const ProfileRoute()),
                      child: const SizedBox(
                        width: sp48,
                        height: sp48,
                        child: BaseCacheImage(
                          url: PrefKeys.avatarDefault,
                        ),
                      ),
                    ),
                    title: Text(
                      '${AppSharedPreference.instance.getValue(PrefKeys.userFullName)}',
                      style: p5.copyWith(
                        color: blackColor,
                      ),
                    ),
                    subtitle: Text(
                      'Chủ doanh nghiệp',
                      style: p7.copyWith(color: greyColor),
                    ),
                    trailing: InkWell(
                      onTap: _logoutHandle,
                      child: const Icon(
                        Icons.logout_rounded,
                        size: sp20,
                        color: borderColor_4,
                      ),
                    ),
                  ),
                ),
                gapHeight(sp16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Bạn đang sở hữu',
                          style: p5.copyWith(color: blackColor),
                          children: [
                            TextSpan(
                              text: ' ${state.companies.length} ',
                              style: h6.copyWith(color: mainColor),
                            ),
                            TextSpan(
                              text: 'Workspace',
                              style: p5.copyWith(color: blackColor),
                            ),
                          ],
                        ),
                      ),
                      gapHeight(sp24),
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          title: 'Thêm Workspace',
                          event: () => context.router.push(
                            CreateCompanyRoute(
                              onSuccess: () => myBloc.getListCompanies(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gapHeight(sp16),
                state.isLoading
                    ? const Center(
                        child: BaseLoading(),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final address =
                                '${state.companies[index].address?.title.validator}, ${state.companies[index].address?.ward?.name.validator}, ${state.companies[index].address?.district?.name.validator}, ${state.companies[index].address?.province?.name.validator}';
                            final company = state.companies[index];
                            return InkWell(
                              onTap: () {
                                getIt.get<ShoppingCartBloc>().clear();
                                Future.wait([
                                  AppSharedPreference.instance.setValue(
                                    PrefKeys.companyCode,
                                    company.code,
                                  ),
                                  AppSharedPreference.instance.setValue(
                                    PrefKeys.company,
                                    company.id,
                                  ),
                                  AppSharedPreference.instance.setValue(
                                    PrefKeys.companyName,
                                    company.name,
                                  ),
                                  AppSharedPreference.instance.setValue(
                                    PrefKeys.addressCompany,
                                    address,
                                  ),
                                ]).then(
                                  (value) => context.router.replaceAll([
                                    const HomeRoute(),
                                  ]),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(sp16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(sp12),
                                  color: whiteColor,
                                  border: Border(
                                    left: BorderSide(
                                      width: sp2,
                                      color: company.type == TypeCompany.clinic
                                          ? mainColor
                                          : blue_1,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: blackColor.withOpacity(0.1),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: SizedBox(
                                    height: sp48,
                                    width: sp48,
                                    child: Image.asset(
                                      '${AssetsPath.image}/${company.type == TypeCompany.clinic ? 'img_clinic' : 'img_shop'}.png',
                                    ),
                                  ),
                                  title: Text(
                                    company.name ?? '',
                                    style: p5.copyWith(
                                      color: blackColor,
                                    ),
                                  ),
                                  subtitle: Container(
                                    margin: const EdgeInsets.only(top: sp6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mã: ${company.code}',
                                          style: p6.copyWith(
                                            color: greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: sp20,
                                    color: blackColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => gapHeight(sp16),
                          itemCount: state.companies.length,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logoutHandle() async {
    await DialogUtils.showLogoutDialog(
      context: context,
    );
  }
}
