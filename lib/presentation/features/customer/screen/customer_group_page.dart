import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_group_entity.dart';

import '../../../base/date.dart';
import '../../../base/dialog.dart';
import '../../../base/empty_container.dart';
import '../../../base/loading.dart';
import '../../../base/svg.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/customer_group_cubit/customer_group_cubit.dart';

@RoutePage()
class CustomerGroupPage extends StatefulWidget {
  const CustomerGroupPage({super.key});

  @override
  State<CustomerGroupPage> createState() => _CustomerGroupPageState();
}

class _CustomerGroupPageState extends State<CustomerGroupPage> {
  final myBloc = getIt.get<CustomerGroupCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title: 'Nhóm khách hàng',
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () async {
                await context.router.push(CustomerGroupCreateRoute(id: null));
                myBloc.customerGroupsILC.onRefresh();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: sp16,
            vertical: sp16,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              myBloc.customerGroupsILC.onRefresh();
            },
            child: SingleChildScrollView(
              controller: myBloc.scrollController,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Tổng số nhóm khách hàng: 999',
                      ),
                      const Spacer(),
                      Text(
                        'Bộ lọc',
                        style: h6.copyWith(color: blackColor),
                      ),
                      gapWidth(sp8),
                      InkWell(
                        onTap: () async =>
                            DialogUtils.showBottomDialogText(
                              context,
                              SearchPopup(),
                            ),
                        child: SizedBox(
                          child: IcSvg.asset('/noti/filter.svg'),
                        ),
                      ),
                    ],
                  ),
                  gapHeight(sp16),
                  InfiniteList(
                    shrinkWrap: true,
                    getData: (page) async {
                      return myBloc.listCustomerGroups(page);
                    },
                    itemBuilder: (BuildContext context, item, index) {
                      return InkWell(
                        onTap: () async {
                          await context.router.push(
                            CustomerGroupDetailRoute(id: item.id!),
                          );
                          myBloc.customerGroupsILC.onRefresh();
                        },
                        child: _buildItem(context, item),
                      );
                    },
                    scrollController: myBloc.scrollController,
                    infiniteListController: myBloc.customerGroupsILC,
                    circularProgressIndicator: const BaseLoading(),
                    noItemFoundWidget: const EmptyContainer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, CustomerGroupEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
      ),
      padding: const EdgeInsets.only(
        left: sp16,
        right: sp16,
        top: 0,
        bottom: sp16,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text('${item.code}'),
            subtitle: Text('${item.name}'),
            contentPadding: EdgeInsets.zero,
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ),
          gapHeight(sp8),
          const RowItem(title: 'Tổng doanh thu', content: '15 tỷ'),
          gapHeight(sp8),
          const RowItem(title: 'Số lượng khách hàng', content: '1000'),
          gapHeight(sp8),
          const RowItem(title: 'Đơn hàng hoàn thành', content: '150000'),
          gapHeight(sp8),
          RowItem(title: 'Người tạo', content: '${item.userCreatedName}'),
        ],
      ),
    );
  }
}

class SearchPopup extends StatefulWidget {
  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  String _valueCheck = '';

  void onChangeValue(content) =>
      setState(() {
        _valueCheck = _valueCheck != content ? content : '';
      });

  Widget oneRadio(String content) =>
      GestureDetector(
        onTap: () => onChangeValue(content),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: blue_1),
                child: Radio<String>(
                  activeColor: blue_1,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: content,
                  groupValue: _valueCheck == content ? _valueCheck : '',
                  onChanged: (value) => onChangeValue(content),
                ),
              ),
              Expanded(child: Text(content, style: p6)),
            ],
          ),
        ),
      );

  var options = [
    'Ngày tạo gần nhất',
    'Ngày tạo xa nhất',
    'Ngày cập nhật gần nhất',
    'Ngày cập nhật xa nhất',
  ];

  @override
  Widget build(BuildContext context) =>
      Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
                    color: Colors.transparent,
                    child: Text('Đặt lại', style: p3.copyWith(color: blue_1)),
                  ),
                ),
                const Text('Bộ lọc', style: p3),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 5, 16),
                    color: Colors.transparent,
                    child: Text('Áp dụng', style: p3.copyWith(color: blue_1)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('Xắp xếp theo', style: p5),
            ),
            // SizedBox(height: 8),
            Column(
              children: [
                for (final String option in options) oneRadio(option),
              ],
            ),
            const SizedBox(height: 12),
            _oneDoubleTime(
              context,
              'Thời gian tạo',
              DateTime.now(),
                  (value) => {},
            ),
            const SizedBox(height: 12),
            _oneDoubleTime(
              context,
              'Thời gian cập nhật',
              DateTime.now(),
                  (value) => {},
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      );

  Widget _oneDoubleTime(BuildContext context,
      String label,
      DateTime? value,
      ValueChanged changeDate,) =>
      Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(label, style: p5.copyWith(color: blackColor)),
          ),
          const SizedBox(height: sp12),
          InkWell(
            onTap: () async {
              final dates = await DialogUtils.showCalendarDatePicker(context);
              if (dates != null) changeDate(dates[0]!);
            },
            child: Row(
              children: [
                _oneDate(context, value, changeDate),
                const SizedBox(width: sp12),
                _oneDate(context, value, changeDate),
              ],
            ),
          ),
        ],
      );

  Widget _oneDate(BuildContext context,
      DateTime? value,
      ValueChanged changeDate,) =>
      Expanded(
        child: InkWell(
          onTap: () async {
            final dates = await DialogUtils.showCalendarDatePicker(context);
            if (dates != null) changeDate(dates[0]!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: sp12,
              horizontal: sp16,
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: borderColor_2),
              borderRadius: BorderRadius.circular(sp8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value == null ? 'Từ ngày' : Date.formatDateDay(value),
                    style: p6.copyWith(color: blackColor),
                  ),
                ),
                const SizedBox(width: sp12),
                const Icon(Icons.calendar_month, size: sp20, color: greyColor),
              ],
            ),
          ),
        ),
      );
}
