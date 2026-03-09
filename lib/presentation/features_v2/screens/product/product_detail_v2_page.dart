import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model_v2.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/receipt_import_detail_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_shipments_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/presentation/features_v2/screens/product/tab/product_infor_tab.dart';
import 'package:pharmago/presentation/features_v2/screens/product/tab/product_shipments_tab.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../shared/components/dialog/dialog_message.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../base/dialog.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../constants/asset_path.dart';
import '../../../features/warehouse/screens/create_warehouse_receipt_page.dart';
import '../../../router/router.gr.dart';
import '../../blocs/product/params/prod_create_param.dart';
import '../../blocs/product/prod_create_bloc.dart';
import '../../blocs/product/product_detail_bloc.dart';
import '../../blocs/state/check_state.dart';
import 'components/indicator_img.dart';
import 'components/point_exchange_view.dart';
import 'components/popup_product_info.dart';

@RoutePage()
class ProductDetailV2Page extends StatefulWidget {
  const ProductDetailV2Page({
    super.key,
    required this.id,
    required this.onRefresh,
  });

  final int id;
  final VoidCallback onRefresh;

  @override
  State<ProductDetailV2Page> createState() => _ProductDetailV2PageState();
}

class _ProductDetailV2PageState extends State<ProductDetailV2Page>
    with SingleTickerProviderStateMixin {
  final bloc = ProductDetailBloc();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ValueNotifier<int> _current = ValueNotifier<int>(0);
  bool canEdit = isAdmin && checkPermission(PerProductEnum.EDIT.code);
  bool canDelete = isAdmin && checkPermission(PerProductEnum.DELETE.code);
  bool canActive = isAdmin && checkPermission(PerProductEnum.ACTIVE.code);
  bool canInactive = isAdmin && checkPermission(PerProductEnum.ACTIVE.code);
  late TabController _tabController;
  final productShipmentsBloc = ProductShipmentsBloc();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    bloc.init(widget.id);
    productShipmentsBloc.init(widget.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarCustom(
        onBack: () => context.pop(),
        height: 90,
        title: 'Quản lý sản phẩm',
        subTitle: 'Chi tiết sản phẩm',
        actions: [
          if (canDelete || canEdit || canActive || canInactive) _buildPopup(),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const BaseLoading();
          }
          if (state.status == BlocStatus.failure) {
            return const Center(
              child: Text('Error'),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                snap: true,
                floating: true,
                pinned: true,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: _ImageView(),
                ),
                leading: const SizedBox.shrink(),
                // leading: InkWell(
                //   onTap: () {
                //     context.pop();
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.bg_primaryAlpha.withOpacity(0.2),
                //       shape: BoxShape.circle,
                //     ),
                //     margin: 16.padingLeft,
                //     child: const Icon(
                //       Icons.arrow_back_ios_new,
                //       color: AppColors.fg_tertiary,
                //     ),
                //   ),
                // ),
                // actions: [
                //   if (canDelete || canEdit || canActive || canInactive)
                //     _buildPopup(),
                // ],
              ),
              SliverFillRemaining(
                child: _body(),
              ),
            ],
          );
        },
      ),
    );
  }

  Container _buildPopup() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg_primaryAlpha.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      padding: 8.pading,
      margin: 16.padingRight,
      child: PopupProductInfo(
        active: bloc.model?.product?.active ?? false,
        child: const Icon(
          Icons.more_vert,
          color: AppColors.black,
        ),
        onTap: (value) {
          final productV2 = bloc.model?.product;
          final productV3 = productV2?.toProductV3();
          // ProductV3Model(
          //   productName: productV2?.name,
          //   name: productV2?.name,
          //   code: productV2?.code,
          //   images: productV2?.images
          //       ?.map((e) => ImageModelV3(url: e.url))
          //       .toList(),
          //   units: productV2?.unit
          //       .map(
          //         (e) => UnitV3Model(
          //           id: e.id,
          //           name: e.name,
          //           sellPrice: e.sellPrice,
          //           stockChange: e.stockChange,
          //           sellUnit: e.sellUnit,
          //         ),
          //       )
          //       .toList(),
          //   unitSell: UnitV3Model(
          //     id: productV2?.unitSell?.id,
          //     name: productV2?.unitSell?.name,
          //     sellPrice: productV2?.unitSell?.sellPrice,
          //     stockChange: productV2?.unitSell?.stockChange,
          //     sellUnit: productV2?.unitSell?.sellUnit,
          //   ),
          //   // images: productV2.images
          // );
          switch (value) {
            case ProductEvent.nhap_kho:
              context.router
                  .push(
                // WarehouseImportRoute(model: bloc.model!.product!),
                CreateWarehouseReceiptRoute(product: productV3),
              )
                  .then((value) {
                if (value == true) {
                  bloc.init(widget.id);
                  productShipmentsBloc.init(widget.id);
                  widget.onRefresh.call();
                }
              });
              break;
            case ProductEvent.edit:
              if (!canEdit) {
                context.permissionDenied()();
                return;
              }
              context.router
                  .push(
                ProductCreateV2Route(model: bloc.model),
              )
                  .then((value) {
                if (value == true) {
                  bloc.init(widget.id);
                  widget.onRefresh.call();
                }
              });
              break;
            case ProductEvent.inactive:
              if (!canInactive) {
                context.permissionDenied()();
                return;
              }
              _buildDialog(
                context,
                ProductEvent.inactive,
              );
              break;
            case ProductEvent.active:
              if (!canActive) {
                context.permissionDenied()();
                return;
              }
              _buildDialog(
                context,
                ProductEvent.active,
              );
              break;
            case ProductEvent.delete:
              if (!canDelete) {
                context.permissionDenied()();
                return;
              }
              _buildDialog(
                context,
                ProductEvent.delete,
              );
              break;
          }
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          onTap: (value) {},
          padding: EdgeInsets.zero,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Thông tin cơ bản'),
            Tab(text: 'Lô hàng'),
            Tab(text: 'Tích điểm'),
          ],
          isScrollable: true,
          unselectedLabelColor: AppColors.grey60,
          indicatorColor: AppColors.brand,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: s16w500.copyWith(color: AppColors.brand),
        ),
        const Divider(height: 1),
        Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                '${AssetsPath.image}/bg_v4.png',
              ),
            ),
            TabBarView(
              controller: _tabController,
              children: [
                PrdInforTab(
                  bloc: bloc,
                  shipmentBloc: productShipmentsBloc,
                ),
                PrdShipmentWidget(
                  bloc: productShipmentsBloc,
                  prod: bloc.model!,
                ),
                PointExchangeProductView(
                  point: bloc.model?.product?.point,
                  exchangePoint: bloc.model?.product?.exchangePoint,
                  callBack: (point, exchangePoint) {
                    bloc.model?.product?.point = point;
                    bloc.model?.product?.exchangePoint = exchangePoint;
                    DialogUtils.showLoadingDialog(
                      context,
                      'Đang tải...',
                    );
                    final param = ProdCreateParam.fromModel(bloc.model!);
                    ProdCreateBloc()
                        .update(param, bloc.model?.product?.id ?? -1)
                        .then((value) {
                      context.pop();
                      if (value.code == 200) {
                        ToastCustom.show(
                          context,
                          title: 'Thành công',
                          msg: 'Cập nhật sản phẩm thành công',
                          svgIcon: Assets.svgSuccess,
                          color: AppColors.ultility_positive_60,
                          timeClose: 2.seconds,
                        );
                      } else {
                        CheckStateBloc.showSnackBar(
                            context, ' ${value.message}');
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ).flexible(),
      ],
    );
  }

  Widget _ImageView() {
    if (bloc.model?.product?.images?.isEmpty ?? true) {
      return Container(
        height: 375,
        color: AppColors.bg_secondary,
        child: Center(child: FaIcon(iconCode: 'f03e', size: 48)),
      );
    }
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: bloc.model?.product?.images?.length ?? 0,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: context.width,
              child: BaseCacheImage(
                url: bloc.model?.product?.images?[index].url ?? '',
                height: 375,
              ),
            );
          },
          options: CarouselOptions(
            height: 375,
            padEnds: false,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            clipBehavior: Clip.antiAlias,
            onPageChanged: (index, reason) {
              _current.value = index;
            },
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: ValueListenableBuilder(
              valueListenable: _current,
              builder: (context, value, child) => Container(
                padding: 6.pading,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: 9.radius,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return IndicatorImg(
                      isSelected: index == value,
                    ).padding(4.padingRight);
                  },
                  itemCount: bloc.model?.product?.images?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                ).size(height: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildDialog(
    BuildContext context,
    ProductEvent status,
  ) {
    context.dialog(
      DialogConfirm(
        title: status == ProductEvent.inactive
            ? 'Vô hiệu hóa sản phẩm!'
            : status == ProductEvent.active
                ? 'Kích hoạt sản phẩm!'
                : 'Xác nhận xoá sản phẩm',
        content: getContent(status),
        actionConfirmBorder: status != ProductEvent.active,
        colorConfirmBtn: status != ProductEvent.active
            ? AppColors.button_negative_outlined_textDefault
            : AppColors.button_brand_solid_backgroundDefault,
        icon: IconDiaLog(
          color: status == ProductEvent.active
              ? AppColors.fg_positive.withOpacity(0.1)
              : AppColors.fg_negative.withOpacity(0.1),
          icon: FaIcon(
            type: FaIconType.solid,
            iconCode: status == ProductEvent.inactive
                ? 'f023'
                : status == ProductEvent.active
                    ? 'f3c1'
                    : 'f1f8',
            color: status == ProductEvent.active
                ? AppColors.fg_positive
                : AppColors.fg_negative,
            size: 32,
          ),
        ),
        confirm: () {
          context.pop();
          DialogUtils.showLoadingDialog(
            context,
            'Đang tải...',
          );
          if (status == ProductEvent.delete) {
            bloc.delete(widget.id).then((value) {
              context.pop();
              if (value.code == 200) {
                context.pop(result: true);
                ToastCustom.show(
                  context,
                  title: 'Thành công',
                  msg: 'Xoá sản phẩm thành công',
                  svgIcon: Assets.svgSuccess,
                  color: AppColors.ultility_positive_60,
                  timeClose: 2.seconds,
                );
              } else {
                context.dialog(
                  DialogMessage(
                    title: 'Thông báo',
                    content: value.message,
                    isError: true,
                  ),
                );
              }
            });
          }
          if (status == ProductEvent.inactive) {
            bloc.changeStatus(false, widget.id).then((value) {
              context.pop();
              if (value.code == 200) {
                bloc.init(widget.id);
                widget.onRefresh();
                ToastCustom.show(
                  context,
                  title: 'Thành công',
                  msg: 'Vô hiệu hóa sản phẩm thành công',
                  svgIcon: Assets.svgSuccess,
                  color: AppColors.ultility_positive_60,
                  timeClose: 2.seconds,
                );
              } else {
                context.dialog(
                  DialogMessage(
                    title: 'Thông báo',
                    content: value.message,
                    isError: true,
                  ),
                );
              }
            });
          }
          if (status == ProductEvent.active) {
            bloc.changeStatus(true, widget.id).then((value) {
              context.pop();
              if (value.code == 200) {
                bloc.init(widget.id);
                widget.onRefresh();
                ToastCustom.show(
                  context,
                  title: 'Thành công',
                  msg: 'Kích hoạt sản phẩm thành công',
                  svgIcon: Assets.svgSuccess,
                  color: AppColors.ultility_positive_60,
                  timeClose: 2.seconds,
                );
              } else {
                context.dialog(
                  DialogMessage(
                    title: 'Thông báo',
                    content: value.message,
                    isError: true,
                  ),
                );
              }
            });
          }
        },
      ),
    );
  }

  Widget getContent(ProductEvent event) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: event == ProductEvent.delete
            ? 'Bạn có chắc chắn muốn xóa sản phẩm '
            : event == ProductEvent.inactive
                ? 'Bạn có chắc chắn muốn vô hiệu hóa sản phẩm '
                : 'Bạn có chắc chắn muốn kích hoạt sản phẩm  ',
        style: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.text_secondary,
        ),
        children: [
          TextSpan(
            text: bloc.model?.product?.name.validator,
            style: AppStyle.bodyBsSemiBold.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          TextSpan(
            text: ' không?',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
        ],
      ),
    );
  }
}
