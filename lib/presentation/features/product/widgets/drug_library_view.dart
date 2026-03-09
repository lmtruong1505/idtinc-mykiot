// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:pharmago_app/presentation/base/cache_image.dart';
// import 'package:pharmago_app/presentation/base/infinite_list.dart';
// import 'package:pharmago_app/presentation/base/loading.dart';
// import 'package:pharmago_app/presentation/base/text_field.dart';
// import 'package:pharmago_app/presentation/constants/colors.dart';
// import 'package:pharmago_app/presentation/constants/size_device.dart';
// import 'package:pharmago_app/presentation/features/product/domain/entities/variant_entity.dart';
// import 'package:pharmago_app/shared/constants/pref_key.dart';

// import '../../../constants/spacing.dart';
// import '../../../constants/typography.dart';
// import '../../../router/router.gr.dart';
// import '../cubit/product_manager_cubit/product_manager_cubit.dart';
// import 'dialog_import_product.dart';

// class DrugLibraryView extends StatefulWidget {
//   const DrugLibraryView({
//     super.key,
//     required this.myBloc,
//   });

//   final ProductManagerCubit myBloc;

//   @override
//   State<DrugLibraryView> createState() => _DrugLibraryViewState();
// }

// class _DrugLibraryViewState extends State<DrugLibraryView> {
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         widget.myBloc.productLibraryILC.onRefresh();
//       },
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         controller: widget.myBloc.scrollController,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppInput(
//               label: 'Tìm kiếm sản phẩm',
//               hintText: 'Tìm kiếm sản phẩm',
//               backgroundColor: whiteColor,
//               prefixIcon: const Icon(
//                 Icons.search,
//                 size: sp20,
//                 color: greyColor,
//               ),
//             ),
//             gapHeight(sp24),
//             Text(
//               'Danh sách thuốc',
//               style: p3.copyWith(color: blackColor),
//             ),
//             gapHeight(sp16),
//             InfiniteList<VariantEntity>(
//               shrinkWrap: true,
//               getData: (page) {
//                 if (page == 0) {
//                   widget.myBloc.productLibraryILC.itemList = [];
//                 }
//                 return widget.myBloc.getVariant(page);
//               },
//               itemBuilder: (context, item, index) {
//                 return InkWell(
//                   onTap: () => context.router.push(
//                     ProductDetailRoute(id: item.product!.id!),
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.all(sp16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(sp12),
//                       color: whiteColor,
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(0),
//                             leading: SizedBox(
//                               width: sp48,
//                               height: sp48,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(sp8),
//                                 child: BaseCacheImage(
//                                     url: item.image ??
//                                         PrefKeys.imgProductDefault),
//                               ),
//                             ),
//                             title: Text(
//                               item.title ?? '',
//                               style: p5.copyWith(color: blackColor),
//                             ),
//                           ),
//                         ),
//                         gapWidth(sp16),
//                         IconButton(
//                           onPressed: () {
//                             widget.myBloc.getUnit(item.id!);
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return DialogImportProduct(
//                                   variant: item,
//                                   myBloc: widget.myBloc,
//                                   onConfirm: () => _confirmImportProduct(item),
//                                 );
//                               },
//                             );
//                           },
//                           icon: const Icon(
//                             Icons.add_circle,
//                             color: mainColor,
//                             size: sp24,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               scrollController: widget.myBloc.scrollController,
//               infiniteListController: widget.myBloc.productLibraryILC,
//               circularProgressIndicator: const BaseLoading(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _confirmImportProduct(VariantEntity variant) {
//     widget.myBloc.importVariant(variant.id!).then((value) {
//       if (value.code == 200) {
//         ScaffoldMessenger.of(context).clearSnackBars();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(sp12),
//             ),
//             backgroundColor: whiteColor,
//             behavior: SnackBarBehavior.floating,
//             margin: const EdgeInsets.all(sp16),
//             padding: const EdgeInsets.all(sp16),
//             content: Container(
//               width: widthDevice(context) - sp32,
//               color: whiteColor,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: sp48,
//                     height: sp48,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(sp8),
//                       child: BaseCacheImage(
//                         url: variant.image ?? PrefKeys.imgProductDefault,
//                       ),
//                     ),
//                   ),
//                   gapWidth(sp12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Đã nhập sản phẩm về kho',
//                           style: p4.copyWith(color: blackColor),
//                         ),
//                         gapHeight(sp8),
//                         Text(
//                           variant.title ?? '',
//                           style: p6.copyWith(color: blackColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).clearSnackBars();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(sp12),
//             ),
//             backgroundColor: red_1,
//             behavior: SnackBarBehavior.floating,
//             margin: const EdgeInsets.all(sp16),
//             padding: const EdgeInsets.all(sp16),
//             content: Text(
//               'Lỗi nhập hàng về kho',
//               style: p5.copyWith(color: whiteColor),
//             ),
//           ),
//         );
//       }
//     });
//   }
// }
