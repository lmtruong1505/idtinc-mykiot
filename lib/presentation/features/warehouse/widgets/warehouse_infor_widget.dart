import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/row_custom.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/receipt_import_detail_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/screens/manager_warehouse_import_page.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:pharmago/utilities/image_ultilites.dart';

class WarehouseInforWidget extends StatelessWidget {
  const WarehouseInforWidget({
    super.key,
    required this.cubit,
  });

  final ReceiptImportDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptImportDetailCubit, CubitState>(
      bloc: cubit,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              BaseContainer(
                padding: 16.pading,
                child: Column(
                  children: [
                    RowCustom(
                      title: 'Mã phiếu',
                      data: cubit.detail?.code,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Trạng thái phiếu',
                      data: cubit.detail?.statusData?.title,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                      dataStyle: s12w500.copyWith(
                        color: getTextColor(cubit.detail?.statusData?.code),
                      ),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Ngày nhập',
                      data: cubit.detail?.createdAt.fomatCustom(),
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Kho nhập',
                      data: cubit.detail?.warehouseData['title'],
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Giá trị nhập',
                      data: cubit.detail?.totalPrice.formatPrice(type: ' đ'),
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Lý do nhập',
                      data: cubit.detail?.reason,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Nhà cung cấp',
                      data: cubit.detail?.provider,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Người kiểm tra',
                      data: cubit.detail?.userCheck,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ),
                  ],
                ),
              ),
              24.height,
              BaseContainer(
                padding: 16.pading,
                child: Column(
                  children: [
                    RowCustom(
                      title: 'Thời gian tạo',
                      data: cubit.detail?.code,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Người tạo',
                      data: cubit.detail?.userCreatedData?.fullName,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Thời gian cập nhật',
                      data: cubit.detail?.updatedAt.fomatCustom(),
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ).padding(8.padingBottom),
                    RowCustom(
                      title: 'Người cập nhật',
                      data: cubit.detail?.userUpdatedData?.fullName,
                      titleStyle: s12w400.copyWith(color: ColorApp.grey79),
                    ),
                  ],
                ),
              ),
              24.height,
              Container(
                padding: 16.pading,
                color: ColorApp.greyF5,
                child: RowCustom(
                  title: 'Tài liệu đi kèm',
                  data: 'Thao tác',
                  titleStyle: s14w400.copyWith(color: ColorApp.grey79),
                  dataStyle: s14w400.copyWith(color: ColorApp.grey79),
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final file = cubit.detail?.files?[index];
                  return Row(
                    children: [
                      Text(
                        file?.image ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: s14w400.copyWith(
                          color: AppColors.text_tertiary,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                        ),
                      ).expanded(),
                      GestureDetector(
                        onTap: () {
                          ImageUtils.saveImage(file?.image, context);
                        },
                        child: BaseContainer(
                          width: 32,
                          height: 32,
                          borderRadius: 999,
                          child: Center(
                            child: FaIcon(
                              iconCode: 'f019',
                              type: FaIconType.light,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).padding(16.padingHor + 8.padingVer);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: cubit.detail?.files?.length ?? 0,
              ),
            ],
          ),
        );
      },
    ).padding(16.pading);
  }
}
