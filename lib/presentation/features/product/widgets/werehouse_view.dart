import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features/product/cubit/product_manager_cubit/product_manager_cubit.dart';

class WerehouseView extends StatefulWidget {
  const WerehouseView({
    super.key,
    required this.myBloc,
  });

  final ProductManagerCubit myBloc;

  @override
  State<WerehouseView> createState() => _WerehouseViewState();
}

class _WerehouseViewState extends State<WerehouseView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.myBloc.scrollController,
      child: Column(
        children: [
          // InfiniteList<VariantWarehouseEntity>(
          //   shrinkWrap: true,
          //   getData: (int page) async {
          //     return widget.myBloc.getVariantWarehouse(page);
          //   },
          //   itemBuilder: (context, item, index) {
          //     return InkWell(
          //       onTap: () => context.router.push(
          //         ProductDetailRoute(id: item.variant!.productId!),
          //       ),
          //       child: Container(
          //         padding: const EdgeInsets.all(sp16),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(sp12),
          //           color: whiteColor,
          //           boxShadow: [
          //             BoxShadow(
          //               color: blackColor.withOpacity(0.1),
          //               offset: const Offset(0, 0),
          //               blurRadius: sp4,
          //             )
          //           ]
          //         ),
          //         child: Row(
          //           children: [
          //             Expanded(
          //               child: ListTile(
          //                 contentPadding: const EdgeInsets.all(0),
          //                 leading: SizedBox(
          //                   width: sp48,
          //                   height: sp48,
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(sp8),
          //                     child: BaseCacheImage(
          //                       url: item.variant?.image ??
          //                           PrefKeys.imgProductDefault,
          //                     ),
          //                   ),
          //                 ),
          //                 title: Text(
          //                   item.variant?.title ?? '',
          //                   style: p5.copyWith(color: blackColor),
          //                 ),
          //                 subtitle: Container(
          //                   margin: const EdgeInsets.only(top: sp8),
          //                   child: RichText(
          //                     text: TextSpan(
          //                       text: 'Tồn kho: ',
          //                       style: p6.copyWith(color: greyColor),
          //                       children: [
          //                         TextSpan(
          //                           text: ' ${item.amount} viên',
          //                           style: h6.copyWith(color: borderColor_4),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             gapWidth(sp16),
          //             // IconButton(
          //             //   onPressed: () {
          //             //     widget.myBloc.getPackagingProduct(item.id!);
          //             //     showDialog(
          //             //       context: context,
          //             //       builder: (context) {
          //             //         return DialogImportProduct(
          //             //           productEntity: item,
          //             //           myBloc: widget.myBloc,
          //             //           onConfirm: () => _confirmImportProduct(item),
          //             //         );
          //             //       },
          //             //     );
          //             //   },
          //             //   icon: const Icon(
          //             //     Icons.add_circle,
          //             //     color: mainColor,
          //             //     size: sp24,
          //             //   ),
          //             // ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          //   scrollController: widget.myBloc.scrollController,
          //   infiniteListController: widget.myBloc.productInventoryILC,
          //   noItemFoundWidget: const WarehouseEmptyView(),
          //   circularProgressIndicator: const BaseLoading(),
          // ),
        ],
      ),
    );
  }
}
