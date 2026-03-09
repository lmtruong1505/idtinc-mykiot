import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/filter_prod_bloc.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../base/loading.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/state/cubit_state.dart';

// ignore: must_be_immutable
class BtsFilterProd extends StatefulWidget {
  BtsFilterProd({
    super.key,
    required this.onChange,
    this.active,
    this.category,
    this.brand,
    this.type,
    this.price,
    this.company,
  });

  bool? active;
  int? category;
  int? brand;
  int? type;
  RangePrice? price;
  int? company;
  final Function(
    bool? active,
    int? category,
    int? brand,
    int? type,
    RangePrice? price,
    int? company,
  ) onChange;

  @override
  State<BtsFilterProd> createState() => _BtsFilterProdState();
}

class _BtsFilterProdState extends State<BtsFilterProd> {

  final bloc = FilterProdBloc();

  @override
  void initState() {
    bloc.getFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.onChange(
          null,
          null,
          null,
          null,
          null,
          null,
        );
        context.pop();
      },
      onConfirm: () {
        widget.onChange(
          widget.active,
          widget.category,
          widget.brand,
          widget.type,
          widget.price,
          widget.company,
        );
        context.pop();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilterItem(
              label: 'Trạng thái',
              items: ['Tất cả', 'Đang bán', 'Đã ẩn'],
              select: widget.active == null
                  ? 0
                  : widget.active!
                      ? 1
                      : 2,
              onTap: (index) {
                widget.active = index == 0 ? null : index == 1;
                setState(() {});
              },
            ),
            16.height,
            BlocBuilder<FilterProdBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                if(state.status == BlocStatus.loading) {
                  return const BaseLoading();
                }
                final categories = [
                  const BasicModel(
                    name: 'Tất cả',
                  ),
                  ...bloc.categories,
                ];
                final indexCategory = widget.category == null
                    ? 0
                    : categories.indexWhere((element) => element.id == widget.category);

                final brands = [
                  const BasicModel(
                    name: 'Tất cả',
                  ),
                  ...bloc.brands,
                ];
                final indexBrand = widget.brand == null
                    ? 0
                    : brands.indexWhere((element) => element.id == widget.brand);

                final types = [
                  const BasicModel(
                    name: 'Tất cả',
                  ),
                  ...bloc.types,
                ];
                final indexType = widget.type == null
                    ? 0
                    : types.indexWhere((element) => element.id == widget.type);

                return Column(
                  children: [
                    FilterItem(
                      label: 'Danh mục sản phẩm',
                      select: indexCategory,
                      items: categories.map((e) => e.name ?? '').toList(),
                      onTap: (p0) {
                        widget.category = categories[p0].id;
                        setState(() {});
                      },
                    ),
                    16.height,
                    FilterItem(
                      label: 'Thương hiệu',
                      select: indexBrand,
                      items: brands.map((e) => e.name ?? '').toList(),
                      onTap: (p0) {
                        widget.brand = brands[p0].id;
                        setState(() {});
                      },
                    ),
                    16.height,
                    FilterItem(
                      label: 'Loại sản phẩm',
                      select: indexType,
                      items: types.map((e) => e.name ?? '').toList(),
                      onTap: (p0) {
                        widget.type = types[p0].id;
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            ),
            16.height,
            FilterItem(
              label: 'Đơn giá (VNĐ)',
              items: RangePrice.values.map((e) => e.label).toList(),
              select: RangePrice.values.indexOf(widget.price ?? RangePrice.all),
              onTap: (index) {
                widget.price = RangePrice.values[index];
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum RangePrice {
  all(null, null),
  under50(0, 50000),
  from50to100(50000, 100000),
  from100to200(100000, 200000),
  from200to500(200000, 500000),
  from500to1000(500000, 1000000),
  from1000to2000(1000000, 2000000),
  from2000to5000(2000000, 5000000),
  above5000(5000000, null),
  ;

  const RangePrice(this.minVal, this.maxVal);

  final double? minVal;
  final double? maxVal;
}

extension RangePriceExt on RangePrice {
  String get label {
    if (this == RangePrice.all) return 'Tất cả';
    if (minVal == null) return 'Dưới ${maxVal.formatCurrency}';
    if (maxVal == null) return 'Trên ${minVal.formatCurrency}';
    return '${minVal.formatCurrency} - ${maxVal.formatCurrency}';
  }
}
