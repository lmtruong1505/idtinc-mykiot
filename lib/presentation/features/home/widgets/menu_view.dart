import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/gen/assets.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../router/router.gr.dart';
import '../../account/domain/usecase/account_use_case.dart';

enum MenuTabV2 {
  branch('Quản lý cơ sở', '/menu/ic_list.svg'),
  staff('Quản lý nhân viên', '/menu/ic_list.svg'),
  role('Quản lý vai trò', '/menu/ic_list.svg'),
  product('Quản lý sản phẩm', '/menu/ic_box.svg'),
  service('Quản lý dịch vụ', '/menu/ic_box.svg'),
  calender('Quản lý lịch hẹn', '/menu/ic_list.svg'),
  phieuKham('Quản lý phiếu khám', '/menu/ic_list.svg'),
  //wholesaleMedicine('Thuốc sỉ', '/menu/ic_list.svg'),
  wholesaleMedicineOrder('Quản lý đơn nhập hàng', '/menu/ic_list.svg'),
  wholesaleDrugMarket('Chợ thuốc sỉ', '/menu/ic_list.svg');

  final String title;
  final String iconPath;

  const MenuTabV2(this.title, this.iconPath);
}

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  // final menuTabs = [
  //   MenuTab.inventory,
  //   MenuTab.wholesaleMedicine,
  //   MenuTab.customer,
  //   MenuTab.employee,
  //   // MenuTab.report,
  //   MenuTab.supplier,
  //   MenuTab.debtNote,
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: Padding(
        padding: sp16.padingHor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            context.padding.top.height,
            Row(
              children: [
                Image.asset(
                  Assets.logo,
                  width: 64,
                  height: 64,
                ),
              ],
            ),
            sp32.height,
            _buildAccount(),
            sp16.height,
            ListView.separated(
              padding: sp16.padingVer + context.padding.bottom.padingBottom,
              itemCount: MenuTabV2.values.length,
              separatorBuilder: (context, index) => sp16.height,
              itemBuilder: (context, index) {
                return _itemMenu(MenuTabV2.values[index]);
              },
            ).expanded(),
          ],
        ),
      ),
    );
  }

  InkWell _itemMenu(MenuTabV2 tab) {
    return InkWell(
      onTap: () {
        late PageRouteInfo page;
        switch (tab) {
          case MenuTabV2.staff:
            //page = const EmployeeListRoute();
            //page = const StaffManagerRoute();
            page = const EmpManagementRoute();
            break;
          case MenuTabV2.role:
            //page = const RoleListRoute();
            page = const RoleManagerRoute();
            //page = const RoleManagerV2Route();
            break;
          case MenuTabV2.product:
            page = const ProductListRoute();
            break;
          case MenuTabV2.service:
            page = const ServiceListRoute();
            break;
          case MenuTabV2.calender:
            page = const BookCalendarRoute();
            break;
          case MenuTabV2.branch:
            //page = const BranchManagementRoute();
            page = const ListBranchV2Route();
            break;
          case MenuTabV2.phieuKham:
            page = const PhieuKhamRoute();
            break;
          // case MenuTabV2.wholesaleMedicine:
          //   page = const VariantWmListRoute();
          //   break;
          case MenuTabV2.wholesaleMedicineOrder:
            // page = kDebugMode
            //     ? const ListImportOrderRoute()
            //     : const ListWholesaleMadicineRoute();
            page = const ListImportOrderRoute();
            break;
          case MenuTabV2.wholesaleDrugMarket:
            // page = kDebugMode
            //     ? const WholesaleDrugMarketRoute()
            //     : const VariantWmListRoute();
            page = const WholesaleDrugMarketRoute();
            break;
          default:
            page = EmployeeNavigatorRoute();
        }
        context.router.push(page);
      },
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          borderRadius: sp8.radius,
          color: ColorApp.greyF5,
        ),
        child: Row(
          children: [
            IcSvg.asset(
              tab.iconPath,
              width: 18,
            ),
            const SizedBox(width: sp16),
            Text(
              tab.title,
              style: StyleApp.medium(
                fontSize: 12,
              ),
            ).expanded(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccount() {
    return InkWell(
      //onTap: () => context.router.push(const AccountInfoRoute()),
      onTap: () {
        context.router.push(const ProfileRoute());
      },
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorApp.greyF5,
              border: Border.all(color: ColorApp.greyE2),
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.person_solid,
                color: ColorApp.teal,
              ),
            ),
          ),
          sp8.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${AppSharedPreference.instance.getValue(PrefKeys.userFullName)}',
                  style: p5.copyWith(
                    fontSize: 14,
                    color: blackColor,
                    fontWeight: SEMIBOLD,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                sp4.height,
                Text(
                  'Quản trị tổng',
                  style: p5.copyWith(
                    fontSize: 14,
                    color: ColorApp.grey79,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          sp8.width,
          GestureDetector(
            onTap: () {
              context.router.replaceAll(
                //[const WorkSpaceRoute()],
                [const ListWorkspaceRoute()],
              );
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: sp12.radius,
                color: ColorApp.greyF5,
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14),
                child: const Icon(
                  Icons.login,
                  size: 20,
                ),
              ),
            ),
          ),
          sp8.width,
          GestureDetector(
            onTap: _logoutHandle,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: sp12.radius,
                color: ColorApp.greyF5,
              ),
              child: const Icon(
                Icons.logout,
                size: 20,
              ),
            ),
          ),
          sp8.width,
          GestureDetector(
            onTap: () {
              final useCase = getIt<AccountUseCase>();
              DialogUtils.showErrorDialog(
                context,
                content:
                    'Bạn có chắc chắn vô hiệu hóa tài khoản?\nThao tác này không thể hoàn tác.',
                titleClose: 'Huỷ',
                titleConfirm: 'Xác nhận',
                close: () => Navigator.of(context).pop(),
                accept: () async {
                  Navigator.of(context).pop();
                  DialogUtils.showLoadingDialog(
                    context,
                    'Đang vô hiệu hóa tài khoản vui lòng đợi!',
                  );
                  final res = await useCase.inactive();
                  Navigator.of(context).pop();
                  if (res.code == 200) {
                    await DialogUtils.showSuccessDialog(
                      context,
                      content: 'Vô hiệu hóa tài khoản thành công',
                      barrierDismissible: true,
                    );
                    context.router.replaceAll([const LoginRoute()]);
                  } else {
                    await DialogUtils.showErrorDialog(
                      context,
                      content: 'Vô hiệu hóa tài khoản thất bại',
                    );
                  }
                },
              );
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: sp12.radius,
                color: ColorApp.redC7,
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14),
                child: const Icon(
                  Icons.person_off,
                  size: 20,
                  color: ColorApp.white,
                ),
              ),
            ),
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
}
