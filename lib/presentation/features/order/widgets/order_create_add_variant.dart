import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/widgets/card_variant.dart';

import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';
import 'bts_select_variant.dart';

class OrderCreateAddVariant extends StatelessWidget {
  const OrderCreateAddVariant({
    super.key,
    required this.myBloc,
    required this.formKey,
  });

  final OrderCreateCubit myBloc;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      bloc: myBloc,
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            width: widthDevice(context),
            height: heightDevice(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách sản phẩm',
                      style: p5.copyWith(color: blackColor),
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                sp12,
                              ),
                            ),
                          ),
                          context: context,
                          builder: (context) => BtsSelectVariant(
                            initValue: state.variantSelected,
                            // onConfirm: myBloc.updateVariantSelected,
                          ),
                        );
                      },
                      child: Text(
                        'Chọn sản phẩm',
                        style: h6.copyWith(color: blue_1),
                      ),
                    ),
                  ],
                ),
                gapHeight(sp16),
                AppInputSupport(
                  hintText: 'Tìm kiếm sản phẩm',
                  backgroundColor: whiteColor,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                gapHeight(sp24),
                state.variantSelected.isEmpty
                    ? Text(
                        'Chưa có sản phẩm được chọn.\nVui lòng chọn sản phẩm',
                        style: p5.copyWith(color: blackColor),
                        textAlign: TextAlign.center,
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final variant = state.variantSelected[index];
                            return CardVariantCreateOrder(
                              variant: variant,
                              myBloc: myBloc,
                              index: index,
                            );
                          },
                          separatorBuilder: (context, index) => gapHeight(sp16),
                          itemCount: state.variantSelected.length,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
