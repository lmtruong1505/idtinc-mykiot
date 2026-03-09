import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/ticket_create_cubit/ticket_create_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/ticket_create_cubit/ticket_create_state.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';

@RoutePage()
class ProductsPage extends StatefulWidget {
  final List<int> idSelecteds;
  const ProductsPage({super.key, required this.idSelecteds});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final myBloc = getIt.get<TicketCreateCubit>();

  @override
  Widget build(BuildContext context) => BlocProvider<TicketCreateCubit>(
        create: (context) => myBloc..setIdSeleceds(widget.idSelecteds),
        child: Scaffold(
          backgroundColor: bg_5,
          appBar: const BaseAppBar(title: 'Chọn sản phẩm nhập kho'),
          body: Container(
            padding: const EdgeInsets.fromLTRB(sp16, 0, sp16, sp16),
            child: Column(
              children: [
                AppInputSupport(
                  hintText: 'Tìm kiếm theo tên/mã sản phẩm',
                  backgroundColor: whiteColor,
                  onConfirm: myBloc.searchChange,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                gapHeight(sp16),
                BlocBuilder<TicketCreateCubit, TicketCreateState>(
                  builder: (context, state) => Expanded(
                    child: SingleChildScrollView(
                      controller: myBloc.scrollController,
                      child: InfiniteList(
                        shrinkWrap: true,
                        getData: (page) => myBloc.getVariantList(page),
                        noItemFoundWidget: const Text(
                          'Không tìm thấy sản phẩm nào được nhập kho',
                          textAlign: TextAlign.center,
                          style: p3,
                        ),
                        itemBuilder: (context, item, index) =>
                            _oneItem(item, state),
                        scrollController: myBloc.scrollController,
                        infiniteListController: myBloc.variantsILC,
                        circularProgressIndicator: const BaseLoading(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(sp16),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.1),
                  offset: const Offset(0, -1),
                  blurRadius: sp4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ExtraButton(
                    title: 'Huỷ bỏ',
                    event: () => context.router.pop(),
                    backgroundColor: bg_4,
                    borderColor: borderColor_2,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MainButton(
                    title: 'Hoàn thành',
                    event: () => myBloc.onTapDone(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _oneItem(VariantWarehouseEntity item, TicketCreateState state) =>
      Container(
        padding: const EdgeInsets.all(sp16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                BaseCheckbox(
                  value: state.idSelecteds.contains(item.id),
                  onChanged: (value) =>
                      myBloc.changeStatus(item.id, value ?? false),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListTile(
                        leading: SizedBox(
                          height: sp48,
                          width: sp48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: BaseCacheImage(url: item.image),
                          ),
                        ),
                        title: Text(item.name,
                            style: p5.copyWith(color: blackColor)),
                        subtitle: Text(item.code,
                            style: p6.copyWith(color: greyColor)),
                      ),
                      const Positioned(
                        bottom: 10,
                        left: sp48 + 10,
                        child: Icon(Icons.circle, size: 10, color: green_1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            gapHeight(sp16),
            RowItem(title: 'Giá nhập', content: '${item.priceImport} VNĐ'),
            gapHeight(sp12),
            RowItem(title: 'Số lượng', content: item.amount.toString()),
            gapHeight(sp12),
            const RowItem(title: 'Tổng tiền', content: '35.000.000 VNĐ'),
          ],
        ),
      );
}
