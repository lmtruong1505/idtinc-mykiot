import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';

class MenuModel {
  String title;
  Widget leading;
  PageRouteInfo routePage;
  MenuModel({
    required this.title,
    required this.leading,
    required this.routePage,
  });
}

List<Map<String, List<MenuModel>>> menuData = [
  {
    'Quản lý nghiệp vụ': [
      MenuModel(
        title: 'Lịch hẹn',
        leading: FaIcon(iconCode: 'f133'),
        //routePage: const BookCalendarRoute(),
        routePage: const ListEventRoute(),
      ),
      // MenuModel(
      //   title: 'Phiếu khám',
      //   leading: FaIcon(iconCode: 'f570'),
      //   routePage: const PhieuKhamV2Route(),
      // ),
      MenuModel(
        title: 'Vai trò',
        leading: FaIcon(iconCode: 'f0c0'),
        routePage: const RoleManagerV2Route(),
      ),
    ],
  },
  {
    'Quản lý chung': [
      MenuModel(
        title: 'Workspace',
        leading: FaIcon(iconCode: 'f0b1'),
        routePage: const ListWorkspaceRoute(),
      ),
      MenuModel(
        title: 'Cơ sở',
        leading: FaIcon(iconCode: 'f54f'),
        routePage: const ListBranchV2Route(),
      ),
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
      MenuModel(
        title: 'Kho',
        leading: FaIcon(iconCode: 'f494'),
        routePage: const WarehouseListRouteV2(),
      ),
      MenuModel(
        title: 'Dịch vụ',
        leading: FaIcon(iconCode: 'f15b'),
        routePage: const ServiceV2Route(),
      ),
    ],
  },
  {
    'Chợ thuốc sỉ': [
      MenuModel(
        title: 'Chợ thuốc sỉ',
        leading: FaIcon(iconCode: 'f54e'),
        routePage: const WholesaleDrugMarketRoute(),
      ),
      MenuModel(
        title: 'Đơn nhập hàng',
        leading: FaIcon(iconCode: 'f48b'),
        routePage: const ListImportOrderRoute(),
      ),
    ],
  },
];
