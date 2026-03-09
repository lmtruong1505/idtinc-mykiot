import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';

import '../../../constants/asset_path.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';

OverlayEntry overlaySuggetCustomer({
  required LayerLink layerLink,
  required AnimationController controllerDropdownAnimation,
  required Animation<double> animationDropDown,
  required OrderCreateCubit myBloc,
  Function(CustomerEntity? value)?  onSelected,
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
            (layerLink.leader?.offset.dy ?? 0) + sp20,
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
                        child: state.suggestCustomer.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.all(sp0),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final item = state.suggestCustomer[index];
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
                                        Text(
                                          item?.phone ?? '',
                                          style: p6.copyWith(color: greyColor),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(height: sp16),
                                itemCount: state.suggestCustomer.length,
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