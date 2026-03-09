import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_fliter_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_prod.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../base/loading.dart';
import '../../../blocs/enum/bloc_status.dart';
import '../../../blocs/state/cubit_state.dart';

// ignore: must_be_immutable
class BtsFilterDrugProd extends StatefulWidget {
  BtsFilterDrugProd({
    super.key,
    required this.onChange,
    this.active,
    this.category,
    this.brand,
    this.group,
    this.price,
    this.company,
    required this.bloc,
  });

  bool? active;
  int? category;
  int? brand;
  int? group;
  RangePrice? price;
  int? company;
  final Function(
    int? category,
    int? brand,
    int? group,
    RangePrice? price,
  ) onChange;
  final WholesaleDrugFilterBloc bloc;

  @override
  State<BtsFilterDrugProd> createState() => _BtsFilterDrugProdState();
}

class _BtsFilterDrugProdState extends State<BtsFilterDrugProd> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        widget.onChange(null, null, null, null);
        context.pop();
      },
      onConfirm: () {
        widget.onChange(
          widget.category,
          widget.brand,
          widget.group,
          widget.price,
        );
        context.pop();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<WholesaleDrugFilterBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                if (state.status == BlocStatus.loading) {
                  return const BaseLoading();
                }
                final categories = [
                  const BasicModel(
                    title: 'Tất cả',
                  ),
                  ...bloc.categories,
                ];
                final indexCategory = widget.category == null
                    ? 0
                    : categories
                        .indexWhere((element) => element.id == widget.category);

                final brands = [
                  const BasicModel(
                    title: 'Tất cả',
                  ),
                  ...bloc.brands,
                ];
                final indexBrand = widget.brand == null
                    ? 0
                    : brands
                        .indexWhere((element) => element.id == widget.brand);

                final groups = [
                  const BasicModel(
                    title: 'Tất cả',
                  ),
                  ...bloc.groups,
                ];
                final indexGroup = widget.group == null
                    ? 0
                    : groups
                        .indexWhere((element) => element.id == widget.group);

                return Column(
                  children: [
                    FilterItem(
                      label: 'Danh mục sản phẩm',
                      select: indexCategory,
                      items: categories.map((e) => e.title ?? '').toList(),
                      onTap: (p0) {
                        widget.category = categories[p0].id;
                        setState(() {});
                      },
                    ),
                    16.height,
                    FilterItem(
                      label: 'Thương hiệu',
                      select: indexBrand,
                      items: brands.map((e) => e.title ?? '').toList(),
                      onTap: (p0) {
                        widget.brand = brands[p0].id;
                        setState(() {});
                      },
                    ),
                    16.height,
                    FilterItem(
                      label: 'Loại sản phẩm',
                      select: indexGroup,
                      items: groups.map((e) => e.title ?? '').toList(),
                      onTap: (p0) {
                        widget.group = groups[p0].id;
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
