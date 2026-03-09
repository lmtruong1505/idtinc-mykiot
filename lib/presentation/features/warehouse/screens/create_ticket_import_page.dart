import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/empty_container.dart';
import '../../../base/row_item.dart';
import '../../../base/select.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../../../shared/utils/event.dart';
import '../cubit/ticket_create_cubit/ticket_create_cubit.dart';
import '../cubit/ticket_create_cubit/ticket_create_state.dart';
import '../domain/entities/batch_entity.dart';
import '../domain/entities/variant_warehouse_entity.dart';

@RoutePage()
class CreateTicketImportPage extends StatefulWidget {
  @override
  State<CreateTicketImportPage> createState() => _CreateTicketImportPageState();
}

class _CreateTicketImportPageState extends State<CreateTicketImportPage> {
  final myBloc = getIt.get<TicketCreateCubit>();
  @override
  Widget build(BuildContext context) => BlocProvider<TicketCreateCubit>(
        create: (context) => myBloc..getList(),
        child: BlocBuilder<TicketCreateCubit, TicketCreateState>(
          builder: (context, state) => Scaffold(
            backgroundColor: bg_5,
            appBar: const BaseAppBar(title: 'Tạo mới phiếu nhập kho'),
            body: Container(
              padding: const EdgeInsets.all(sp16),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(sp16),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(sp12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child:
                              const Text('Thông tin đơn nhập kho', style: p3),
                        ),
                        gapHeight(sp12),
                        AppInputSupport(
                          label: 'Mã đơn',
                          hintText: 'Nhập mã đơn',
                          initialValue: state.code,
                          onChanged: myBloc.changeCode,
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          boxShadow: [],
                        ),
                        gapHeight(sp16),
                        AppInputSupport(
                          label: 'Ghi chú',
                          hintText: 'Nhập tên ghi chú',
                          initialValue: state.note,
                          onChanged: myBloc.changeNote,
                          backgroundColor: whiteColor,
                          borderColor: borderColor_2,
                          boxShadow: [],
                        ),
                        gapHeight(sp16),
                        CommonDropdown(
                          label: 'Nhà cung cấp',
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Nhà cung cấp 1', style: p6),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('Nhà cung cấp 2', style: p6),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('Nhà cung cấp 3', style: p6),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text('Nhà cung cấp 4', style: p6),
                            ),
                          ],
                          hintText: 'Chọn nhà cung cấp',
                          onChanged: myBloc.changeSupplierId,
                        ),
                        gapHeight(sp16),
                        CommonDropdown(
                          label: 'Kho',
                          items: state.warehouseDrops,
                          hintText: 'Chọn kho',
                          onChanged: myBloc.changeWarehouseId,
                        ),
                      ],
                    ),
                  ),
                  gapHeight(sp24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Danh sách sản phẩm', style: p3),
                      InkWell(
                        onTap: () => myBloc.setVariants(context),
                        child: Text(
                          'Chọn sản phẩm',
                          style: p3.copyWith(color: blue_1),
                        ),
                      ),
                    ],
                  ),
                  gapHeight(sp28),
                  BlocBuilder<TicketCreateCubit, TicketCreateState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        controller: myBloc.scrollController,
                        child: Column(
                          children: [
                            AppInputSupport(
                              hintText: 'Tìm kiếm theo tên/mã sản phẩm',
                              backgroundColor: whiteColor,
                              onConfirm: myBloc.searchChange,
                              prefixIcon: const Icon(Icons.search_rounded),
                            ),
                            for (var i = 0; i < state.variants.length; i++)
                              state.variants[i].name.contains(state.search)
                                  ? _oneItem(state.variants[i], i)
                                  : Container(),
                            if (state.variants.isEmpty) const EmptyContainer(),
                          ],
                        ),
                      );
                    },
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
                  gapWidth(sp12),
                  Expanded(
                    child: MainButton(
                      title: 'Xem trước',
                      event: () => context.router
                          .push(TicketCreatePreviewRoute(state: state)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _oneItem(VariantWarehouseEntity item, int index) => Container(
        padding: const EdgeInsets.all(sp16),
        margin: const EdgeInsets.fromLTRB(0, sp16, 0, 0),
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
                        title: Text(
                          item.name,
                          style: p5.copyWith(color: blackColor),
                        ),
                        subtitle: Text(
                          item.code,
                          style: p6.copyWith(color: greyColor),
                        ),
                      ),
                      const Positioned(
                        bottom: 10,
                        left: sp48 + 10,
                        child: Icon(Icons.circle, size: 10, color: green_1),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => DialogUtils.showDialogWithTitleAndOptionButton(
                    context,
                    'Xác nhận xoá sản phẩm??',
                    () => myBloc.removeVariant(item),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(sp8),
                    margin: const EdgeInsets.fromLTRB(sp12, sp12, 0, 0),
                    decoration: const BoxDecoration(
                      color: red_2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(sp12),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.delete_outline,
                      size: sp20,
                      color: red_1,
                    ),
                  ),
                ),
              ],
            ),
            gapHeight(sp16),
            RowItem(title: 'Giá nhập', content: '${item.priceImport} VNĐ'),
            gapHeight(sp12),
            RowItem(title: 'Số lượng', content: FormatCurrency(item.amount)),
            gapHeight(sp12),
            RowItem(
              title: 'Tổng tiền',
              content: '${FormatCurrency(item.priceImport * item.amount)} VNĐ',
            ),
            gapHeight(sp12),
            if (item.batchs.isNotEmpty) _infoBatchs(item.batchs, item, index),
            SizedBox(
              width: double.infinity,
              child: ExtraButton(
                title: 'Thêm lô',
                icon: const Icon(Icons.add_rounded),
                largeButton: false,
                event: () => myBloc.changeBatchs(context, item, index, true),
              ),
            ),
          ],
        ),
      );

  Widget _infoBatchs(
    List<BatchEntity> batchs,
    VariantWarehouseEntity variant,
    int index,
  ) =>
      Column(
        children: [
          const Divider(height: sp16, color: borderColor_2),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text('Lô sản phẩm', style: p3),
          ),
          for (final item in batchs) _oneInfoBatch(item, variant, index),
          gapHeight(sp12),
        ],
      );

  Widget _oneInfoBatch(
    BatchEntity item,
    VariantWarehouseEntity variant,
    int index,
  ) =>
      Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: borderColor_1,
                  borderRadius: const BorderRadius.all(Radius.circular(sp8)),
                  border: Border.all(color: borderColor_2),
                ),
                child: Text(
                  '${item.code} - ${item.amount}',
                  style: p6.copyWith(color: blackColor),
                ),
              ),
            ),
            InkWell(
              onTap: () => myBloc.changeBatchs(context, variant, index, false),
              child: Container(
                padding: const EdgeInsets.all(sp8),
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(sp8)),
                  border: Border.all(color: borderColor_2),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.edit_outlined,
                  size: sp20,
                  color: blackColor,
                ),
              ),
            ),
          ],
        ),
      );
}
