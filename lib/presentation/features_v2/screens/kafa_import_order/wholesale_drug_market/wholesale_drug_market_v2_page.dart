import 'dart:core';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_banner_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_fliter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_market_v2_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/wholesale_drug_market/widget/drug_banner_widget.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/wholesale_drug_market/widget/drug_categogy_product.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_drug_prod.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_prod.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../di/di.dart';
import '../components/shopping_cart_btn.dart';

@RoutePage()
class WholesaleDrugMarketV2Page extends StatefulWidget {
  const WholesaleDrugMarketV2Page({super.key});

  @override
  State<WholesaleDrugMarketV2Page> createState() =>
      _WholesaleDrugMarketV2PageState();
}

class _WholesaleDrugMarketV2PageState extends State<WholesaleDrugMarketV2Page>
    with SingleTickerProviderStateMixin {
  final promotionPrdBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final promotionDailyPrdBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final bestSellerPrdBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final justForYouPrdBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final wholeSaleDrugBloc = getIt<WholesaleDrugMarketV2Bloc>();
  final bannerBloc = getIt<WholesaleDrugBannerBloc>();
  final cartBloc = getIt<DrugCartBloc>();
  final filterBloc = getIt<WholesaleDrugFilterBloc>();

  late ScrollController scroll;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    scroll = ScrollController();
    tabController = TabController(length: 5, vsync: this);
    cartBloc
      ..getCart()
      ..getVouchers();
    bannerBloc.getBanners();
    wholeSaleDrugBloc.getList();
    filterBloc.getDrugFilter();
    justForYouPrdBloc.setType(value: DrugPrdV2Type.propose);
    bestSellerPrdBloc.setType(value: DrugPrdV2Type.bestSeller);
    promotionPrdBloc.setType(value: DrugPrdV2Type.promotion);
    promotionDailyPrdBloc.setType(value: DrugPrdV2Type.price);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    scroll.dispose();
  }

  void _srollToTop() {
    if (scroll.offset > 0) {
      scroll.animateTo(
        0,
        duration: 500.milliseconds,
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void init() {
    bannerBloc.getBanners();
    wholeSaleDrugBloc.getList();
    justForYouPrdBloc.getList();
    bestSellerPrdBloc.getList();
    promotionPrdBloc.getList();
    promotionDailyPrdBloc.getList();
    filterBloc.getDrugFilter();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => filterBloc,
        ),
        BlocProvider(
          create: (context) => wholeSaleDrugBloc,
        ),
        BlocProvider(
          create: (context) => justForYouPrdBloc,
        ),
        BlocProvider(
          create: (context) => bestSellerPrdBloc,
        ),
        BlocProvider(
          create: (context) => promotionPrdBloc,
        ),
        BlocProvider(
          create: (context) => promotionDailyPrdBloc,
        ),
        BlocProvider(
          create: (context) => bannerBloc,
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: ColorApp.greyF5,
          appBar: BaseAppBar(
            title: 'Chợ thuốc sỉ',
            actions: [
              ShoppingCartBtn(
                onTap: () async {
                  final result =
                      await context.router.push(const DrugCartRoute());
                  if (result == true) {
                    init();
                  }
                },
              ),
              16.width,
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                onTap: (value) {
                  wholeSaleDrugBloc.setType(
                    value: wholeSaleDrugBloc.listTab[value],
                  );
                  _srollToTop();
                },
                isScrollable: true,
                controller: tabController,
                labelPadding: 12.padingVer + 16.padingHor,
                unselectedLabelStyle: s14w400.copyWith(color: AppColors.grey80),
                labelStyle: s14w400.copyWith(color: AppColors.grey80),
                indicatorColor: AppColors.brand,
                tabs: List.generate(
                  wholeSaleDrugBloc.listTab.length,
                  (index) {
                    final tab = wholeSaleDrugBloc.listTab[index];
                    return Row(
                      children: [
                        Text(
                          tab.title,
                          style: s14w400,
                        ),
                        if (tab.icon != null)
                          FaIcon(iconCode: tab.icon!).padding(8.padingLeft),
                      ],
                    );
                  },
                ),
              ),
              BlocBuilder<WholesaleDrugMarketV2Bloc, CubitState>(
                bloc: wholeSaleDrugBloc,
                builder: (context, state) {
                  print('===BaseLoading');
                  return Visibility(
                    visible: state.status == BlocStatus.loading,
                    child: const BaseLoadingV2(),
                  );
                },
              ),
              BlocBuilder<WholesaleDrugMarketV2Bloc, CubitState>(
                bloc: wholeSaleDrugBloc,
                builder: (context, state) {
                  return SearchFilterCustom(
                    inputTap: _srollToTop,
                    backgroundColor: AppColors.white,
                    hintText: 'Tìm kiếm sản phẩm',
                    onChange: (value) {
                      wholeSaleDrugBloc.changeSearch(value);
                    },
                    // controller: search,
                    prefix: InkWell(
                      onTap: _handleQr,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: 1.pading.copyWith(right: 0),
                            child: Container(
                              decoration: const BoxDecoration(
                                // color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(999),
                                  bottomLeft: Radius.circular(999),
                                ),
                              ),
                              height: 48,
                              width: 48,
                              alignment: Alignment.center,
                              child: FaIcon(
                                iconCode: 'f465',
                                type: FaIconType.solid,
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            color: AppColors.input_borderDefault,
                            thickness: 1,
                            width: 0,
                          ).size(height: 48),
                          8.width,
                          const Icon(
                            Icons.search,
                            color: AppColors.input_iconDefault,
                          ),
                          4.width,
                        ],
                      ),
                    ),
                    isActive: wholeSaleDrugBloc.category != null ||
                        wholeSaleDrugBloc.brand != null ||
                        wholeSaleDrugBloc.group != null,
                    // bloc.isSort,
                    onTap: () {
                      context.bottomSheet(
                        BtsFilterDrugProd(
                          bloc: filterBloc,
                          category: wholeSaleDrugBloc.category,
                          brand: wholeSaleDrugBloc.brand,
                          group: wholeSaleDrugBloc.group,
                          price: wholeSaleDrugBloc.price,
                          onChange: (category, brand, group, price) {
                            wholeSaleDrugBloc.changeFilter(
                              category: category,
                              brand: brand,
                              group: group,
                              price: price,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ).padding(16.pading),
              RefreshIndicator(
                onRefresh: () async => init(),
                child: SingleChildScrollView(
                  controller: scroll,
                  child: Column(
                    children: [
                      BlocBuilder<WholesaleDrugMarketV2Bloc, CubitState>(
                        bloc: wholeSaleDrugBloc,
                        builder: (context, state) {
                          return Visibility(
                            visible: wholeSaleDrugBloc.showBanner,
                            child: BannerDrugWidget(
                              bloc: bannerBloc,
                            ),
                          );
                        },
                      ),
                      DrugCategoryProduct(
                        bloc: wholeSaleDrugBloc,
                        isShowCate: false,
                        cartBloc: cartBloc,
                        reload: () => init(),
                      ),
                      DrugCategoryProduct(
                        bloc: justForYouPrdBloc,
                        icon: 'f46b',
                        title: 'Dành riêng cho bạn',
                        cartBloc: cartBloc,
                        reload: () => init(),
                      ),
                      DrugCategoryProduct(
                        icon: 'f7e4',
                        bloc: bestSellerPrdBloc,
                        title: 'Chương trình khuyến mãi',
                        cartBloc: cartBloc,
                        reload: () => init(),
                      ),
                      DrugCategoryProduct(
                        icon: 'f7e4',
                        bloc: promotionPrdBloc,
                        title: 'Khuyến mãi hằng ngày',
                        cartBloc: cartBloc,
                        reload: () => init(),
                      ),
                    ],
                  ),
                ),
              ).expanded(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleQr() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );
  }
}
