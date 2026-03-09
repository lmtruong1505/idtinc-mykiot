import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../data/config/dio_logger.dart';
import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/loading.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/promotion_select_cubit/promotion_select_cubit.dart';
import '../cubit/promotion_select_cubit/promotion_select_state.dart';
import '../domain/entities/promotion_detail_wm_entity.dart';
import '../widgets/promotion_card.dart';

@RoutePage()
class PromotionSelectPage extends StatefulWidget {
  const PromotionSelectPage({
    super.key,
    required this.typePromotion,
    required this.value,
    this.onConfirm,
    this.quantityVariantBuy,
    this.listPromoInit,
    this.totalPriceBuy,
  });

  final TypePromotion typePromotion;
  final int value;
  final int? quantityVariantBuy;
  final Function(List<PromotionDetailEntity>? value)? onConfirm;
  final List<PromotionDetailEntity>? listPromoInit;
  final int? totalPriceBuy;

  @override
  State<PromotionSelectPage> createState() => _PromotionSelectPageState();
}

class _PromotionSelectPageState extends State<PromotionSelectPage> {
  final myBloc = getIt.get<PromotionSelectCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PromotionSelectCubit>(
      create: (context) => myBloc
        ..initData(
          quantityVariantBuy: widget.quantityVariantBuy,
          typePromotion: widget.typePromotion,
          listPromoInit: widget.listPromoInit,
          totalPriceBuy: widget.totalPriceBuy,
        )
        ..getListPromotion(
          widget.typePromotion,
          widget.value,
        ),
      child: Scaffold(
        appBar: const BaseAppBar(title: 'Khuyến mãi đơn hàng'),
        body: Container(
          width: widthDevice(context),
          height: heightDevice(context),
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          child: BlocBuilder<PromotionSelectCubit, PromotionSelectState>(
            builder: (context, state) {
              return state.isLoading
                  ? const BaseLoading()
                  : state.promotions.isEmpty
                      ? const EmptyContainer()
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            final promo = state.promotions[index];
                            return PromosCard(
                              promo: promo,
                              myBloc: myBloc,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: sp16),
                          itemCount: state.promotions.length,
                        );
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          color: whiteColor,
          child: Row(
            children: [
              Expanded(
                child: ExtraButton(
                  title: 'Quay lại',
                  event: () {
                    Navigator.of(context).pop();
                  },
                  largeButton: true,
                  borderColor: borderColor_2,
                  icon: null,
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: MainButton(
                  title: 'Áp dụng',
                  event: () {
                    final list =
                        myBloc.state.promotionDetailSelectedPromo ?? [];
                    final double price = (widget.totalPriceBuy ?? 0).toDouble();
                    double minOrder = 0;
                    bool isLimitOrder = true;

                    for (final PromotionDetailEntity item in list) {
                      isLimitOrder = item.limitOrder ?? false;

                      for (final PromotionItemDataEntity element
                      in item.promotionItemData ?? []) {
                        final groupVar = element.groupVariantData;
                        if (groupVar.isEmpty) {
                          minOrder = minOrder +
                              (element.valueMin ?? 0) *
                                  element.quantitySelected.validator;
                        } else {
                          for (final e in groupVar) {
                            if (e.amount > 0) {
                              minOrder =
                                  minOrder + (element.valueMin ?? 0) * e.amount;
                            }
                          }
                        }
                      }
                    }
                    printDebug('========');
                    printDebug('list: ${list.length}');
                    printDebug('price: $price');
                    printDebug('minOrder: $minOrder');
                    printDebug('isLimitOrder: $isLimitOrder');
                    printDebug('========');

                    if (price < minOrder && isLimitOrder) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Giá trị đơn hàng không đủ để sử dụng ${list.length} CTKM bạn vừa chọn',
                            style: p5.copyWith(color: red_1),
                          ),
                          backgroundColor: red_2,
                        ),
                      );
                      return;
                    }


                    widget.onConfirm
                        ?.call(myBloc.state.promotionDetailSelectedPromo);
                    Navigator.of(context).pop();
                  },
                  largeButton: true,
                  icon: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
