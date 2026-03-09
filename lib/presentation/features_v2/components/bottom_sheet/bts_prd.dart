import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/filter_button.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../blocs/phieu_kham/list_prd_pk_bloc.dart';

class BtsPrd extends StatefulWidget {
  final int? id;

  const BtsPrd({this.id});

  @override
  State<BtsPrd> createState() => _BtsPrdState();
}

class _BtsPrdState extends State<BtsPrd> {
  final bloc = ListPrdPkBloc();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList();
    scroll.onMore(
      () {
        bloc.getList(isMore: true);
      },
    );
  }

  final filters = [
    const FilterButtonItem('Bán chạy', FilterItemOrder.best_seller),
    const FilterButtonItem('Mới nhất', FilterItemOrder.newest),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      child: BlocBuilder<ListPrdPkBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              8.height,
              Text(
                'Chọn sản phẩm',
                style: StyleApp.semibold(fontSize: 16),
              ),
              16.height,
              DefaultTabController(
                length: 2,
                child: TabBar(
                  indicatorColor: ColorApp.main,
                  labelColor: ColorApp.main,
                  unselectedLabelColor: ColorApp.grey79,
                  onTap: (value) {
                    bloc.changeFilter(
                      filters[value].value,
                    );
                  },
                  tabs: List.generate(
                    filters.length,
                    (index) => Tab(
                      text: filters[index].label,
                    ),
                  ),
                ),
              ),
              LoadListPage(
                state: state,
                height: null,
                listEmpty: bloc.list.isEmpty,
                child: ListView.separated(
                  padding: 16.padingVer,
                  controller: scroll,
                  itemBuilder: (context, index) => _buildPrd(bloc.list[index]),
                  separatorBuilder: (context, index) => sp16.height,
                  itemCount: bloc.list.length,
                ).expanded(),
              ).expanded(),
              RowBtn(
                onCancel: () => context.pop(),
                onConfirm: () {
                  context.pop(
                    result: bloc.product,
                  );
                },
              ).padding(12.padingTop),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrd(VariantEntity variant) {
    bool isChoose = widget.id == variant.id;
    if (bloc.product?.id != null) {
      isChoose = variant.id == bloc.product?.id;
    }

    return InkWell(
      onTap: () {
        bloc.choosePrd(variant);
      },
      child: Row(
        children: [
          BaseCacheImage(
            url: variant.media ?? PrefKeys.imgProductDefault,
            width: 60,
            height: 60,
            borderRadius: 8.radius,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                variant.name ?? '',
                style: StyleApp.semibold(),
              ),
              Text(
                variant.priceSell.formatPrice(type: 'đ'),
                style: StyleApp.semibold(
                  color: ColorApp.main,
                ),
              ),
            ],
          ).expanded(),
          if (isChoose)
            const Icon(
              Icons.check,
              color: ColorApp.main,
            ),
        ],
      ).container(
        radius: 8,
        border: Border.all(
          color: isChoose ? ColorApp.main : ColorApp.greyF2,
        ),
      ),
    );
  }
}
