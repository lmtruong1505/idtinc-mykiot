// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pharmago/presentation/router/router.gr.dart';
//
// import '../../../../base/text_field.dart';
// import '../../../../constants/colors.dart';
// import '../../../../constants/spacing.dart';
// import '../../../../constants/typography.dart';
// import '../../cubit/service_create_cubit/service_create_cubit.dart';
//
// class ServiceAttachProduct extends StatefulWidget {
//   const ServiceAttachProduct({this.canAdd, this.myBloc, super.key});
//
//   final ServiceCreateCubit? myBloc;
//   final bool? canAdd;
//
//   @override
//   State<ServiceAttachProduct> createState() => _ServiceAttachProductState();
// }
//
// class _ServiceAttachProductState extends State<ServiceAttachProduct> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
//       decoration: BoxDecoration(
//         borderRadius:
//         const BorderRadius.vertical(bottom: Radius.circular(sp12)),
//         color: whiteColor,
//         boxShadow: [
//           BoxShadow(
//             color: blackColor.withOpacity(0.1),
//             offset: const Offset(1, 1),
//             blurRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Danh sách danh mục',
//                 style: p3.copyWith(color: blackColor),
//               ),
//               Row(
//                 children: [
//                   Visibility(
//                     visible: widget.canAdd ?? false,
//                     child: InkWell(
//                       onTap: () {
//                         context.router.push(ServiceSelectionProductRoute(serviceCreateCubit: widget.myBloc!));
//                       },
//                       child: Text(
//                         'Chọn sản phẩm',
//                         style: p5.copyWith(color: blue_1),
//                       ),
//                     ),
//                   ),
//                   gapWidth(sp8),
//                 ],
//               ),
//             ],
//           ),
//           gapHeight(sp16),
//           AppInputSupport(
//             hintText: 'Tìm kiếm theo tên/mã',
//             prefixIcon: const Icon(Icons.search_rounded),
//             backgroundColor: whiteColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
