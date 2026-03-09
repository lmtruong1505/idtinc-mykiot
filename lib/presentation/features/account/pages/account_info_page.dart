import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/account/cubit/account_cubit.dart';
import 'package:pharmago/presentation/features/account/cubit/account_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../base/map_entry.dart';
import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';

@RoutePage()
class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final myBloc = getIt.get<AccountCubit>();

  bool? _biometrics =
      AppSharedPreference.instance.getValue(PrefKeys.biometrics) as bool?;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Thông tin cá nhân',
        actions: [
          // const Icon(Icons.edit_outlined),
          InkWell(
            onTap: () async {
              await context.router.push(const AccountInfoEditRoute());
              // await myBloc.getDetail(context, widget.id);
              // myBloc.entityILC.onRefresh();
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 8, 5, 8),
              child: const Icon(Icons.edit_outlined, size: 25, color: bg_1),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 48,
            child: MenuEntry.buildSelection(_getMenus()),
          ),
        ],
      ),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(
          vertical: sp24,
          horizontal: sp16,
        ),
        child: BlocProvider<AccountCubit>(
          create: (context) => myBloc..getDetail(),
          child: BlocBuilder<AccountCubit, AccountState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: sp80,
                        height: sp80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(sp40),
                          child: const BaseCacheImage(
                            url: PrefKeys.avatarDefault,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  gapHeight(sp16),
                  Text(
                    state.account?.fullName ?? 'Chưa có thông tin',
                    style: h4.copyWith(color: blackColor),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    state.account?.phone ?? 'Chưa có thông tin',
                    style: p5.copyWith(color: greyColor),
                    textAlign: TextAlign.center,
                  ),
                  gapHeight(sp16),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: greyColor.withOpacity(0.01),
                          blurRadius: sp2,
                          offset: const Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: supportButton(
                      title: 'Đăng xuất',
                      event: _logoutHandle,
                      largeButton: false,
                      icon: const Icon(
                        Icons.login_rounded,
                        color: mainColor,
                        size: sp20,
                      ),
                      color: mainColor,
                      backgroundColor: accentColor_5,
                    ),
                  ),
                  gapHeight(sp28),
                  _buildMenu(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  MenuEntry _getMenus() => MenuEntry(
        labelWidget: const Icon(Icons.more_vert_rounded, color: blackColor),
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: 'Đổi mật khẩu',
            onPressed: () => context.router.push(
              const ChangePassRoute(),
            ),
          ),
          MenuEntry(
            label: 'Vô hiệu hoá tài khoản',
            onPressed: () => myBloc.inactive(context),
            titleColor: red_1,
          ),
        ],
      );

  Future<void> _logoutHandle() async {
    final shared = AppSharedPreference.instance;
    final username = shared.getValue(PrefKeys.username);
    final fullName = shared.getValue(PrefKeys.userFullName);
    final rememberPass = shared.getValue(PrefKeys.rememberPassword) as bool?;
    final pass = shared.getValue(PrefKeys.password) as String?;
    await shared.clear();
    if (_biometrics ?? false) {
      await shared.setValue(PrefKeys.username, username);
      await shared.setValue(PrefKeys.userFullName, fullName);
      await shared.setValue(PrefKeys.biometrics, _biometrics);
      await shared.setValue(PrefKeys.password, pass);
    }
    if (rememberPass ?? false) {
      await shared.setValue(PrefKeys.username, username);
      await shared.setValue(PrefKeys.userFullName, fullName);
      await shared.setValue(PrefKeys.rememberPassword, rememberPass);
      await shared.setValue(PrefKeys.password, pass);
    }
    context.router.replaceAll([const WelcomeRoute()]);
  }

  Widget _buildMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BẢO MẬT ỨNG DỤNG',
          style: h7.copyWith(color: greyColor),
        ),
        gapHeight(sp16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp8),
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.1),
                blurRadius: sp4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp16,
                  horizontal: sp16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: mainColor,
                    ),
                    gapWidth(sp16),
                    Text(
                      'Đổi mật khẩu',
                      style: p5.copyWith(color: mainColor),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp16,
                  horizontal: sp16,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      '${AssetsPath.image}/login/img_face_id.png',
                      width: sp24,
                      color: mainColor,
                    ),
                    gapWidth(sp16),
                    Text(
                      'Đăng nhập face Id/vân tay',
                      style: p5.copyWith(color: mainColor),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      value: _biometrics ?? false,
                      onChanged: _biometricHandle,
                      thumbColor: whiteColor,
                      activeColor: mainColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _biometricHandle(bool value) async {
    await AppSharedPreference.instance.setValue(PrefKeys.biometrics, value);
    setState(() {
      _biometrics = value;
    });
  }
}
