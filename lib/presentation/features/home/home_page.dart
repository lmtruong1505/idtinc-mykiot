import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/generated/assets.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/home/cubit/nav_home_bloc.dart';
import 'package:pharmago/presentation/features/warehouse/screens/warehourse_list_page.dart';
import 'package:pharmago/presentation/features/warehouse/screens/warehourse_list_page_v2.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/customer_v2/customer_page.dart';
import 'package:pharmago/presentation/features_v2/screens/dashboard/dashboard_page.dart';
import 'package:pharmago/presentation/features_v2/screens/event/list_event_page.dart';
import 'package:pharmago/presentation/features_v2/screens/order/order_manager_v2_page.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/utilities/shake_animation.dart';
import 'package:toastification/toastification.dart';

import '../../../shared/components/button/action_btn.dart';
import '../../constants/colors.dart';
import '../../features_v2/blocs/chat/chat_socket_bloc.dart';
import '../../features_v2/blocs/menu/menu_company_bloc.dart';
import '../../features_v2/screens/menu/menu_v2_page.dart';
import '../../router/router.gr.dart';
import '../../services/notification/notification.dart';
import '../../shared/utils/get.dart';
import '../company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import '../company/cubit/work_space/work_space_cubit.dart';
import '../company/cubit/work_space/work_space_state.dart';
import '../company/screen_v2/components/setup_auth_code.dart';
import '../wallet/bloc/bloc/wallet_bloc.dart';
import '../wallet/bloc/bloc/wallet_state.dart';

part 'components/bottom_bar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // final myBloc = getIt.get<HomeCubit>();
  late TabController _tabController;
  final chatBloc = getIt<ChatSocketBloc>();
  final walletBloc = getIt<WalletBloc>();
  // Future<void> initFirebase() async {
  //   FirebaseMessaging.onBackgroundMessage(
  //     NotiService.instance.firebaseMessagingBackroundHandler,
  //   );
  //   NotiService.instance.firebaseInit(context);
  //   NotiService.instance.initLocalNotification(context);
  //   // await NotiService.getDeviceToken();
  //   await NotiService.instance.messaging.subscribeToTopic(
  //     'COMPANY_$getCompanyCode',
  //   );
  //   print('======COMPANY_getCompanyCode====COMPANY_$getCompanyCode');
  //   await NotiService.instance.messaging.subscribeToTopic('SYSTEM');
  // }

  Future<void> initFirebase() async {
    FirebaseMessageConfig().initNotification(context);
    await FirebaseMessaging.instance.subscribeToTopic(
      'COMPANY_$getCompanyCode',
    );
    print('======COMPANY_getCompanyCode====COMPANY_$getCompanyCode');
    await FirebaseMessaging.instance.subscribeToTopic('SYSTEM');
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: TabCodeNav.values.length, vsync: this);

    initFirebase();

    chatBloc.init();
    context.read<NavHomeBloc>().onChanged(TabCodeNav.home);
    context.read<MenuCompanyBloc>().getCompanyMenu();

    //animation
    _controller = AnimationController(
      vsync: this,
      duration: 500.milliseconds,
    );

    _shakeAnimation = ShakeAnimation.shakeAnimation(_controller);

    _timer = Timer.periodic(5.seconds, (_) {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     chatBloc.init();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();

    FirebaseMessaging.instance.unsubscribeFromTopic('COMPANY_$getCompanyCode');

    // myBloc.disposeSocket();

    //animation
    _timer?.cancel();
    _controller.dispose();
  }

  //add aniamtion
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  Timer? _timer;
  // final page =
  //     isDrugStore == true ? const WarehouseListPageV2() : const ListEventPage();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavHomeBloc, CubitState<TabCodeNav>>(
          listener: (context, state) {
            _tabController.animateTo(
              state.data!.index,
              duration: 300.milliseconds,
            );
          },
        ),
        BlocListener<ListRoleBloc, CubitState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
      ],
      child: BlocListener<WorkSpaceCubit, WorkSpaceState>(
        bloc: getIt.get<WorkSpaceCubit>(),
        listener: (context, state) {
          getIt.get<AuthWsManagerCubit>().stateChange(isAuth: false);
        },
        listenWhen: (previous, current) {
          return previous.companyId != current.companyId;
        },
        child: BlocListener<AuthWsManagerCubit, AuthWsManagerState>(
          bloc: getIt.get<AuthWsManagerCubit>(),
          listener: (context, state) {
            if (state.isAuthen) {
              toastification.show(
                title: const Text('Xác thực thành công'),
                type: ToastificationType.success,
                autoCloseDuration: const Duration(seconds: 3),
              );
            } else {
              toastification.show(
                title: const Text('Đã thoát khỏi phiên xác thực'),
                type: ToastificationType.warning,
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
          listenWhen: (previous, current) {
            return previous.isAuthen != current.isAuthen;
          },
          child: Scaffold(
            backgroundColor: bg_5,
            extendBody: true,
            bottomNavigationBar: const BottomBarHome(),
            resizeToAvoidBottomInset: true,
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const DashboardV2Page(),
                !showAppointment
                    ? const WarehouseListPageV2()
                    : const SizedBox.shrink(),
                showAppointment
                    ? const ListEventPage()
                    : const SizedBox.shrink(),
                const SizedBox(),
                //OrderListPage(),
                const OrderManagerV2Page(),
                const MenuV2Page(),
              ],
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton:
                BlocBuilder<NavHomeBloc, CubitState<TabCodeNav>>(
              builder: (context, state) {
                if (state.data!.index == 0) {
                  return AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: WalletFloatingButton(walletBloc: walletBloc),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class WalletFloatingButton extends StatelessWidget {
  const WalletFloatingButton({
    super.key,
    required this.walletBloc,
  });

  final WalletBloc walletBloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(const WholesaleDrugMarketV2Route()),
      child: BaseContainer(
        borderRadius: 999,
        color: AppColors.green60,
        padding: 8.pading,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ưu đãi tốt',
                      style:
                          s12w700.copyWith(color: AppColors.white, height: 1),
                    ),
                    4.height,
                    Text(
                      'Nhập hàng cùng',
                      style:
                          s10w700.copyWith(color: AppColors.white, height: 1),
                    ),
                  ],
                ),
                4.width,
                ClipRRect(
                  borderRadius: 999.radius,
                  child: Image.asset(
                    Assets.assetsLogo1,
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
            // FaIcon(
            //   iconCode: 'f555',
            //   color: whiteColor,
            // ),
            // BlocBuilder<WalletBloc, WalletState>(
            //   bloc: walletBloc,
            //   builder: (context, state) {
            //     return Text(
            //       walletBloc.wallet?.balance.formatCurrency ?? 'Chưa có ví',
            //       style: p3.copyWith(color: whiteColor),
            //     );
            //   },
            // ).padding(const EdgeInsets.only(left: 8, bottom: 2)),
          ],
        ),
      ),
    );
  }
}
