import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';

import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/empty_container.dart';
import '../../../base/infinite_list.dart';
import '../../../base/loading.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../router/router.gr.dart';
import '../../../shared/constants/enums/status_order.dart';
import '../cubit/list_wm_cubit/list_wm_cubit.dart';
import '../cubit/list_wm_cubit/list_wm_state.dart';
import '../domain/entities/order_wm_entity.dart';
import '../widgets/bts_chose_kind_create_order.dart';
import '../widgets/order_wm_preview_card.dart';

@RoutePage()
class ListWholesaleMadicinePage extends StatefulWidget {
  const ListWholesaleMadicinePage({super.key});

  @override
  State<ListWholesaleMadicinePage> createState() =>
      _ListWholesaleMadicinePageState();
}

class _ListWholesaleMadicinePageState extends State<ListWholesaleMadicinePage> {
  final _cubit = getIt.get<ListWmCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListWmCubit>(
      create: (context) => _cubit
        ..isOnlineChange(true)
        ..init(),
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: const BaseAppBar(
          title: 'Danh sách đơn bán hàng',
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16)
              .copyWith(bottom: 0),
          height: heightDevice(context),
          width: widthDevice(context),
          child: BlocBuilder<ListWmCubit, ListWmState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  _cubit.getCountOderFilter();
                  _cubit.infiniteListController.onRefresh();
                },
                child: SingleChildScrollView(
                  controller: context.read<ListWmCubit>().scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          title: 'Tạo mới đơn bán hàng',
                          event: () => showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sp12),
                              ),
                            ),
                            context: context,
                            builder: (context) =>
                                const BtsChoseKindCreateOrder(),
                          ),
                          largeButton: true,
                          icon: null,
                        ),
                      ),
                      const SizedBox(height: sp24),
                      AppInputSupport(
                        hintText: 'Tìm kiếm mã đơn',
                        backgroundColor: whiteColor,
                        radius: sp12,
                        prefixIcon: const Icon(
                          Icons.search,
                          size: sp20,
                          color: blackColor,
                        ),
                        onChanged: (value) =>
                            context.read<ListWmCubit>().searchKeyChange(value),
                      ),
                      const SizedBox(height: sp24),
                      BlocBuilder<ListWmCubit, ListWmState>(
                        builder: (context, state) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 36,
                              maxHeight: 36,
                              maxWidth: widthDevice(context),
                              minWidth: widthDevice(context),
                            ),
                            // width: widthDevice(context),
                            // height: 40,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: sp16),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              // physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => _cubit.selectFilterButton(
                                    state.listFilter[index],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: sp8,
                                      horizontal: sp12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(sp8),
                                      color: state.listFilter[index] ==
                                              state.selectFilter
                                          ? mainColor
                                          : whiteColor,
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            state.listFilter[index].label,
                                            style: p5.copyWith(
                                              color: state.listFilter[index] ==
                                                      state.selectFilter
                                                  ? whiteColor
                                                  : greyColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: sp4,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: sp4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(sp8),
                                              color: state.listFilter[index] ==
                                                      state.selectFilter
                                                  ? whiteColor
                                                  : accentColor_4,
                                            ),
                                            child: Text(
                                              state.orderCountFilter
                                                  .firstWhere(
                                                    (e) =>
                                                        e.type ==
                                                        (state.listFilter[index]
                                                                    .value
                                                                as StatusOrder)
                                                            .code,
                                                  )
                                                  .count
                                                  .toString(),
                                              style: p8.copyWith(
                                                color: mainColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: state.listFilter.length,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: sp24),
                      InfiniteList<OrderWmDetailEntity>(
                        pageSize: state.limit,
                        shrinkWrap: true,
                        getData: (page) {
                          // if (page == 0) {
                          //   _cubit.infiniteListController.itemList = [];
                          // }
                          return _cubit.getListOrder(page + 1);
                        },
                        itemBuilder: (context, item, index) {
                          return InkWell(
                            onTap: () => context.router.push(
                              OrderWmDetailRoute(
                                order: item.id,
                                // typeOrder: item.typeOrder ?? TypeOrder.cHTH,
                                // isDrafOrder: item.status.id ==
                                //     PrefKeys.idOrderDrafStatus,
                                // onDispose: () {
                                //   _cubit.getCountOderFilter();
                                //   _cubit.infiniteListController.onRefresh();
                                // },
                              ),
                            ),
                            child: OrderWmPreviewCard(item: item),
                          );
                        },
                        scrollController: _cubit.scrollController,
                        infiniteListController: _cubit.infiniteListController,
                        circularProgressIndicator: const BaseLoading(),
                        noItemFoundWidget: const EmptyContainer(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
