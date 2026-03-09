import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_state.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';

import '../../../../base/empty_container.dart';
import '../../../../constants/spacing.dart';
import '../../../customer/cubit/customer_cubit.dart';

OverlayEntry overlaySuggestCustomer({
  required LayerLink layerLink,
  required AnimationController controllerDropdownAnimation,
  required Animation<double> animationDropDown,
  required CustomerCubit myBloc,
  Function(CustomerEntity? value)? onSelected,
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
                child: BlocBuilder<CustomerCubit, CustomerState>(
                  bloc: myBloc,
                  builder: (context, state) {
                    return Container(
                      height: 300,
                      child: SingleChildScrollView(
                        controller: myBloc.scrollController,
                        child: Column(
                          children: [
                            InfiniteList(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              getData: (page) {
                                return myBloc.getList(page);
                              },
                              itemBuilder: (BuildContext context, item, int index) {
                                return Text(item.name ?? '');
                              },
                              scrollController: myBloc.scrollController,
                              infiniteListController: myBloc.entityILC,
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
          ),
        ),
      ),
    ),
  );
}
