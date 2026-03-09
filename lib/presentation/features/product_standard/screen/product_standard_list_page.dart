import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/map_entry.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product_standard/cubit/product_standard_cubit.dart';
import 'package:pharmago/presentation/features/product_standard/cubit/product_standard_state.dart';
import 'package:pharmago/presentation/features/product_standard/domain/entities/product_standard_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

@RoutePage()
class ProductStandardListPage extends StatefulWidget {
  @override
  State<ProductStandardListPage> createState() =>
      _ProductStandardListPageState();
}

class _ProductStandardListPageState extends State<ProductStandardListPage> {
  final myBloc = getIt.get<ProductStandardCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: bg_5,
      appBar: BaseAppBar(title: 'Danh sách tiêu chuẩn', actions: [
        InkWell(
            onTap: () async {},
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: BoxDecoration(color: Colors.white),
                child: Icon(Icons.search, size: 27, color: bg_1))),
        InkWell(
            onTap: () async {
              await context.router.push(ProductStandardUpdateRoute());
              myBloc.entityILC.onRefresh();
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: BoxDecoration(color: Colors.white),
                child: Icon(Icons.add, size: 30, color: bg_1)))
      ]),
      body: Container(
          padding: const EdgeInsets.fromLTRB(sp16, 0, sp16, sp16),
          child: BlocProvider<ProductStandardCubit>(
              create: (context) => myBloc,
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child: BlocBuilder<ProductStandardCubit,
                              ProductStandardState>(
                          builder: (context, state) => Text(
                              "Tổng số tiêu chuẩn: ${state.total}",
                              style: p5.copyWith(color: blackColor)))),
                  const SizedBox(width: sp16),
                  InkWell(
                      onTap: () async => await DialogUtils.showBottomDialogText(
                          context, SearchPopup()),
                      child: Container(
                          padding: const EdgeInsets.all(sp16 + 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp8),
                            border: Border.all(
                              color: borderColor_2,
                            ),
                            color: whiteColor,
                          ),
                          child: IcSvg.img(IcSvg.iconFilter, color: greyColor)))
                ]),
                gapHeight(sp16),
                Expanded(
                  child: SingleChildScrollView(
                      controller: myBloc.scrollController,
                      child: Column(children: [
                        InfiniteList(
                            shrinkWrap: true,
                            getData: (page) => myBloc.getList(page),
                            itemBuilder: (context, item, index) =>
                                _oneItem(item),
                            scrollController: myBloc.scrollController,
                            infiniteListController: myBloc.entityILC,
                            circularProgressIndicator: const BaseLoading()),
                      ])),
                )
              ]))));

  Widget _oneItem(ProductStandardEntity item) => GestureDetector(
        onTap: () async {
          await context.router.push(ProductStandardDetailRoute(id: item.id!));
          myBloc.entityILC.onRefresh();
        },
        child: Container(
            padding: const EdgeInsets.all(sp16),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Tên tiêu chuẩn sản xuất',
                      style: p5.copyWith(color: blackColor)),
                  Text('Mã TCSX: ${item.name}',
                      style: p6.copyWith(color: accentColor_7)),
                ]),
                Container(
                    width: 32,
                    child: MenuEntry.buildSelection(_getMenus(item.id!)))
              ]),
              gapHeight(sp16),
              RowItem(
                  title: 'Số sản phẩm', content: item.valueExtra.toString()),
              gapHeight(sp12),
              RowItem(title: 'Người tạo', content: item.userCreatedName),
              gapHeight(sp12),
              RowItem(title: 'Thời gian tạo', content: item.createdAt),
              gapHeight(sp12),
            ])),
      );

  MenuEntry _getMenus(int id) => MenuEntry(
          labelWidget: Container(
              width: 8,
              child: const Icon(Icons.more_vert, color: blackColor, size: 25)),
          menuChildren: <MenuEntry>[
            MenuEntry(
                label: 'Chỉnh sửa tiêu chuẩn',
                onPressed: () =>
                    context.router.push(ProductStandardUpdateRoute(id: id))),
            MenuEntry(
                label: 'Xoá tiêu chuẩn',
                onPressed: () => myBloc.delete(context, id, false))
          ]);
}

class SearchPopup extends StatefulWidget {
  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  String _valueCheck = "";
  void onChangeValue(content) => setState(() {
        _valueCheck = _valueCheck != content ? content : "";
      });

  Widget oneRadio(String content) => GestureDetector(
      onTap: () => onChangeValue(content),
      child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Row(children: [
            Theme(
                data: ThemeData(unselectedWidgetColor: blue_1),
                child: Radio<String>(
                    activeColor: blue_1,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: content,
                    groupValue: _valueCheck == content ? _valueCheck : "",
                    onChanged: (value) => onChangeValue(content))),
            Expanded(child: Text(content, style: p6))
          ])));

  var options = [
    "Ngày tạo gần nhất",
    "Ngày tạo xa nhất",
    "Ngày cập nhật gần nhất",
    "Ngày cập nhật xa nhất",
    "Số sản phẩm giảm dần",
    "Số sản phẩm tăng dần",
  ];

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
            Container(
                alignment: Alignment.centerLeft,
                child: Text('Xắp xếp theo', style: p5)),
            // SizedBox(height: 8),
            Column(children: [
              for (final String option in options) oneRadio(option)
            ]),
            SizedBox(height: 12),
            _oneDoubleTime(
                context, 'Thời gian tạo', DateTime.now(), (value) => {}),
            SizedBox(height: 12),
            _oneDoubleTime(
                context, 'Thời gian cập nhật', DateTime.now(), (value) => {}),
            SizedBox(height: 20),
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
