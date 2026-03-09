import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/widgets/empty_view.dart';
import '../../../../../../shared/components/widgets/search_filter.dart';
import '../../../../../features_v2/blocs/order_v2/order_manager_bloc.dart';
import '../../../../../features_v2/blocs/state/init_state.dart';
import '../../../../../features_v2/screens/order/components/bts/bts_filter_order.dart';
import '../../../../../features_v2/screens/order/components/item_order.dart';

class TabOrderBranch extends StatefulWidget {
  final int id;
  const TabOrderBranch({super.key, required this.id});

  @override
  State<TabOrderBranch> createState() => _TabOrderBranchState();
}

class _TabOrderBranchState extends State<TabOrderBranch> {
  final myBloc = getIt<OrderManagerBloc>();
  final scroll = ScrollController();
  final textCtrl = TextEditingController();

  @override
  void initState() {
    scroll.onMore(
      () => myBloc.getList(isMore: true),
    );
    myBloc.init(companyID: widget.id);
    super.initState();
  }

  @override
  void dispose() {
    scroll.dispose();
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return EmptySearch(
    //   text: 'Chưa có đơn hàng',
    //   svgAsset: Assets.svgFile,
    // );
    return BlocBuilder<OrderManagerBloc, CubitState>(
      bloc: myBloc,
      builder: (context, state) {
        if (state.status == BlocStatus.loading && state.isFirst) {
          return const BaseLoading();
        }
        if (state.status == BlocStatus.success &&
            state.isFirst &&
            myBloc.list.isEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EmptyComfirm(
                labelBtn: 'Tạo đơn',
                text: 'Chưa có đơn hàng',
                onPressed: null,
                svgAsset: 'assets/icons/ic_cube.svg',
                suffixIcon: const Icon(
                  Icons.add,
                  color: AppColors.button_brand_solid_iconDefault,
                  size: 20,
                ),
              ),
            ],
          );
        }
        return SingleChildScrollView(
          padding: 16.pading,
          controller: scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              if (myBloc.list.isEmpty && state.status == BlocStatus.success)
                const EmptyContainer(),
              if (state.status == BlocStatus.loading &&
                  !state.isFirst &&
                  myBloc.list.isEmpty)
                const BaseLoading(
                  height: 200,
                ),
              if (myBloc.list.isNotEmpty)
                ClipRRect(
                  borderRadius: 12.radius,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextRow2(
                        title: 'Đơn hàng',
                        content: 'Đã thu',
                        titleStyle: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                        contentStyle: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ).container(
                        padding: 6.padingVer + 12.padingHor,
                        bgColor: AppColors.bg_secondary_subtle,
                      ),
                      ListView.separated(
                        padding: 0.pading,
                        itemBuilder: (context, index) => ItemOrderPageV2(
                          isBg: index % 2 != 0,
                          order: myBloc.list[index],
                        ),
                        separatorBuilder: (context, index) => const Divider(
                          height: 0,
                          color: AppColors.border_tertiary,
                        ),
                        itemCount: myBloc.list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                ).container(
                  padding: 0.pading,
                  border: Border.all(color: AppColors.border_tertiary),
                  radius: 12,
                ),
              12.height,
              if (state.status == BlocStatus.loading && myBloc.list.isNotEmpty)
                const BaseLoading(),
              context.padding.bottom.height,
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchFilterCustom(
          hintText: 'Tìm tên, số điện thoại, mã',
          value: myBloc.search,
          onConfirm: myBloc.changeSearch,
          isActive: myBloc.isSort,
          controller: textCtrl,
          clear: () {
            myBloc.changeSearch(null);
            textCtrl.clear();
          },
          onTap: () {
            context.bottomSheet(
              BtsFilterOrder(
                onChange:
                    (type, status, time, price, invoice, synchronizePharma) =>
                        myBloc.changeFilter(
                  type: type,
                  status: status,
                  time: time,
                  price: price,
                ),
                type: myBloc.type,
                status: myBloc.status,
                time: myBloc.time,
                price: myBloc.price,
              ),
            );
          },
        ),
        24.height,
        Text(
          'Tất cả đơn hàng',
          style: AppStyle.headingLg,
        ),
        12.height,
      ],
    );
  }
}
