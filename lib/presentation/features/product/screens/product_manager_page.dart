import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../constants/typography.dart';

enum TabProductManagerPage {
  product('Danh sách sản phẩm', IcSvg.iconProduct),
  service('Danh sách dịch vụ', IcSvg.iconService),
  price('Bảng giá', IcSvg.iconPrice),
  brand('Thương hiệu', IcSvg.brand),
  category('Danh mục sản phẩm', IcSvg.category),
  productStandard('Tiêu chuẩn sản xuất', IcSvg.iconProductStandard),
  prepare('Bào chế', IcSvg.iconPrepare),
  productCompany('Công ty sản xuất', IcSvg.iconProductCompany),
  registerCompany('Công ty đăng kí', IcSvg.iconRegisterCompany),
  wholesaleMedicine('Thuốc sỉ', IcSvg.wholesaleMedicine);

  final String title;
  final String iconSvg;
  const TabProductManagerPage(this.title, this.iconSvg);
}

@RoutePage()
class ProductManagerPage extends StatefulWidget {
  const ProductManagerPage({super.key});

  @override
  State<ProductManagerPage> createState() => _ProductManagerPageState();
}

class _ProductManagerPageState extends State<ProductManagerPage> {
  final menuTabs = [
    TabProductManagerPage.product,
    TabProductManagerPage.service,
    TabProductManagerPage.price,
    TabProductManagerPage.brand,
    TabProductManagerPage.category,
    TabProductManagerPage.productStandard,
    TabProductManagerPage.prepare,
    TabProductManagerPage.productCompany,
    TabProductManagerPage.registerCompany,
    TabProductManagerPage.wholesaleMedicine,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_5,
      appBar: BaseAppBar(
        title: 'Sản phẩm',
        leading: Container(),
      ),
      body: Container(
        height: heightDevice(context),
        width: widthDevice(context),
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: menuTabs.length,
          itemBuilder: (context, index) {
            final tab = menuTabs[index];
            return InkWell(
              onTap: () => _routeHandle(tab),
              child: Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withOpacity(0.3),
                      offset: const Offset(1, 2),
                      blurRadius: sp4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IcSvg.img(tab.iconSvg, width: sp28),
                    const SizedBox(width: sp16),
                    Text(tab.title, style: p5),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: sp16,
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => gapHeight(sp16),
        ),
      ),
    );
  }

  void _routeHandle(TabProductManagerPage tab) {
    late PageRouteInfo page;
    switch (tab) {
      case TabProductManagerPage.price:
        page = const PriceListRoute();
        break;
      case TabProductManagerPage.service:
        page = const ServiceListRoute();
        break;
      case TabProductManagerPage.brand:
        page = const BrandRoute();
        break;
      case TabProductManagerPage.category:
        page = const CategoryListRoute();
        break;
      case TabProductManagerPage.productStandard:
        page = const ProductStandardListRoute();
        break;
      case TabProductManagerPage.prepare:
        page = const PrepareListRoute();
        break;
      case TabProductManagerPage.productCompany:
        page = const ProductCompanyListRoute();
        break;
      case TabProductManagerPage.registerCompany:
        page = const RegisterCompanyListRoute();
        break;
      case TabProductManagerPage.wholesaleMedicine:
        page = const VariantWmListRoute();
        break;
      default:
        page = const ProductListRoute();
    }
    context.router.push(page);
  }
}
