// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pharmago_app/presentation/base/row_item.dart';
// import 'package:pharmago_app/presentation/base/two_button_box.dart';
// import 'package:pharmago_app/presentation/constants/size_device.dart';
// import 'package:pharmago_app/presentation/features/product/cubit/product_manager_cubit/product_manager_state.dart';

// import '../../../base/text_field.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/spacing.dart';
// import '../../../constants/typography.dart';
// import '../cubit/product_manager_cubit/product_manager_cubit.dart';
// import '../domain/entities/variant_entity.dart';

// class DialogImportProduct extends StatelessWidget {
//   const DialogImportProduct({
//     super.key,
//     required this.variant,
//     required this.myBloc,
//     this.onConfirm,
//   });

//   final VariantEntity variant;
//   final ProductManagerCubit myBloc;
//   final VoidCallback? onConfirm;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(sp16),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: heightDevice(context) * 0.7,
//             minHeight: heightDevice(context) * 0.4,
//           ),
//           child: Material(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(sp8),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(sp12),
//               child: Scaffold(
//                 backgroundColor: whiteColor,
//                 body: Container(
//                   padding: const EdgeInsets.all(sp16),
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Nhập sản phẩm về kho',
//                           style: p3.copyWith(color: blackColor),
//                         ),
//                         gapHeight(sp24),
//                         RowItem(
//                           title: 'Tên sản phẩm',
//                           content: variant.title ?? '',
//                         ),
//                         gapHeight(sp16),
//                         const RowItem(
//                           title: 'Tồn kho',
//                           content: '...',
//                         ),
//                         gapHeight(sp16),
//                         BlocBuilder<ProductManagerCubit, ProductManagerState>(
//                           bloc: myBloc,
//                           builder: (context, state) {
//                             return ListView.separated(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 final unit = state.unit?.conversions[index];
//                                 return Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: sp8,
//                                     horizontal: sp16,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(sp8),
//                                     color: bg_5,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               unit?.title ?? '',
//                                               style: p5.copyWith(
//                                                   color: blackColor),
//                                             ),
//                                             gapHeight(sp8),
//                                             Text(
//                                               '${unit?.times} Viên',
//                                               style: p6.copyWith(
//                                                   color: borderColor_4),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       gapWidth(sp24),
//                                       Expanded(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               color: whiteColor,
//                                               borderRadius:
//                                                   BorderRadius.circular(sp8)),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     final quantity =
//                                                         unit?.quantityAction ??
//                                                             0;
//                                                     final value = quantity < 1
//                                                         ? 0
//                                                         : quantity - 1;
//                                                     myBloc.quantityActionChange(
//                                                       unit?.id,
//                                                       value,
//                                                     );
//                                                   },
//                                                   child: const SizedBox(
//                                                     height: 46,
//                                                     width: 46,
//                                                     child: Center(
//                                                       child: Icon(
//                                                         Icons.remove,
//                                                         size: sp16,
//                                                         color: borderColor_4,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: AppInputSupport(
//                                                   controller:
//                                                       TextEditingController(
//                                                     text: unit?.quantityAction
//                                                         .toString(),
//                                                   ),
//                                                   readOnly: true,
//                                                   textInputType:
//                                                       TextInputType.number,
//                                                   hintText: '0',
//                                                   textAlign: TextAlign.center,
//                                                   onChanged: (value) {},
//                                                   inputFormatters: <TextInputFormatter>[
//                                                     FilteringTextInputFormatter
//                                                         .digitsOnly,
//                                                     LengthLimitingTextInputFormatter(
//                                                       6,
//                                                     ),
//                                                   ],
//                                                   backgroundColor: whiteColor,
//                                                   borderColor: whiteColor,
//                                                   padding:
//                                                       const EdgeInsets.all(sp4),
//                                                   radius: sp32,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     final value =
//                                                         (unit?.quantityAction ??
//                                                                 0) +
//                                                             1;
//                                                     myBloc.quantityActionChange(
//                                                       unit?.id,
//                                                       value,
//                                                     );
//                                                   },
//                                                   child: const SizedBox(
//                                                     height: 46,
//                                                     width: 46,
//                                                     child: Center(
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         size: sp16,
//                                                         color: borderColor_4,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               separatorBuilder: (context, index) =>
//                                   gapHeight(sp16),
//                               itemCount: state.unit?.conversions.length ?? 0,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 bottomNavigationBar: TwoButtonBox(
//                   mainTitle: 'Xác nhận',
//                   extraTitle: 'Đóng lại',
//                   mainOnTap: () {
//                     onConfirm?.call();
//                     Navigator.of(context).pop();
//                   },
//                   extraOnTap: () => Navigator.of(context).pop(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
