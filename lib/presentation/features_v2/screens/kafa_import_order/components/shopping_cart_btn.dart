import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/shopping_cart/drug_cart_bloc.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../blocs/state/init_state.dart';

class ShoppingCartBtn extends StatelessWidget {
  final bool isDetail;
  ShoppingCartBtn({
    super.key,
    this.isDetail = false,
    this.onTap,
  });
  final cartBloc = getIt<DrugCartBloc>();
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BlocBuilder<DrugCartBloc, CubitState>(
        bloc: cartBloc,
        builder: (context, state) {
          return Badge.count(
            count: cartBloc.cartLength,
            isLabelVisible: cartBloc.cartLength > 0,
            offset: const Offset(5, 5),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: isDetail
                      ? ColorApp.white.withOpacity(0.1)
                      : ColorApp.grey79.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: 8.pading,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 17,
                  color: isDetail ? ColorApp.white : ColorApp.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
