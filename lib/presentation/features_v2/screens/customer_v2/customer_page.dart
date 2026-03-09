import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/shared/components/widgets/title_add.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/customer_v2/components/bts_filter.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../base/empty_container.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../../../shared/constants/enums/status_order.dart';
import '../../blocs/customer/v2/list_customer_bloc.dart';
import '../../blocs/enum/enum_bloc.dart';
import 'components/item_customer.dart';

@RoutePage()
class CustomerV2Page extends StatefulWidget {
  const CustomerV2Page({
    super.key,
    this.isDebt,
  });

  final bool? isDebt;

  @override
  State<CustomerV2Page> createState() => _CustomerV2PageState();
}

class _CustomerV2PageState extends State<CustomerV2Page>
    with AutomaticKeepAliveClientMixin {
  final _bloc = getIt<ListCustomerV2Bloc>();
  final scroll = ScrollController();

  create() {
    context.pushRoute(CreateCustomerV2Route());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.setFilter(
      isDebt: IsDebtEnum.values.firstWhereOrNull(
        (e) {
          return e.data == widget.isDebt;
        },
      ),
    );
    _bloc.init();
    scroll.onMore(() => _bloc.getList(isMore: true));
  }

  @override
  void dispose() {
    _bloc.setFilter(
      isDebt: IsDebtEnum.all,
      isZaloVal: false,
      rangePriceVal: RangePriceV2Enum.all,
      typeOrderVal: TypeOrderV2Enum.all,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBarPage(
        title: 'Quản lý khách hàng',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _bloc.getList();
        },
        child: BlocBuilder<ListCustomerV2Bloc, CubitState>(
          bloc: _bloc,
          builder: (context, state) {
            return LoadMoreListBloc(
              state: state,
              list: _bloc.list,
              isEmptyAll: state.isFirst,
              controller: scroll,
              itemBuilder: (context, item, index) => ItemCustomerV2(item: item),
              separatorBuilder: DividerCustom(),
              emptyViewAll: _buildEmpty(),
              headerView: _buildHeader(),
              emptyView: EmptyContainer(
                icon: FaIcon(
                  iconCode: 'f0c0',
                  type: FaIconType.solid,
                ),
              ),
              height: 300,
              sizePage: _bloc.limit,
              spaceBottom: context.padding.bottom,
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchFilterCustom(
          hintText: 'Tìm kiếm tên, SĐT khách hàng',
          onConfirm: (p0) => _bloc.search = p0,
          isActive: _bloc.isFilter,
          onTap: () {
            context.bottomSheet(
              BtsFilterCustomer(
                isZalo: _bloc.isZalo,
                rangePrice: _bloc.rangePrice,
                typeOrder: _bloc.typeOrder,
                isDebt: _bloc.isDebt,
                onChanged: (isZalo, rangePrice, typeOrder, isDebt) {
                  _bloc.setFilter(
                    isZaloVal: isZalo,
                    rangePriceVal: rangePrice,
                    typeOrderVal: typeOrder,
                    isDebt: isDebt,
                  );
                },
              ),
            );
          },
        ),
        24.height,
        TitleAdd(
          labelButton: 'Thêm khách hàng',
          onPressed: create,
        ),
        DividerCustom(),
      ],
    );
  }

  Widget _buildEmpty() {
    return EmptyComfirm(
      labelBtn: 'Thêm khách hàng',
      text: 'Chưa có khách hàng',
      suffixIcon: const Icon(
        Icons.add,
        color: AppColors.bg_primary,
      ),
      icon: FaIcon(
        iconCode: 'f0c0',
        type: FaIconType.solid,
        size: 32,
      ),
      onPressed: create,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
