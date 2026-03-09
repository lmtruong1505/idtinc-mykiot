import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base/row_item.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/promotion_select_cubit/promotion_select_cubit.dart';
import '../domain/entities/promotion_detail_wm_entity.dart';
import 'bts_product_promotion.dart';

class PromosCard extends StatefulWidget {
  const PromosCard({
    super.key,
    required this.promo,
    required this.myBloc,
  });

  final PromotionDetailEntity promo;
  final PromotionSelectCubit myBloc;

  @override
  State<PromosCard> createState() => _PromosCardState();
}

class _PromosCardState extends State<PromosCard> {
  String? errMessage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          errMessage = widget.myBloc.validatePromotionSameTime(widget.promo);
        });

        if (errMessage != null) {
          Timer(const Duration(milliseconds: 3000), () {
            setState(() {
              errMessage = null;
            });
          });
          return;
        }
        widget.myBloc.handleClickPromo(widget.promo.id);
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          isDismissible: false,
          enableDrag: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sp12),
          ),
          builder: (context) {
            return BtsProductPromotionView(
              promotionApplyOrderCubit: widget.myBloc,
              idPromo: widget.promo.id ?? 0,
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(sp16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp12),
          color: whiteColor,
          border: Border.all(color: borderColor_2),
          boxShadow: [
            BoxShadow(
              color: greyColor.withOpacity(0.2),
              blurRadius: sp4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.promo.title ?? '',
              style: h5.copyWith(color: blackColor),
            ),
            const SizedBox(height: sp16),
            RowItem(
              title: 'Thời gian áp dụng',
              titleColor: greyColor,
              content:
                  '${DateFormat('dd/M/yy', 'vi').format(widget.promo.startDate ?? DateTime.now())} - ${DateFormat('dd/M/yy', 'vi').format(widget.promo.endDate ?? DateTime.now())}',
            ),
            const SizedBox(height: sp8),
            RowItem(
              title: 'Loại khuyễn mãi khách nhận',
              titleColor: greyColor,
              content: '${widget.promo.promotionTypeData?.title}',
            ),
            const SizedBox(height: sp8),
            RowItem(
              title: 'Giới hạn theo tổng tiền của đơn hàng',
              titleColor: greyColor,
              content: widget.promo.limitOrder == true ? 'Có' : 'Không',
            ),
            const SizedBox(height: sp8),
            RowItem(
              title: 'Áp dụng đồng thời',
              titleColor: greyColor,
              content: widget.promo.sameTime == true ? 'Có' : 'Không',
            ),
            const SizedBox(height: sp8),
            RowItem(
              title: 'Áp dụng nhiều lần',
              titleColor: greyColor,
              content: widget.promo.manyTime == true ? 'Có' : 'Không',
            ),
            Visibility(
              visible: widget.myBloc.state.promotionDetailSelectedPromo
                      ?.where((e) => e.id == widget.promo.id)
                      .toList()
                      .isNotEmpty ??
                  false,
              child: Column(
                children: [
                  const SizedBox(height: sp16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(sp12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp12),
                            color: green_2,
                          ),
                          child: Center(
                            child: Text(
                              'Đã chọn',
                              style: p5.copyWith(color: green_1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: sp12),
                      InkWell(
                        onTap: () {
                          widget.myBloc.unSelectedPromo(widget.promo.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(sp12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp12),
                            color: red_2,
                            boxShadow: [
                              BoxShadow(
                                color: blackColor.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: sp16,
                            color: red_1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: errMessage != null,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: sp16),
                child: Text(
                  errMessage ?? '',
                  style: p5.copyWith(color: red_1),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
