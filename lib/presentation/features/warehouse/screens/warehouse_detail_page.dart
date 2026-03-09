import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_detail_cubit/warehouse_detail_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_detail_cubit/warehouse_detail_state.dart';
import 'package:pharmago/presentation/features/warehouse/screens/create_warehouse_receipt_page.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../base/two_button_box.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../features_v2/models/employee/user_data_model.dart';
import '../../company/screen_v2/components/menu_popup.dart';
import '../domain/entities/warehouse_entity.dart';

@RoutePage()
class WarehouseDetailPage extends StatefulWidget {
  const WarehouseDetailPage({
    super.key,
    required this.warehouse,
  });

  final int warehouse;

  @override
  State<WarehouseDetailPage> createState() => _WarehouseDetailPageState();
}

class _WarehouseDetailPageState extends State<WarehouseDetailPage> {
  final myBloc = getIt.get<WarehouseDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..init(widget.warehouse),
      child: BlocBuilder<WarehouseDetailCubit, WarehouseDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_5,
            appBar: AppBarCustom(
              onBack: () => context.pop(),
              height: 90,
              title: 'Quản lý kho',
              subTitle: 'Chi tiết kho',
              actions: [
                _buildMenu(),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(sp16),
              height: heightDevice(context),
              width: widthDevice(context),
              child: _bodyView,
            ),
            bottomNavigationBar: TwoButtonBox(
              mainTitle: 'Tạo phiếu nhập',
              extraTitle: 'Tạo phiếu xuất',
              mainOnTap: () {
                context.router.push(
                  ReceiptImportCreateRoute(),
                );
              },
              extraOnTap: () {
                context.router.push(
                  ReceiptExportCreateRoute(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget get _bodyView {
    return BlocSelector<WarehouseDetailCubit, WarehouseDetailState,
        WarehouseEntity?>(
      selector: (state) {
        return state.warehouseEntity;
      },
      builder: (context, warehouse) {
        if (warehouse == null) return const SizedBox.shrink();
        return Column(
          children: [
            Text(
              warehouse.title,
              style: s20w700.copyWith(
                color: AppColors.text_primary,
              ),
              textAlign: TextAlign.center,
            ),
            sp12.height,
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Mã kho',
                        style: s12w500.copyWith(
                          color: AppColors.green70,
                        ),
                      ),
                      sp4.height,
                      Text(
                        warehouse.code,
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: sp48,
                  width: 0.5,
                  color: AppColors.border_primary,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Loại kho',
                        style: s12w500.copyWith(
                          color: AppColors.green70,
                        ),
                      ),
                      sp4.height,
                      Text(
                        warehouse.typeWarehouseData?['title'],
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: sp48,
                  width: 0.5,
                  color: AppColors.border_primary,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Diện tích kho',
                        style: s12w500.copyWith(
                          color: AppColors.green70,
                        ),
                      ),
                      sp4.height,
                      Text(
                        '${warehouse.settings['area']}m2',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            sp12.height,
            _employeeView,
          ],
        );
      },
    );
  }

  Widget get _employeeView {
    return BlocSelector<WarehouseDetailCubit, WarehouseDetailState,
        WarehouseEntity?>(
      selector: (state) {
        return state.warehouseEntity;
      },
      builder: (context, warehouse) {
        final isActive = warehouse?.isActive == true;
        return Container(
          padding: const EdgeInsets.all(sp12),
          decoration: BoxDecoration(
            color: AppColors.bg_white,
            borderRadius: BorderRadius.circular(sp12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp2,
                    horizontal: sp8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border_primary),
                    borderRadius: BorderRadius.circular(sp12),
                    color: AppColors.bg_white,
                    boxShadow: const [
                      BoxShadow(
                        color: black5o,
                        blurRadius: sp2,
                        spreadRadius: sp2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    isActive ? 'Đang hoạt động' : 'Ngưng hoạt động',
                    style: s12w500.copyWith(
                      color: isActive ? AppColors.green50 : AppColors.red50,
                    ),
                  ),
                ),
              ),
              sp12.height,
              Text(
                'Quản lý kho',
                style: s14w500.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              _employeeItemView(warehouse?.userManageData),
              sp12.height,
              Text(
                'Nhân viên kho (${warehouse?.warehouseStaffData.length ?? 0})',
                style: s14w500.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              sp4.height,
              ...(warehouse?.warehouseStaffData ?? []).map((e) {
                return _employeeItemView(e);
              }),
              sp16.height,
              _extraInfoView,
            ],
          ),
        );
      },
    );
  }

  Widget _employeeItemView(UserDataModel? userManageData) {
    return Container(
      margin: const EdgeInsets.only(top: sp8),
      padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: bg_4,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(sp0),
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        minTileHeight: 0,
        leading: const Icon(
          Icons.person_outline,
          color: AppColors.icon_iconPrimary,
          size: sp20,
        ),
        title: Text(
          userManageData?.fullName ?? '',
          style: s12w400.copyWith(
            color: AppColors.text_primary,
          ),
        ),
        subtitle: Text(
          userManageData?.phoneNumber ?? '',
          style: s12w400.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
      ),
    );
  }

  Widget get _extraInfoView {
    return BlocSelector<WarehouseDetailCubit, WarehouseDetailState,
        WarehouseEntity?>(
      selector: (state) {
        return state.warehouseEntity;
      },
      builder: (context, warehouse) {
        return Column(
          children: [
            RowItem(
              title: 'Người tạo:',
              content: warehouse?.userCreatedData?.fullName ?? '',
            ),
            sp8.height,
            RowItem(
              title: 'Thời gian tạo:',
              content:
                  warehouse?.createdAt.fomatDate2(fomat: 'hh:mm - dd/MM/y') ??
                      '',
            ),
            sp8.height,
            RowItem(
              title: 'Người cập nhật',
              content: warehouse?.userUpdatedData?.fullName ?? '-',
            ),
            sp8.height,
            RowItem(
              title: 'Thời gian tạo:',
              content:
                  warehouse?.updatedAt.fomatDate2(fomat: 'hh:mm - dd/MM/y') ??
                      '-',
            ),
          ],
        );
      },
    );
  }

  Widget get _listView {
    return BlocBuilder<WarehouseDetailCubit, WarehouseDetailState>(
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final item = state.productWarehouse?[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item?.name ?? ''),
                12.height,
                SizedBox(
                  width: widthDevice(context),
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final e = item?.productWarehouse[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor_2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            FaIcon(iconCode: 'f46b'),
                            4.width,
                            Text(e?.amount.formatCurrency ?? ''),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => 12.width,
                    itemCount: item?.productWarehouse.length ?? 0,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => 16.height,
          itemCount: state.productWarehouse?.length ?? 0,
        );
      },
    );
  }

  Widget _buildMenu() {
    return MenuPopupWorkSpace(
      onTap: (value) {
        if (value == StatusMenuWorkspace.edit) {
          context.router
              .push(
            WarehouseCreateRoute(warehouse: myBloc.state.warehouseEntity),
          )
              .then((value) {
            myBloc.init(widget.warehouse);
          });
        }
      },
      isDetail: true,
      isStatus: false,
      isDelete: false,
      child: IconBtn(
        backgroundColor: AppColors.bg_primary,
        icon: const Icon(
          Icons.more_vert,
          size: 15,
        ),
      ),
    );
  }
}
