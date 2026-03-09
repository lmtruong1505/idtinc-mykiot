import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/button.dart';
import '../../../../base/row_item.dart';
import '../../../../base/svg.dart';
import '../../../../di/di.dart';
import '../../../../features/wholesale_medicine/domain/entities/promotion_detail_wm_entity.dart';
import '../../../../shared/utils/event.dart';
import '../../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../../blocs/state/init_state.dart';
import '../components/variant_order_card.dart';

@RoutePage()
class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final myBloc = getIt.get<ShoppingCartBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Giỏ hàng',
      ),
      backgroundColor: ColorApp.greyF5,
      body: Container(
        padding: 16.pading.copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearch(),
              16.height,
              InkWell(
                onTap: () {
                  myBloc.removeAll();
                },
                child: Text(
                  'Xoá tất cả',
                  style: StyleApp.bold(color: ColorApp.black),
                  textAlign: TextAlign.right,
                ),
              ),
              8.height,
              BlocBuilder<ShoppingCartBloc, CubitState>(
                bloc: myBloc,
                builder: (context, state) {
                  if (state.status == BlocStatus.loading) {
                    return const Center(
                      child: BaseLoading(),
                    ).size(height: 200);
                  }
                  final myList = myBloc.list
                      .where((e) => e.title!.contains(myBloc.search))
                      .toList();
                  if (myList.isEmpty) {
                    return const Center(child: EmptyContainer());
                  }
                  return Column(
                    children: List.generate(myList.length, (index) {
                      return Column(
                        children: [
                          Dismissible(
                            key: Key(myList[index].id.toString()),
                            onDismissed: (direction) {
                              myBloc.delete(myList[index].id ?? -1);
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: 16.radius,
                                color: ColorApp.red,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: ColorApp.white,
                                  ),
                                  16.width,
                                ],
                              ),
                            ),
                            child: VariantOrderCard(
                              variant: myList[index],
                              changeIsReady: (value) {
                                myBloc.changeIsReadyForOrder(index, value);
                              },
                            ),
                          ),
                          8.height,
                        ],
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildSearch() {
    return AppInputSupport(
      hintText: 'Tìm theo tên sản phẩm',
      prefixIcon: const Icon(
        Icons.search_outlined,
      ),
      backgroundColor: ColorApp.white,
      radius: 999,
      onChanged: myBloc.setSearch,
    );
  }

  _buildBottomBar() {
    return BlocBuilder<ShoppingCartBloc, CubitState>(
      bloc: myBloc,
      builder: (context, state) {
        return Container(
          padding: 16.pading.copyWith(bottom: 32),
          decoration: const BoxDecoration(color: ColorApp.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  if (state.data == null) {
                    return;
                  }
                },
                child: Row(
                  children: [
                    IcSvg.asset('/ic_badge_per.svg')
                        .size(height: 16, width: 16),
                    8.width,
                    Text(
                      'Khuyến mãi đơn hàng',
                      style: StyleApp.bold(color: ColorApp.yellowD2),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if(myBloc.total == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chưa đủ giá trị đơn hàng để áp dụng khuyến mãi'),
                              backgroundColor: ColorApp.main,
                            ),
                          );
                          return;
                        }
                        context.router.push(
                          PromotionSelectRoute(
                            typePromotion: TypePromotion.orderTotal,
                            value: myBloc.total.toInt(),
                            listPromoInit: myBloc
                                .promotionDetailEntityForTotalOrder,
                            onConfirm: (value) {
                              if (value == null) return;
                              myBloc.confirmPromoForVariant(
                                value: value,
                                typePromotion:
                                TypePromotion.orderTotal,
                              );
                            },
                            totalPriceBuy: myBloc.total.toInt(),
                          ),
                        );
                      },
                      child: BlocBuilder<ShoppingCartBloc, CubitState>(
                        bloc: myBloc,
                        builder: (context, state) {
                          return Text(
                            myBloc.promotionDetailEntityForTotalOrder.isEmpty ? 'Áp dụng KM đơn hàng'
                                : 'Đang áp dụng ${myBloc
                                .promotionDetailEntityForTotalOrder.length} KM',
                            style: StyleApp.bold(
                              color: myBloc.list.isNotEmpty
                                  ? ColorApp.main
                                  : ColorApp.grey79,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              RowItem(
                title: 'Số lượng',
                content: myBloc.list
                    .where((e) => e.isReadyForOrder)
                    .toList()
                    .length
                    .toString(),
              ),
              4.height,
              RowItem(
                title: 'Tổng tiền',
                content: '${FormatCurrency(
                  myBloc.total - myBloc.totalPriceDiscount,
                )} đ',
                contetnStyle: StyleApp.bold(color: ColorApp.main),
              ),
              16.height,
              Row(
                children: [
                  BaseCheckbox(
                    value: myBloc.selectAll,
                    onChanged: myBloc.setSelectAll,
                  ),
                  8.width,
                  Text(
                    'Chọn tất cả',
                    style: StyleApp.semibold(
                      color: ColorApp.grey79,
                    ),
                  ).expanded(),
                  ExtraButton(
                    title: 'Mua ngay',
                    borderRadius: 999,
                    borderColor: null,
                    event: () {
                      context.router.push(const ConfirmKafaOrderRoute());
                    },
                    backgroundColor: myBloc.list.isEmpty
                        ? ColorApp.black.withOpacity(0.05)
                        : ColorApp.main,
                    titleColor: myBloc.list.isEmpty
                        ? ColorApp.black.withOpacity(0.15)
                        : ColorApp.white,
                    largeButton: false,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
