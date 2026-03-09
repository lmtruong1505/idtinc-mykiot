import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';

OverlayEntry overlaySuggetVariant({
  required LayerLink layerLink,
  required AnimationController controllerDropdownAnimation,
  required Animation<double> animationDropDown,
  required OrderCreateCubit myBloc,
  Function(VariantEntity? value)? onSelected,
}) {
  return OverlayEntry(
    builder: (context) => Positioned(
      left: 0, // Horizontal positioning
      top: 0,
      width: layerLink.leaderSize?.width,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: true,
        offset: Offset(
          0,
          ((layerLink.leader?.offset.dy ?? 0)) / 2,
        ),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sp12),
          ),
          elevation: sp4,
          child: AnimatedBuilder(
            animation: controllerDropdownAnimation,
            builder: (context, child) => ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
                minHeight: 0,
              ),
              child: Visibility(
                visible: animationDropDown.value == 300,
                child: BlocBuilder<OrderCreateCubit, OrderCreateState>(
                  bloc: myBloc,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: state.suggestVariant.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.all(sp0),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = state.suggestVariant[index];
                                return InkWell(
                                  onTap: () => onSelected?.call(item),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item?.name ?? '',
                                        style: p5.copyWith(color: blackColor),
                                      ),
                                      gapHeight(sp8),
                                      Text(
                                        item?.code ?? '',
                                        style: p5.copyWith(color: greyColor),
                                      ),
                                      gapHeight(sp8),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tồn ${FormatCurrency(item?.quantityInStock)} (${item?.units?[0].name})',
                                                style: p5.copyWith(
                                                  color: blackColor,
                                                ),
                                              ),
                                              // Text(
                                              //   '${FormatCurrency(item?.quantityInStock)} (${item?.units?[0].name})',
                                              //   style: p5.copyWith(
                                              //     color: blackColor,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${FormatCurrency(item?.priceSell)}đ',
                                            style: p5.copyWith(
                                              color: blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(height: sp16),
                              itemCount: state.suggestVariant.length,
                            )
                          : Container(
                              child: Lottie.asset(
                                '${AssetsPath.lottie}/empty.json',
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
