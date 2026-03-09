import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/authentication/domain/entities/account_entity.dart';
import 'package:pharmago/presentation/features/home/home_page.dart';
import 'package:pharmago/presentation/features/wallet/bloc/bloc/wallet_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/auth/auth_cubit.dart';
import 'package:pharmago/presentation/features_v2/components/expanded/expandable_v2.dart';
import 'package:pharmago/presentation/features_v2/screens/personal_management/components/qr_dialog.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/local/get_data.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/svg.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../router/router.gr.dart';
import '../../blocs/auth/user_bloc.dart';

@RoutePage()
class PersonalManagementPage extends StatefulWidget {
  const PersonalManagementPage({super.key});

  @override
  State<PersonalManagementPage> createState() => _PersonalManagementPageState();
}

class _PersonalManagementPageState extends State<PersonalManagementPage> {
  final walletBloc = getIt<WalletBloc>();
  final authBloc = AuthCubit();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(title: 'Quản lý cá nhân'),
      backgroundColor: AppColors.bg_primary,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.bg_primary,
        ),
        padding: 16.pading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              ExpandableV2(
                header: 'Thông tin',
                child: Column(
                  children: List.generate(InfoTab.values.length, (index) {
                    final tab = InfoTab.values[index];
                    return _infoTab(tab);
                  }),
                ),
              ),
              const Divider(
                color: AppColors.border_disabled,
              ),
              ExpandableV2(
                header: 'Quản lý',
                child: Column(
                  children: List.generate(ManagementTab.values.length, (index) {
                    final tab = ManagementTab.values[index];
                    return _managementTab(tab);
                  }),
                ),
              ),
              const Divider(
                color: AppColors.border_disabled,
              ),
              ExpandableV2(
                header: 'Tài khoản',
                child: Column(
                  children: List.generate(AccountTab.values.length, (index) {
                    final tab = AccountTab.values[index];
                    return _accountTab(tab);
                  }),
                ),
              ),
              const Divider(
                color: AppColors.border_disabled,
              ),
              Column(
                children: List.generate(AdditionalTab.values.length, (index) {
                  final tab = AdditionalTab.values[index];
                  return _additionalTab(tab);
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: WalletFloatingButton(walletBloc: walletBloc),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserBloc, AccountEntity>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.bg_secondary,
                boxShadow: AppShadows.elevator0,
                shape: BoxShape.circle,
              ),
              child: BaseCacheImage(
                url: userAvatar,
                borderRadius: 40.radius,
                errorWidget: const Icon(
                  CupertinoIcons.person,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.fullName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.headingLg,
                ),
                4.height,
                Text(
                  '#${state.code ?? ''}',
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
              ],
            ).padding(12.padingHor).expanded(),
          ],
        );
      },
    );
  }

  InkWell _infoTab(InfoTab tab) {
    return InkWell(
      onTap: () {
        late PageRouteInfo route;
        switch (tab) {
          case InfoTab.personalInfo:
            route = const ProfileRoute();
            break;
          case InfoTab.myQr:
            context.dialog(
              QrDiaLog(code: userCode.validator),
            );
            break;
          case InfoTab.myHealthRecord:
            route = UnderDevelopmentRoute(title: 'Hồ sơ sức khỏe');
            break;
        }
        context.pushRoute(route);
      },
      child: _itemView(tab.title, tab.prefix, tab.suffix),
    );
  }

  InkWell _managementTab(ManagementTab tab) {
    return InkWell(
      onTap: () {
        late PageRouteInfo route;
        switch (tab) {
          case ManagementTab.appointment:
            route = UnderDevelopmentRoute(title: 'Lịch hẹn');
            break;
          case ManagementTab.purchaseHistory:
            route = UnderDevelopmentRoute(title: 'Lịch sử mua hàng');
            break;
        }
        context.pushRoute(route);
      },
      child: _itemView(tab.title, tab.prefix, tab.suffix),
    );
  }

  InkWell _accountTab(AccountTab tab) {
    return InkWell(
      onTap: () {
        late PageRouteInfo route;
        switch (tab) {
          case AccountTab.changePassword:
            route = const ProfileChangePasswordRoute();
            break;
          case AccountTab.zaloOa:
            route = UnderDevelopmentRoute(title: 'Hồ sơ sức khỏe');
            break;
        }
        context.pushRoute(route);
      },
      child: _itemView(tab.title, tab.prefix, tab.suffix),
    );
  }

  InkWell _additionalTab(AdditionalTab tab) {
    return InkWell(
      onTap: () {
        switch (tab) {
          case AdditionalTab.intro:
            context.pushRoute(UnderDevelopmentRoute(title: 'Giới thiệu'));
            break;
          case AdditionalTab.logout:
            _logoutHandle();
            break;
          case AdditionalTab.deleteAccount:
            _deleteAccount();
            break;
        }
      },
      child: _itemView(tab.title, tab.prefix, tab.suffix),
    );
  }

  Container _itemView(String title, String prefix, String suffix) {
    return Container(
      padding: 8.padingHor + 12.padingVer,
      child: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: prefix.isNotEmpty ? IcSvg.asset(prefix) : null,
          ),
          12.width,
          Text(
            title,
            style: AppStyle.bodyMdMedium.copyWith(
              color: AppColors.text_secondary,
            ),
          ).expanded(),
          12.width,
          SizedBox(
            height: 16,
            width: 16,
            child: suffix.isNotEmpty ? IcSvg.asset(suffix) : null,
          ),
        ],
      ),
    );
  }

  Future<void> _logoutHandle() async {
    await DialogUtils.showLogoutDialog(
      context: context,
    );
  }

  void _deleteAccount() async {
    await DialogUtils.showWarningDialog(
      context,
      content:
          'Sau khi xoá, tài khoản của bạn sẽ không thể khôi phục lại và mọi thông tin dữ liệu của bạn sẽ bị xoá khỏi hệ thống của chúng tôi. Bạn có chắc chắn muốn xoá tài khoản của mình?',
      accept: () {
        context.pop();
        authBloc.deleteAccount(context);
      },
      titleConfirm: 'Xoá tài khoản',
      titleClose: 'Huỷ',
      close: () => context.pop(),
    );
  }
}

enum InfoTab {
  personalInfo('Thông tin cá nhân', '/menu_v2/ic_info.svg', ''),
  myQr('Mã QR của tôi', '/menu_v2/ic_my_qr.svg', ''),
  myHealthRecord('Hồ sơ sức khỏe', '/menu_v2/ic_my_record.svg', '');

  final String title;
  final String prefix;
  final String suffix;

  const InfoTab(this.title, this.prefix, this.suffix);
}

enum ManagementTab {
  appointment('Lịch hẹn', '/menu_v2/ic_appointment.svg', ''),
  purchaseHistory(
    'Lịch sử mua hàng',
    '/menu_v2/ic_history_purchase_history.svg',
    '',
  );

  final String title;
  final String prefix;
  final String suffix;

  const ManagementTab(this.title, this.prefix, this.suffix);
}

enum AccountTab {
  changePassword('Đổi mật khẩu', '/menu_v2/ic_change_password.svg', ''),
  zaloOa('Tài khoản Zalo OA', '/menu_v2/ic_zalo_oa.svg', '');

  final String title;
  final String prefix;
  final String suffix;

  const AccountTab(this.title, this.prefix, this.suffix);
}

enum AdditionalTab {
  intro('Giới thiệu', '', ''),
  logout('Đăng xuất', '', '/menu_v2/ic_logout.svg'),
  deleteAccount('Xoá tài khoản', '', '/menu_v2/ic_delete_user.svg.svg');

  final String title;
  final String prefix;
  final String suffix;

  const AdditionalTab(this.title, this.prefix, this.suffix);
}
