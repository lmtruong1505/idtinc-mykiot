import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/prd_customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../../shared/style_app/init_style.dart';
import '../../../../models/customer/product_customer_mode.dart';

class TabPrdCustomer extends StatefulWidget {
  final CustomerModel customer;
  const TabPrdCustomer({
    super.key,
    required this.customer,
  });

  @override
  State<TabPrdCustomer> createState() => _TabPrdCustomerState();
}

class _TabPrdCustomerState extends State<TabPrdCustomer>
    with AutomaticKeepAliveClientMixin {
  final bloc = PrdCustomerBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList(widget.customer.id ?? 0);
    scroll.onMore(
      () => bloc.getList(
        widget.customer.id ?? 0,
        isMore: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PrdCustomerBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            bloc.getList(widget.customer.id ?? 0);
          },
          child: LoadListPage(
            state: state,
            height: 200,
            listEmpty: bloc.list.isEmpty,
            child: ListView.separated(
              padding: sp16.pading,
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildPrd(bloc.list[index]),
              separatorBuilder: (context, index) => 16.height,
              itemCount: bloc.list.length,
            ).expanded(),
          ),
        );
      },
    );
  }

  Widget _buildPrd(ProductCustomerModel item) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 8.radius,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: 8.radius,
              border: Border.all(
                color: ColorApp.greyF5,
              ),
            ),
            child: BaseCacheImage(
              url: item.media ?? PrefKeys.imgProductDefault,
              borderRadius: 8.radius,
            ),
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: StyleApp.normal(fontSize: 16),
                  ).expanded(),
                  8.width,
                  Text(
                    item.units?.first.sellPrice.formatPrice(type: 'đ') ?? '0đ',
                    overflow: TextOverflow.ellipsis,
                    style: StyleApp.normal(fontSize: 16, color: ColorApp.main),
                  ),
                ],
              ),
              8.height,
              Text(
                'Đã mua ${item.quantityBuy ?? 0} ${item.units?.first.name ?? ""}',
                overflow: TextOverflow.ellipsis,
                style: StyleApp.medium(
                  fontSize: 16,
                ),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
