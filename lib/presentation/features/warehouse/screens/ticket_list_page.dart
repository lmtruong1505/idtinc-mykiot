import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_cubit.dart';
import 'package:pharmago/presentation/features/warehouse/cubit/warehouse_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../domain/entities/ticket_entity.dart';

@RoutePage()
class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final myBloc = getIt.get<WarehouseCubit>();
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: bg_5,
          appBar: BaseAppBar(
            title: 'Danh sách đơn nhập kho',
            actions: [
              InkWell(
                onTap: () async {
                  await context.router.push(
                    const CreateTicketImportRoute(),
                  );
                  myBloc.entityILC.onRefresh();
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: const Icon(Icons.add, size: 30),
                ),
              ),
            ],
          ),
          body: _body(),
        ),
      );

  Widget _oneItem(TicketEntity item) => GestureDetector(
        onTap: () => context.router.push(TicketDetailRoute(id: item.id ?? 0)),
        child: Container(
            padding: const EdgeInsets.all(sp16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mã đơn: ${item.code}', style: p3),
                      Text('Tên kho: ${item.warehouseName}', style: p6),
                    ],
                  ),
                  Container(
                    width: 15,
                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Icon(Icons.more_vert, size: 20),
                  ),
                ],
              ),
              Row(children: [
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                          getBackgroundColorByStatus(item.status?.code ?? ''),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(item.status?.name ?? '',
                        style: p3.copyWith(
                            color: getColorByStatus(item.status?.code ?? '')))),
              ]),
              gapHeight(sp16),
              RowItem(
                  title: 'Kho nhận',
                  content: item.warehouseName ?? 'Chưa có thông tin'),
              gapHeight(sp12),
              RowItem(
                  title: 'Tổng số mặt hàng',
                  content: '${item.totalItems ?? '0'}'),
              gapHeight(sp12),
              RowItem(
                  title: 'Tổng tiền',
                  content: '${FormatCurrency(item.totalPrice)} VNĐ'),
              gapHeight(sp12),
              RowItem(
                  title: 'Người tạo',
                  content: item.userCreated ?? 'Chưa có thông tin'),
              gapHeight(sp12),
              RowItem(
                  title: 'Thời gian tạo',
                  content: DateFormat('h:m dd-M-y')
                      .format(item.createdAt ?? DateTime.now())),
              gapHeight(sp12),
            ])),
      );

  Widget _body() => Container(
        height: heightDevice(context),
        width: widthDevice(context),
        padding: const EdgeInsets.all(sp16),
        child: BlocProvider<WarehouseCubit>(
          create: (context) => myBloc,
          child: BlocBuilder<WarehouseCubit, WarehouseState>(
            builder: (context, state) => Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: borderColor_2.withOpacity(0.5),
                      groupValue: state.tabSelected,
                      children: <int, Widget>{
                        0: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: sp16, vertical: sp8),
                            child: Text('Đang tiến hành (${state.total})',
                                style: state.tabSelected == 0
                                    ? h6.copyWith(color: blackColor)
                                    : p5.copyWith(color: greyColor))),
                        1: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: sp16, vertical: sp8),
                            child: Text('Đơn nháp (${state.total})',
                                style: state.tabSelected == 1
                                    ? h6.copyWith(color: blackColor)
                                    : p5.copyWith(color: greyColor))),
                      },
                      onValueChanged: myBloc.tabChange,
                    )),
                gapHeight(sp24),
                Row(children: [
                  Expanded(
                      child: AppInputSupport(
                          hintText: 'Tìm kiếm theo tên/mã sản phẩm',
                          backgroundColor: whiteColor,
                          onConfirm: myBloc.searchChange,
                          prefixIcon: Icon(Icons.search_rounded))),
                  const SizedBox(width: sp16),
                  InkWell(
                      onTap: () async => await DialogUtils.showBottomDialogText(
                          context, SearchPopup()),
                      child: Container(
                          padding: const EdgeInsets.all(sp16 + 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp8),
                              border: Border.all(color: borderColor_2),
                              color: whiteColor),
                          child: IcSvg.img(IcSvg.iconFilter, color: greyColor)))
                ]),
                gapHeight(sp16),
                Expanded(
                  child: SingleChildScrollView(
                      controller: myBloc.scrollController,
                      child: InfiniteList<TicketEntity>(
                          shrinkWrap: true,
                          getData: (page) => myBloc.getListTicket(page),
                          itemBuilder: (context, item, index) => _oneItem(item),
                          scrollController: myBloc.scrollController,
                          infiniteListController: myBloc.entityILC,
                          noItemFoundWidget: const EmptyContainer(),
                          circularProgressIndicator: const BaseLoading())),
                ),
              ],
            ),
          ),
        ),
      );
}

class SearchPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
                    color: Colors.transparent,
                    child: Text("Đặt lại", style: p3.copyWith(color: blue_1)),
                  )),
              Text("Bộ lọc", style: p3),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 5, 16),
                    color: Colors.transparent,
                    child: Text("Áp dụng", style: p3.copyWith(color: blue_1)),
                  ))
            ]),
            SizedBox(height: 12),
            _oneDoubleTime(
                context, 'Thời gian tạo', DateTime.now(), (value) => {}),
            SizedBox(height: 12),
            _oneDoubleTime(
                context, 'Thời gian cập nhật', DateTime.now(), (value) => {}),
            SizedBox(height: 20),
            CommonDropdown(
                label: 'Theo kho',
                items: [
                  DropdownMenuItem(value: 1, child: Text('Kho 1', style: p6)),
                  DropdownMenuItem(value: 2, child: Text('Kho 2', style: p6)),
                  DropdownMenuItem(value: 3, child: Text('Kho 3', style: p6)),
                  DropdownMenuItem(value: 4, child: Text('Kho 4', style: p6)),
                ],
                hintText: 'Chọn kho',
                onChanged: (value) => {}),
            CommonDropdown(
                label: 'Theo nhà cung cấp',
                items: [
                  DropdownMenuItem(
                      value: 1, child: Text('Nhà cung cấp 1', style: p6)),
                  DropdownMenuItem(
                      value: 2, child: Text('Nhà cung cấp 2', style: p6)),
                  DropdownMenuItem(
                      value: 3, child: Text('Nhà cung cấp 3', style: p6)),
                  DropdownMenuItem(
                      value: 4, child: Text('Nhà cung cấp 4', style: p6)),
                ],
                hintText: 'Chọn nhà cung cấp',
                onChanged: (value) => {}),
            SizedBox(height: 20),
          ]));

  Widget _oneDoubleTime(BuildContext context, String label, DateTime? value,
          ValueChanged changeDate) =>
      Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text(label, style: p5.copyWith(color: blackColor))),
        SizedBox(height: sp12),
        InkWell(
          onTap: () async {
            final dates = await DialogUtils.showCalendarDatePicker(context);
            if (dates != null) changeDate(dates[0]!);
          },
          child: Row(children: [
            _oneDate(context, value, changeDate),
            SizedBox(width: sp12),
            _oneDate(context, value, changeDate),
          ]),
        )
      ]);

  Widget _oneDate(
          BuildContext context, DateTime? value, ValueChanged changeDate) =>
      Expanded(
          child: InkWell(
              onTap: () async {
                final dates = await DialogUtils.showCalendarDatePicker(context);
                if (dates != null) changeDate(dates[0]!);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: sp12, horizontal: sp16),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: borderColor_2),
                      borderRadius: BorderRadius.circular(sp8)),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                            value == null
                                ? 'Từ ngày'
                                : Date.formatDateDay(value),
                            style: p6.copyWith(color: blackColor))),
                    SizedBox(width: sp12),
                    Icon(Icons.calendar_month, size: sp20, color: greyColor)
                  ]))));
}
