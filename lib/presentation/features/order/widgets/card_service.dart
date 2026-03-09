import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../shared/utils/event.dart';
import '../../product/domain/entities/service_entity.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';

class CardServiceCreateOrder extends StatefulWidget {
  const CardServiceCreateOrder({
    super.key,
    required this.service,
    required this.myBloc,
    required this.index,
  });

  final ServiceEntity service;
  final OrderCreateCubit myBloc;
  final int index;

  @override
  State<CardServiceCreateOrder> createState() => _CardServiceCreateOrderState();
}

class _CardServiceCreateOrderState extends State<CardServiceCreateOrder> {
  late TextEditingController _priceCtl;

  @override
  void initState() {
    super.initState();

    _priceCtl =
        TextEditingController(text: FormatCurrency(widget.service.price));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCreateCubit, OrderCreateState>(
      bloc: widget.myBloc,
      builder: (context, state) {
        // if (my)

        return Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            color: whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListTile(
              //   contentPadding: const EdgeInsets.all(0),
              //   // leading: SizedBox(
              //   //   height: sp48,
              //   //   width: sp48,
              //   //   child: ClipRRect(
              //   //     borderRadius: BorderRadius.circular(sp8),
              //   //     child: BaseCacheImage(
              //   //       url: widget.service.media ?? PrefKeys.imgProductDefault,
              //   //     ),
              //   //   ),
              //   // ),
              //   title: Text(
              //     widget.service.title ?? 'Chưa có dữ liệu',
              //     style: p5.copyWith(color: blackColor),
              //   ),
              //   subtitle: Text(
              //     widget.service.code ?? 'Chưa có dữ liệu',
              //     style: p6.copyWith(color: greyColor),
              //   ),
              //   trailing: IconButton(
              //     onPressed: () => widget.myBloc.removeService(widget.index),
              //     icon: const Icon(
              //       Icons.delete_outline_rounded,
              //       color: red_1,
              //     ),
              //   ),
              // ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense:true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                title: Text(widget.service.title ?? '', style: p5.copyWith(color: blackColor)),
                subtitle: Text(widget.service.code ?? '', style: p5.copyWith(color: greyColor)),
                trailing: Text(
                    '${FormatCurrency(widget.service.price)}đ', style: p5.copyWith(color: green_1)),
              ),
              gapHeight(sp12),
              InputCurrency(
                controller: _priceCtl,
                label: 'Đơn giá',
                hintText: '',
                backgroundColor: bg_5,
                borderColor: bg_5,
                onChanged: (value) => widget.myBloc.serviceChange(
                  widget.index,
                  unitPrice: double.tryParse(value),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showDialog(Widget child) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => Container(
  //       height: 216,
  //       padding: const EdgeInsets.only(top: sp12),
  //       margin: EdgeInsets.only(
  //         bottom: MediaQuery.of(context).viewInsets.bottom,
  //       ),
  //       color: whiteColor,
  //       child: SafeArea(
  //         top: false,
  //         child: child,
  //       ),
  //     ),
  //   );
  // }
}
