import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/create_warehouse_receipt_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/product_ai_model.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features/warehouse/widgets/create_receipt_infor_widget.dart';
import 'package:pharmago/presentation/features/warehouse/widgets/create_receipt_shipment_widget.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/local/index_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../data/models/receipt_import_model.dart';

@RoutePage()
class CreateWarehouseReceiptPage extends StatefulWidget {
  const CreateWarehouseReceiptPage({
    super.key,
    this.product,
    this.listReceiptItem,
    this.receiptDetail,
  });
  final ProductV3Model? product;
  final List<ReceiptImportDetailModel>? listReceiptItem;
  final ReceitExportModel? receiptDetail;

  @override
  State<CreateWarehouseReceiptPage> createState() =>
      _CreateWarehouseReceiptPageState();
}

class _CreateWarehouseReceiptPageState extends State<CreateWarehouseReceiptPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bloc = getIt<CreateWarehouseReceiptCubit>();
  final indexCubit = IndexBloc();
  final inforKey = GlobalKey<FormState>();
  final shipmentKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    bloc
      ..getListWareHouse()
      ..getListUserWareHouse()
      ..addLot(productData: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => bloc
            ..init(
              listReceiptItem: widget.listReceiptItem,
              receiptDetail: widget.receiptDetail,
            ),
        ),
        BlocProvider(create: (context) => indexCubit),
      ],
      child: BlocListener<CreateWarehouseReceiptCubit, CubitState>(
        listener: (context, state) {
          if (state.status == BlocStatus.submitSuccess) {
            DialogUtils.showSuccessDialog(
              context,
              content: 'Bạn đã tạo đơn thành công',
              close: () => context.pop(),
              accept: () => context.pop(),
            );
          } else if (state.status == BlocStatus.submitFailure) {
            DialogUtils.showErrorDialog(
              context,
              content: 'Tạo đơn thất bại \n${state.msg}',
              close: () => context.pop(),
              accept: () => context.pop(),
            );
          } else if (state.status == BlocStatus.loadList) {
            final total = bloc.listImageAI
                .fold(0, (pre, value) => (pre + (value.count ?? 0)));
            context.dialog(
              _scanImageResponseDialog(total),
            );
          }
        },
        child: Scaffold(
          appBar: AppBarCustom(
            onBack: () => context.pop(result: bloc.hasUpdate),
            height: 90,
            title: 'Quản lý phiếu nhập kho',
            subTitle:
                '${widget.receiptDetail != null ? 'Cập nhật' : 'Tạo mới'} phiếu nhập kho',
          ),
          body: Column(
            children: [
              TabBar(
                onTap: (value) {
                  indexCubit.change(value);
                },
                padding: EdgeInsets.zero,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Thông tin cơ bản'),
                  Tab(text: 'Lô hàng'),
                ],
                unselectedLabelColor: AppColors.grey60,
                indicatorColor: AppColors.brand,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: s16w500.copyWith(color: AppColors.brand),
              ),
              BlocBuilder<IndexBloc, int>(
                builder: (context, state) {
                  return IndexedStack(
                    index: state,
                    children: [
                      CreateReceiptInfor(
                        bloc: bloc,
                        inforKey: inforKey,
                      ),
                      CreateReceiptShipmentWidget(
                        bloc: bloc,
                        shipmentKey: shipmentKey,
                      ),
                    ],
                  );
                },
              ).expanded(),
              // TabBarView(
              //   controller: _tabController,
              //   children: [
              //     CreateReceiptInfor(
              //       bloc: createWarehouseReceiptCubit,
              //       inforKey: inforKey,
              //     ),
              //     CreateReceiptShipmentWidget(
              //       bloc: createWarehouseReceiptCubit,
              //       shipmentKey: shipmentKey,
              //     ),
              //   ],
              // ).expanded(),
            ],
          ),
          bottomNavigationBar: BaseBottomBar(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ExtraButton(
                    borderRadius: 999,
                    title: 'Hủy bỏ',
                    event: () => context.pop(),
                    borderColor: borderColor_2,
                    largeButton: true,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                BlocBuilder<IndexBloc, int>(
                  builder: (context, state) {
                    return Expanded(
                      child: MainButton(
                        radius: 999,
                        title: widget.receiptDetail != null
                            ? 'Cập nhật'
                            : 'Xác nhận',
                        event: () {
                          final isInforValid =
                              inforKey.currentState!.validate();
                          final isShipmentValid =
                              shipmentKey.currentState!.validate();
                          if (!isInforValid || !isShipmentValid) {
                            DialogUtils.showWarningDialog(
                              context,
                              close: () => context.pop(),
                              accept: () => context.pop(),
                              content: 'Bạn chưa nhập đủ thông tin',
                            );
                            if (state == 0 && !isInforValid) {
                              return;
                            } else if (state == 1 && !isShipmentValid) {
                              return;
                            }
                            final index = !isInforValid ? 0 : 1;
                            _tabController.animateTo(
                              index,
                              duration: 300.milliseconds,
                            );
                            indexCubit.change(index);
                            return;
                          }
                          bloc.createReceipt(context);
                        },
                        largeButton: true,
                        icon: null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DialogConfirm _scanImageResponseDialog(int total) {
    return DialogConfirm(
      icon: IconDiaLog(
        color: AppColors.brand,
        icon: IcSvg.asset('/noti/icon_noti_success.svg'),
      ),
      title: 'Nhận diện sản phẩm',
      content: Column(
        children: [
          Text.rich(
            TextSpan(
              text: 'Nhận diện thành công',
              style: s14w400,
              children: [
                TextSpan(
                  text: ' $total sản phẩm!',
                  style: s14w700.copyWith(color: AppColors.brand),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final image = bloc.listImageAI[index];
              final isSuccess = image.status == 'OK';
              return _imageStatusItem(index, isSuccess, image);
            },
            separatorBuilder: (context, index) => 16.height,
            itemCount: bloc.listImageAI.length,
          ),
          const Text(
            'Lưu ý: Hệ thống có thể nhận diện sai một số thông tin. Hãy kiểm tra lại kỹ sản phẩm và số lượng trước khi nhập kho.',
            style: s12w400,
          ),
        ],
      ),
      closeLabel: 'Xác nhận',
      isWarning: true,
    );
  }

  Card _imageStatusItem(int index, bool isSuccess, ImageAIStatusModel image) {
    return Card(
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: 9.radius,
                child: Image.file(
                  File(bloc.images[index].path),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: FaIcon(
                    iconCode: isSuccess ? 'f058' : 'f06a',
                    color: isSuccess ? AppColors.brand : AppColors.red60,
                    type: FaIconType.solid,
                    size: 12,
                  ),
                ),
              )
            ],
          ),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ảnh dịch vụ ${(index + 1)}',
                style: s12w500,
              ),
              4.height,
              Text(
                'Nhận diện thành công ${image.count ?? 0} sản phẩm!',
                style: s12w400,
              ),
            ],
          ).expanded(),
        ],
      ).padding(8.pading),
    );
  }
}

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({
    super.key,
    required this.title,
    required this.subTitle,
    required this.height,
    this.onTap,
    this.actions,
    this.onBack,
  });
  final String title;
  final String subTitle;
  final double height;
  final void Function()? onTap;
  final void Function()? onBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(onTap: onBack, child: const Icon(Icons.arrow_back_ios)),
      elevation: 1,
      backgroundColor: AppColors.white,
      iconTheme: const IconThemeData(
        color: AppColors.text_tertiary,
      ),
      centerTitle: false,
      title: Text(
        title,
        style: s14w500.copyWith(color: AppColors.text_tertiary),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 32),
        child: Row(
          children: [
            Text(
              subTitle,
              style: s20w700,
            ),
            const Spacer(),
            if (actions != null) ...actions!,
            // else
            //   GestureDetector(
            //     onTap: onTap,
            //     child: FaIcon(iconCode: 'f142'),
            //   ),
          ],
        ).padding(48.padingLeft + 16.padingRight + 8.padingVer),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
