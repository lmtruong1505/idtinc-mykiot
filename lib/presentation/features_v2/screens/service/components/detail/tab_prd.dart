import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/product/product_v2_model.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/divider_custom.dart';
import '../../../../../../shared/components/widgets/search_filter.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../items/item_prd.dart';

class TabPrdDetailService extends StatefulWidget {
  final List<ProductV2Model> products;
  const TabPrdDetailService({
    super.key,
    required this.products,
  });

  @override
  State<TabPrdDetailService> createState() => _TabPrdDetailServiceState();
}

class _TabPrdDetailServiceState extends State<TabPrdDetailService> {
  List<ProductV2Model> products = [];

  search(String value) {
    setState(() {
      products = widget.products
          .where(
            (product) =>
                product.name!.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchFilterCustom(
            onChange: search,
            hintText: 'Nhập tên sản phẩm',
          ),
          24.height,
          Text(
            'Tất cả',
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.text_tertiary,
            ),
          ),
          6.height,
          DividerCustom(),
          if (products.isEmpty) EmptySearch(text: 'Danh sách rỗng'),
          ListView.separated(
            shrinkWrap: true,
            padding: 0.pading,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ItemPrdService(
              product: products[index],
            ),
            separatorBuilder: (context, index) => DividerCustom(),
            itemCount: products.length,
          ),
          context.padding.bottom.height,
        ],
      ),
    );
  }
}
