import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/filter_prod_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/check_state.dart';
import 'package:pharmago/presentation/features_v2/screens/product/tab/basic_info_tab.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/button/label_button.dart';
import '../../../../shared/components/toast/toast_custom.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/bg/bg_btn_nav_bar.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../../shared/components/widgets/icon_custom.dart';
import '../../../base/dialog.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/product/config_ingredient_bloc.dart';
import '../../blocs/product/config_sell_bloc.dart';
import '../../blocs/product/params/prod_create_param.dart';
import '../../blocs/product/prod_create_bloc.dart';
import '../../models/product/product_detail_v2_model.dart';
import 'components/point_exchange_view.dart';
import 'tab/extra_tab.dart';
import 'tab/image_tab.dart';
import 'tab/ingredient_tab.dart';
import 'tab/warehouse_tab.dart';

@RoutePage()
class ProductCreateV2Page extends StatefulWidget {
  const ProductCreateV2Page({super.key, this.model, this.barcode});

  final ProductDetailV2Model? model;
  final String? barcode;

  @override
  State<ProductCreateV2Page> createState() => _ProductCreateV2PageState();
}

class _ProductCreateV2PageState extends State<ProductCreateV2Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final scrollTab = ScrollController();

  ProdCreateParam param = ProdCreateParam(
    product: ProductParam(active: true),
    warehouse: WarehouseParam(),
  );
  final bloc = ProdCreateBloc();
  final ingredientBloc = ConfigIngredientBloc();
  final unitBloc = ConfigSellBloc();
  final key = GlobalKey<FormState>();
  final categoryBlc = FilterProdBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: tabTitle.length);
    param.product?.barcode = widget.barcode;

    if (widget.model != null) {
      param = ProdCreateParam.fromModel(widget.model!);
      print('param: ${param.product?.toJson()}');
      ingredientBloc.list = param.ingredients;
      unitBloc.vat = param.product?.vat ?? 0;
      unitBloc.list = param.unitChanges;
      unitBloc.import_price =
          widget.model?.warehouse.firstOrNull?.importPrice ?? 0;
      int index = 1;
      final images = widget.model?.product?.images
              ?.map(
                (e) => MapEntry<int, XFile>(index++, XFile(e.url ?? '')),
              )
              .toList() ??
          [];
      bloc.images = images;
    }
    categoryBlc.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: widget.model != null ? '' : 'Tạo mới sản phẩm',
        back: () => context.pop(result: true),
        leadingText: 'Trở về',
      ),
      bottomNavigationBar: BgBtnNavBar(
        child: Row(
          children: [
            if (widget.model != null)
              LabelButton(
                onPressed: () {
                  context.pop();
                },
                backgroundColor: AppColors
                    .button_neutral_alpha_backgroundDefault
                    .withOpacity(0.05),
                labelStyle: AppStyle.bodySmMedium.copyWith(
                  color: AppColors.button_neutral_alpha_textDefault,
                ),
                label: 'Hủy bỏ',
                fixedSize: const Size(double.infinity, 40),
              ).expanded(),
            if (widget.model != null) 12.width,
            LabelButton(
              onPressed: () {
                if (!key.currentState!.validate()) {
                  return;
                }
                param.ingredients = ingredientBloc.list;
                param.unitChanges = unitBloc.list;
                if (widget.model != null) {
                  for (final item in unitBloc.listDelete) {
                    param.unitChanges.add(item);
                  }
                }
                param.product?.vat = unitBloc.vat;
                param.updateTonKho();
                param.warehouse?.importPrice = unitBloc.import_price;
                widget.model != null ? _handleUpdate() : _handleCreate();
              },
              label: widget.model != null ? 'Lưu lại' : 'Tạo sản phẩm',
              fixedSize: const Size(double.infinity, 40),
            ).expanded(),
          ],
        ),
      ),
      body: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.height,
            Row(
              children: [
                IconCustom(
                  icon: FaIcon(
                    iconCode: 'f1b2',
                    type: FaIconType.solid,
                    color: AppColors.bg_primary,
                  ),
                  color: AppColors.ultility_positive_60,
                ),
                const Spacer(),
                LabelButton(
                  onPressed: () {
                    context.router
                        .push(KafaCloneProductRoute(isClonePrd: true))
                        .then((value) {
                      if (value == true) {
                        bloc.isCloneSuccess = true;
                      }
                    });
                  },
                  label: 'Thêm nhanh',
                  backgroundColor:
                      AppColors.button_neutral_alpha_backgroundDefault,
                  labelStyle: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_neutral_alpha_textDefault,
                      height: 1),
                  spaceIcon: 4,
                  suffixIcon: const Icon(
                    Icons.add,
                    color: AppColors.button_neutral_alpha_textDefault,
                    size: 20,
                  ),
                ),
                16.width,
              ],
            ),
            Text(
              widget.model != null ? 'Chỉnh sửa sản phẩm' : 'Tạo mới sản phẩm',
              textAlign: TextAlign.left,
              style: AppStyle.heading2xl,
            ).padding(16.padingHor),
            24.height,
            _buildTab(),
            TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BasicInfoTab(
                  categoryBlc: categoryBlc,
                  param: param,
                  unitBloc: unitBloc,
                  validate: () => key.currentState!.validate(),
                ),
                ImageTab(
                  bloc: bloc,
                ),
                WarehouseTab(
                  param: param,
                  bloc: unitBloc,
                ),
                PointExchangeProductView(
                  exchangePoint: param.product?.exchangePoint,
                  point: param.product?.point,
                  callBack: (point, exchangePoint) {
                    param.product?.exchangePoint = exchangePoint;
                    param.product?.point = point;
                    _handleUpdate();
                  },
                ),
                IngredientTab(
                  bloc: ingredientBloc,
                ),
                ExtraTab(
                  param: param,
                ),
              ],
            ).expanded(),
          ],
        ),
      ),
    );
  }

  final List<String> tabTitle = [
    'Thông tin cơ bản',
    'Ảnh sản phẩm',
    'Thông tin kho',
    'Tích điểm',
    'Thành phần',
    'Thông tin bổ sung',
  ];

  _buildTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: 16.padingHor,
      controller: scrollTab,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.text_primary,
        labelStyle: AppStyle.bodyBsMedium,
        unselectedLabelColor: AppColors.text_tertiary,
        unselectedLabelStyle: AppStyle.bodyBsRegular,
        indicator: BoxDecoration(
          borderRadius: 50.radius,
          color: AppColors.bg_primary,
          boxShadow: AppShadows.elevator0,
        ),
        onTap: (value) {
          final maxPixel = scrollTab.position.maxScrollExtent;
          final pixel = maxPixel / tabTitle.length;
          if (value == tabTitle.length - 1) {
            scrollTab.animateTo(
              maxPixel,
              duration: 300.milliseconds,
              curve: Curves.linear,
            );
          } else {
            scrollTab.animateTo(
              pixel * value,
              duration: 300.milliseconds,
              curve: Curves.linear,
            );
          }
        },
        tabs: List.generate(
          tabTitle.length,
          (index) => Tab(
            height: 37,
            text: tabTitle[index],
          ),
        ),
      ).container(
        padding: EdgeInsets.zero,
        bgColor: AppColors.bg_secondary,
        radius: 50,
        border: Border.all(
          color: AppColors.border_tertiary,
        ),
      ),
    );
  }

  void _handleCreate() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tải...',
    );
    bloc.create(param).then((value) {
      context.pop();
      if (value.code == 200) {
        ToastCustom.show(
          context,
          title: 'Thành công',
          msg: 'Tạo sản phẩm thành công',
          svgIcon: Assets.svgSuccess,
          color: AppColors.ultility_positive_60,
          timeClose: 2.seconds,
          route: value.data is int
              ? ProductDetailV2Route(
                  id: value.data ?? -1,
                  onRefresh: () {},
                )
              : null,
        );
        bloc.isCloneSuccess = true;
        context.pop(result: true);
      } else {
        CheckStateBloc.showSnackBar(context, ' ${value.message}');
      }
    });
  }

  void _handleUpdate() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tải...',
    );
    bloc.update(param, widget.model?.product?.id ?? -1).then((value) {
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
        context.pop(result: true);
      } else {
        CheckStateBloc.showSnackBar(context, ' ${value.message}');
      }
    });
  }
}
