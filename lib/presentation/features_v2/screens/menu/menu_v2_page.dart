import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/config/role/role_enum.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/company_choose_bloc.dart';
import 'package:pharmago/presentation/features/company/cubit/create_company_cubit/create_company_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../gen/flutter_assets.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../router/router.gr.dart';
import '../../blocs/local/bool_bloc.dart';
import '../../blocs/menu/menu_company_bloc.dart';
import 'data/menu_data.dart';

part './components/choose_workspace.dart';

part './components/build_menu_item.dart';

@RoutePage()
class MenuV2Page extends StatefulWidget {
  const MenuV2Page({super.key});

  @override
  State<MenuV2Page> createState() => _MenuV2PageState();
}

class _MenuV2PageState extends State<MenuV2Page>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ChooseWorkspace(),
              BlocBuilder<MenuCompanyBloc, CubitState>(
                builder: (context, state) {
                  return ListView.separated(
                    padding: 24.padingVer,
                    itemBuilder: (context, index) => _BuildMenuItem(
                      item: menuData[index],
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.border_tertiary,
                      height: 16,
                    ),
                    itemCount: menuData.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get branchList => isAdmin && checkPermission(PerBranchEnum.LIST.code);
  bool get isPharmacist =>
      checkRole(RoleBaseEnum.PHARMACIST) && lengthRole == 1;

  List<Map<String, List<MenuModel>>> get menuData => [
        {
          'Quản lý nghiệp vụ': [
            if (companyType != TypeCompany.drugstore.code
                // && !isPharmacist
                //  &&
                // checkPermission(PerAppointmentEnum.LIST.code)
                )
              if (showAppointment)
                MenuModel(
                  title: 'Lịch hẹn',
                  leading: FaIcon(iconCode: 'f133'),
                  // routePage: const BookCalendarRoute(),
                  routePage: const ListEventRoute(),
                ),
            // MenuModel(
            //   title: 'Phiếu khám',
            //   leading: FaIcon(iconCode: 'f570'),
            //   routePage: const PhieuKhamRoute(),
            // ),
            if (isOwnerWsCsMn)
              MenuModel(
                title: 'Vai trò',
                leading: FaIcon(iconCode: 'f0c0'),
                routePage: const RoleManagerV2Route(),
              ),
          ],
        },
        {
          'Quản lý chung': [
            if (!isWorkspace)
              MenuModel(
                title: 'Thông tin cơ sở',
                leading: FaIcon(iconCode: 'f0c0'),
                routePage: DetailBranchV2Route(id: null),
              ),
            MenuModel(
              title: 'Workspace',
              leading: FaIcon(iconCode: 'f0b1'),
              routePage: const ListWorkspaceRoute(),
            ),
            if (isWorkspace && branchList)
              MenuModel(
                title: 'Cơ sở',
                leading: FaIcon(iconCode: 'f54f'),
                routePage: const ListBranchV2Route(),
              ),
            if (isWorkspace)
              MenuModel(
                title: 'Nhân viên',
                leading: FaIcon(iconCode: 'f007'),
                routePage: const EmpManagementRoute(),
              ),
            MenuModel(
              title: 'Sản phẩm',
              leading: FaIcon(iconCode: 'f1b2'),
              routePage: ProductManagerV2Route(),
            ),
            if (isWorkspace)
              MenuModel(
                title: 'Khách hàng',
                leading: FaIcon(iconCode: 'f0c0'),
                routePage: CustomerV2Route(),
              ),
            if (companyType != TypeCompany.drugstore.code &&
                checkPermission(
                  PerServiceEnum.LIST.code,
                ))
              MenuModel(
                title: 'Dịch vụ',
                leading: FaIcon(iconCode: 'f15b'),
                routePage: const ServiceV2Route(),
              ),
            MenuModel(
                title: 'Tích điểm và quà tặng',
                leading: FaIcon(iconCode: 'f145'),
                routePage: const SettingPointRoute(),
              ),
          ],
        },
        if (isWorkspace)
          {
            'Quản lý kho': [
              MenuModel(
                title: 'Kho',
                leading: FaIcon(iconCode: 'f494'),
                routePage: const WarehouseListRouteV2(),
              ),
              MenuModel(
                title: 'Lô hàng',
                leading: FaIcon(iconCode: 'f49e'),
                routePage: const ShipmentListRoute(),
              ),
              MenuModel(
                title: 'Phiếu nhập',
                leading: FaIcon(iconCode: 'e0fa'),
                routePage: ManagerWarehouseImportRoute(id: 0),
              ),
              MenuModel(
                title: 'Phiếu xuất',
                leading: FaIcon(iconCode: 'e0fb'),
                routePage: const ReceiptExportListRoute(),
              ),
            ],
          },
        if (isAdmin)
          {
            'Chợ thuốc sỉ': [
              MenuModel(
                title: 'Chợ thuốc sỉ',
                leading: FaIcon(iconCode: 'f54e'),
                routePage: const WholesaleDrugMarketV2Route(),
              ),
              if (isWorkspace)
                MenuModel(
                  title: 'Đơn nhập hàng',
                  leading: FaIcon(iconCode: 'f48b'),
                  routePage: const ListImportOrderRoute(),
                ),
            ],
          },
      ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
