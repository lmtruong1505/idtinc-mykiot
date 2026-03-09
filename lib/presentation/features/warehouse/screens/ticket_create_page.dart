import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';

import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../cubit/ticket_create_cubit/ticket_create_cubit.dart';
import '../cubit/ticket_create_cubit/ticket_create_state.dart';

@RoutePage()
class TicketCreatePreviewPage extends StatefulWidget {
  final TicketCreateState state;
  const TicketCreatePreviewPage({super.key, required this.state});
  @override
  State<TicketCreatePreviewPage> createState() =>
      _TicketCreatePreviewPageState();
}

class _TicketCreatePreviewPageState extends State<TicketCreatePreviewPage> {
  final myBloc = getIt.get<TicketCreateCubit>();
  @override
  Widget build(BuildContext context) => BlocProvider<TicketCreateCubit>(
      create: (context) => myBloc..setState(widget.state),
      child: BlocBuilder<TicketCreateCubit, TicketCreateState>(
          builder: (context, state) => Scaffold(
              backgroundColor: bg_5,
              appBar: const BaseAppBar(title: 'Tạo mới phiếu nhập kho'),
              body: Container(
                  margin: const EdgeInsets.all(sp16),
                  child: ListView(children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: sp24,
                          horizontal: sp16,
                        ),
                        width: widthDevice(context),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.1),
                              offset: const Offset(1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Thông tin đơn nhập kho', style: p3)),
                          gapHeight(sp12),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Mã đơn', style: p3)),
                          Row(children: [
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: borderColor_2,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(color: borderColor_2)),
                                child: Text("Nháp", style: p3)),
                          ]),
                          Container(
                              alignment: Alignment.centerLeft,
                              child:
                                  Text('Kho ${state.warehouseId}', style: p3)),
                          gapHeight(sp16),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(state.note, style: p6)),
                        ])),
                    SizedBox(height: sp28),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: sp24, horizontal: sp16),
                        width: widthDevice(context),
                        decoration:
                            BoxDecoration(color: whiteColor, boxShadow: [
                          BoxShadow(
                              color: blackColor.withOpacity(0.1),
                              offset: const Offset(1, 1),
                              blurRadius: 1)
                        ]),
                        child: Column(children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Nhà cung cấp', style: p3)),
                          Divider(height: 15, color: borderColor_2),
                          gapHeight(sp12),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Tên nhà cung cấp', style: p3)),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Địa chỉ', style: p6)),
                          gapHeight(sp12),
                          RowItem(title: 'Đại diện', content: 'Trần thế anh'),
                          gapHeight(sp12),
                          RowItem(
                              title: 'Số điện thoại', content: '0123 456 789'),
                          gapHeight(sp12),
                          RowItem(
                              title: 'Email', content: 'trantheanh@gmail.com'),
                        ])),
                    gapHeight(sp28),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Danh sách sản phẩm', style: p3)),
                    gapHeight(sp16),
                    BlocBuilder<TicketCreateCubit, TicketCreateState>(
                        builder: (context, state) {
                      return SingleChildScrollView(
                          controller: myBloc.scrollController,
                          child: Column(children: [
                            AppInputSupport(
                                hintText: 'Tìm kiếm theo tên/mã sản phẩm',
                                backgroundColor: whiteColor,
                                onConfirm: myBloc.searchChange,
                                prefixIcon: const Icon(Icons.search_rounded)),
                            for (var i = 0; i < state.variants.length; i++)
                              state.variants[i].name.contains(state.search)
                                  ? _oneItem(state.variants[i])
                                  : Container(),
                          ]));
                    })
                  ])),
              bottomNavigationBar: Container(
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(color: whiteColor, boxShadow: [
                    BoxShadow(
                        color: blackColor.withOpacity(0.1),
                        offset: const Offset(0, -1),
                        blurRadius: sp4)
                  ]),
                  child: Row(children: [
                    Expanded(
                        child: ExtraButton(
                            title: 'Huỷ bỏ',
                            event: () => context.router.pop(),
                            largeButton: false,
                            backgroundColor: bg_4,
                            borderColor: borderColor_2)),
                    SizedBox(width: 10),
                    Expanded(
                        child: MainButton(
                            title: 'Tạo mới',
                            largeButton: false,
                            event: () => myBloc.createWarehouse(context)))
                  ])))));

  Widget _oneItem(VariantWarehouseEntity item) => Container(
      padding: const EdgeInsets.all(sp16),
      margin: EdgeInsets.fromLTRB(0, sp16, 0, 0),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
          boxShadow: [
            BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 0))
          ]),
      child: Column(children: [
        Stack(children: [
          ListTile(
            leading: SizedBox(
                height: sp48,
                width: sp48,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: BaseCacheImage(url: item.image))),
            title: Text(item.name, style: p5.copyWith(color: blackColor)),
            subtitle: Text(item.code, style: p6.copyWith(color: greyColor)),
          ),
          Positioned(
              bottom: 10,
              left: sp48 + 10,
              child: Icon(Icons.circle, size: 10, color: green_1))
        ]),
        gapHeight(sp16),
        RowItem(title: 'Giá nhập', content: '${item.priceImport} VNĐ'),
        gapHeight(sp12),
        RowItem(title: 'Số lượng', content: item.amount.toString()),
        gapHeight(sp12),
        RowItem(title: 'Tổng tiền', content: '35.000.000 VNĐ'),
        gapHeight(sp12),
        if (item.batchs.isNotEmpty) _infoBatchs(item.batchs),
      ]));

  Widget _infoBatchs(List<BatchEntity> batchs) => Column(children: [
        Divider(height: 15, color: borderColor_2),
        Container(
            alignment: Alignment.centerLeft,
            child: Text("Lô sản phẩm", style: p3)),
        for (final item in batchs) _oneInfoBatch(item),
        gapHeight(sp12),
      ]);

  Widget _oneInfoBatch(BatchEntity item) => Container(
      height: 40,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: borderColor_1,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: borderColor_2)),
      child: Text('${item.code} - ${item.amount}',
          style: p6.copyWith(color: blackColor)));
}
