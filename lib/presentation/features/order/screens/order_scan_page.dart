import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';

import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/order_scan_cubit/order_scan_cubit.dart';
import '../cubit/order_scan_cubit/order_scan_state.dart';
import '../widgets/scan_view.dart';

@RoutePage()
class OrderScanPage extends StatefulWidget {
  const OrderScanPage({
    super.key,
    required this.dataInit,
    this.onDispose,
  });

  final List<VariantEntity> dataInit;
  final Function(List<VariantEntity> value)? onDispose;

  @override
  State<OrderScanPage> createState() => _OrderScanPageState();
}

class _OrderScanPageState extends State<OrderScanPage> {
  final myBloc = getIt.get<OrderScanCubit>();

  @override
  void dispose() {
    super.dispose();

    // ScaffoldMessenger.of(context).clearSnackBars();
    widget.onDispose?.call(myBloc.state.variants);
    myBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderScanCubit>(
      create: (context) => myBloc
        ..init(widget.dataInit)
        ..startListeningCodeRequset(context),
      child: BlocBuilder<OrderScanCubit, OrderScanState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                ScanView(
                  type: state.view,
                  onScaned:(code) {
                    if (state.view == TypeScanView.barcode) {
                      myBloc.addBarcode(code);
                    } else {
                      myBloc.scanOrder(code);
                    }
                  },
                ),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: sp24,
                      horizontal: sp16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: whiteColor,
                          ),
                        ),
                        gapHeight(sp12),
                        CupertinoSlidingSegmentedControl<TypeScanView>(
                          padding: const EdgeInsets.all(sp4),
                          thumbColor: borderColor_1,
                          backgroundColor: whiteColor.withOpacity(0.2),
                          groupValue: state.view,
                          children: {
                            TypeScanView.qr: Container(
                              width: widthDevice(context) / 2,
                              padding: const EdgeInsets.all(sp12),
                              child: Text(
                                'Quét mã QR',
                                style: p5.copyWith(
                                  color: state.view == TypeScanView.qr
                                      ? blackColor
                                      : whiteColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TypeScanView.barcode: Text(
                              'Quét mã sản phẩm',
                              style: p5.copyWith(
                                color: state.view == TypeScanView.barcode
                                    ? blackColor
                                    : whiteColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          },
                          onValueChanged: myBloc.viewChange,
                        ),
                        gapHeight(sp24),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            state.view == TypeScanView.qr
                                ? 'QR Đơn thuốc/Đơn hàng'
                                : 'Quét mã sản phẩm',
                            textAlign: TextAlign.center,
                            style: h5.copyWith(color: whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: sp124,
                  right: sp16,
                  child: CircleAvatar(
                    radius: sp24,
                    backgroundColor: mainColor,
                    child: Text(
                      '${state.variants.length}',
                      style: p5.copyWith(color: whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
