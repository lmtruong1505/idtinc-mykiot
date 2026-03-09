import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_cubit.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_state.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../conversation/cubit/conversation_cubit/conversation_cubit.dart';

@RoutePage()
class CustomerListPage extends StatefulWidget {
  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final myBloc = getIt.get<CustomerCubit>();

  @override
  Widget build(BuildContext context) => BlocProvider<CustomerCubit>(
        create: (context) => myBloc,
        child: BlocBuilder<CustomerCubit, CustomerState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: bg_5,
              appBar: const BaseAppBar(
                title: 'Quản lý khách hàng',
              ),
              body: Container(
                padding: const EdgeInsets.all(sp16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Thêm mới',
                        largeButton: false,
                        event: () async {
                          await context.router.push(CustomerUpdateRoute());
                          myBloc.entityILC.onRefresh();
                        },
                      ),
                    ),
                    gapHeight(sp16),
                    Row(
                      children: [
                        Expanded(
                          child: AppInputSupport(
                            hintText: 'Tìm kiếm khách hàng',
                            radius: sp12,
                            backgroundColor: whiteColor,
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            onChanged: myBloc.changeSearch,
                          ),
                        ),
                        gapWidth(sp12),
                        InkWell(
                          onTap: () async => DialogUtils.showBottomDialogText(
                            context,
                            SearchPopup(),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(sp16 + 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp12),
                              border: Border.all(
                                color: borderColor_2,
                              ),
                              color: whiteColor,
                            ),
                            child: IcSvg.img(
                              IcSvg.iconFilter,
                              color: greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapHeight(sp16),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: myBloc.scrollController,
                        child: InfiniteList(
                          shrinkWrap: true,
                          getData: (page) => myBloc.getList(page),
                          itemBuilder: (context, item, index) => _oneItem(item),
                          scrollController: myBloc.scrollController,
                          infiniteListController: myBloc.entityILC,
                          circularProgressIndicator: const BaseLoading(),
                          noItemFoundWidget: const EmptyContainer(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Widget _oneItem(CustomerEntity item) => GestureDetector(
        onTap: () async {
          await context.router.push(
            ConversationRoute(
              customerId: item.id,
              conversation: item.conversation,
              cubit: getIt.get<ConversationCubit>()
                ..listConversation()
                ..initRealtimeMessage(),
            ),
          );
          // await context.router.push(CustomerDetailRoute(id: item.id!));
          myBloc.entityILC.onRefresh();
        },
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp8),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(sp16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.name}', style: p3),
                        gapHeight(sp8),
                        Text('${item.code}', style: p6),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${FormatCurrency(item.revenue)}đ',
                          style: p5.copyWith(color: mainColor),
                        ),
                        gapHeight(sp8),
                        Text(
                          '(${FormatCurrency(item.orders)} đơn hàng)',
                          style: p5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: sp0, color: borderColor_2),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: sp8,
                  horizontal: sp16,
                ),
                child: Text(
                  item.conversation?.lastMessage?.content == null
                      ? 'Chưa tương tác Zalo OA'
                      : 'Tin nhắn: ${item.conversation?.lastMessage?.content}',
                  style: p5.copyWith(
                    color: item.conversation?.lastMessage?.content == null
                        ? greyColor
                        : blue_1,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class SearchPopup extends StatefulWidget {
  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup> {
  String _valueCheck = '';

  void onChangeValue(content) => setState(() {
        _valueCheck = _valueCheck != content ? content : '';
      });

  Widget oneRadio(String content) => GestureDetector(
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
  Widget build(BuildContext context) => Container(
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

  Widget _oneDoubleTime(
    BuildContext context,
    String label,
    DateTime? value,
    ValueChanged changeDate,
  ) =>
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

  Widget _oneDate(
    BuildContext context,
    DateTime? value,
    ValueChanged changeDate,
  ) =>
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
