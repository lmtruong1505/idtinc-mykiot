import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/check_version/check_vesion.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/authentication/domain/entities/account_entity.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/auth/user_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/tab_btn.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../config/app_style/init_app_style.dart';
import '../../../features_v2/blocs/role_v2/role_per_ws_bloc.dart';
import '../../product/cubit/cubit/banner_cubit.dart';
import '../../product/cubit/cubit/banner_state.dart';
import '../../wallet/bloc/bloc/wallet_bloc.dart';
import '../../wallet/bloc/bloc/wallet_event.dart';
import '../cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../cubit/work_space/work_space_cubit.dart';
import 'components/tab_list/tab_in_worrk.dart';
import 'components/tab_list/tab_workspace.dart';

@RoutePage()
class ListWorkspaceScreen extends StatefulWidget {
  const ListWorkspaceScreen({super.key});

  @override
  State<ListWorkspaceScreen> createState() => _ListWorkspaceScreenState();
}

class _ListWorkspaceScreenState extends State<ListWorkspaceScreen> {
  final bloc = getIt<WorkSpaceCubit>();
  final walletBloc = getIt.get<WalletBloc>();

  @override
  void initState() {
    super.initState();

    log('--- is init: =====');
    getIt.get<AuthWsManagerCubit>().stateChange(isAuth: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.init();
      walletBloc.add(WalletDetailEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();

    walletBloc.add(WalletCloseSocketEvent());
  }

  @override
  Widget build(BuildContext context) {
    return UpdateWidget(
      child: BlocListener<BannerCubit, BannerState>(
        listener: (context, state) {
          if (state.urls.isEmpty) return;
          final url = state.urls.first;
          showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: Material(
                  color: AppColors.white.withOpacity(0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          context.router.push(
                            const WholesaleDrugMarketV2Route(),
                          );
                        },
                        child: Image.network(
                          url,
                          scale: 1.2,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: sp64,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: sp32,
                            height: sp32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp16),
                              border: Border.all(color: whiteColor),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: sp24,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        listenWhen: (previous, current) {
          return previous.urls != current.urls;
        },
        child: BlocListener<RolePermissionWsBloc, CubitState>(
          bloc: getIt<RolePermissionWsBloc>(),
          listener: (context, state) {
            CheckStateBloc.show(
              context,
              state,
              success: () {
                context.router.replaceAll([const HomeRoute()]);
              },
            );
          },
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: AppColors.bg_primary,
              body: Stack(
                children: [
                  Image.asset(Assets.imgsBackgroundWp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      context.padding.top.height,
                      24.height,
                      InkWell(
                        onTap: () {
                          try {
                            walletBloc.add(WalletConnectSocketEvent());
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset(Assets.logo, height: 32),
                          ],
                        ).padding(16.padingHor),
                      ),
                      _infor(),
                      _buildTabBar(),
                      const TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          TabListWorkSpace(),
                          TabInWorkingWorkSpace(),
                        ],
                      ).expanded(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return BlocBuilder<WorkSpaceCubit, WorkSpaceState>(
      bloc: bloc,
      builder: (context, state) {
        return Container(
          height: 37,
          margin: 16.pading,
          decoration: BoxDecoration(
            color: AppColors.bg_secondary,
            borderRadius: 16.radius,
            border: Border.all(
              color: AppColors.border_tertiary,
            ),
          ),
          child: TabBar(
            indicator: BoxDecoration(
              color: AppColors.white,
              borderRadius: 16.radius,
              boxShadow: AppShadows.elevator1,
            ),
            labelStyle: AppStyle.bodyBsMedium.copyWith(height: 1.2),
            labelColor: AppColors.brand,
            unselectedLabelStyle: AppStyle.bodyBsRegular.copyWith(height: 1.2),
            unselectedLabelColor: AppColors.text_tertiary,
            onTap: (value) {
              bloc.changeFilter(
                isOwner: value == 0,
                isWorkingPlace: value == 1,
              );
            },
            tabs: [
              Tab(
                child: TabBtn(
                  label: 'Sở hữu',
                  count: state.count ?? 0,
                  color: state.isOwner ? AppColors.ultility_negative_60 : null,
                ),
              ),
              Tab(
                child: TabBtn(
                  label: 'Nơi làm việc',
                  count: state.countWorking ?? 0,
                  color: state.isWorkingPlace
                      ? AppColors.ultility_negative_60
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infor() {
    return BlocBuilder<UserBloc, AccountEntity>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.pushRoute(const PersonalManagementRoute());
          },
          child: Padding(
            padding: 16.pading,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bg_secondary,
                    boxShadow: AppShadows.elevator0,
                    shape: BoxShape.circle,
                  ),
                  child: BaseCacheImage(
                    url: state.avatar ?? '',
                    borderRadius: 40.radius,
                    errorWidget: const Icon(
                      CupertinoIcons.person,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '#${state.code ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyBsRegular.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                    4.height,
                    Text(
                      state.fullName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.headingLg,
                    ),
                  ],
                ).padding(12.padingHor).expanded(),
                const Icon(
                  Icons.arrow_outward_sharp,
                  color: AppColors.black,
                  size: 15,
                ),
              ],
            ).container(
              radius: 16,
              bgColor: AppColors.white,
              boxShadow: AppShadows.elevator1,
              padding: 16.pading,
            ),
          ),
        );
      },
    );
  }
}
