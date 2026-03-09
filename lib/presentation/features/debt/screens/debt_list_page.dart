import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_cubit.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../../../base/app_bar.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../cubit/debt_list_cubit/debt_list_cubit.dart';
import '../cubit/debt_list_cubit/debt_list_state.dart';
import '../domain/entities/debt_note_entity.dart';
import '../widgets/chart_debt_report.dart';

enum DebtNoteStatus {
  OPEN('OPEN', 'Chưa thanh toán', greyTextColor, borderColor_2),
  OVERDUE('OVERDUE', 'Quá hạn', red_1, red_2),
  REPAYING('REPAYING', 'Thanh toán 1 phần', blue_1, blue_2),
  SETTLED('SETTLED', 'Hoàn thành', green_1, green_2),
  ;

  final String code;
  final String title;
  final Color color;
  final Color backgroundColor;
  const DebtNoteStatus(
    this.code,
    this.title,
    this.color,
    this.backgroundColor,
  );
}

@RoutePage()
class DebtListPage extends StatefulWidget {
  const DebtListPage({
    super.key,
    required this.debtType,
  });

  @override
  State<DebtListPage> createState() => _DebtListPageState();
  final DebtNoteType debtType;
}

class _DebtListPageState extends State<DebtListPage> {
  final _debtListCubit = getIt.get<DebtListCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DebtListCubit>(
      create: (context) => _debtListCubit
        ..init(debtType: widget.debtType)
        ..report(),
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title:
              'Danh sách ${widget.debtType == DebtNoteType.REVENUE ? DebtNoteType.REVENUE.title.toLowerCase() : DebtNoteType.EXPENSE.title.toLowerCase()}',
        ),
        body: Container(
          width: widthDevice(context),
          height: heightDevice(context),
          padding: const EdgeInsets.symmetric(
            vertical: sp24,
            horizontal: sp16,
          ),
          child: Column(
            children: [
              _sessionReport(),
              gapHeight(sp24),
              Expanded(
                child: _sessionList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sessionReport() {
    return BlocBuilder<DebtListCubit, DebtListState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng quan',
                  style: p1.copyWith(color: blackColor),
                ),
                IconButton(
                  onPressed: () async {
                    await context.navPush(
                      DebtCreateRoute(
                        debtType: widget.debtType,
                        onSuccess: () => _debtListCubit.ilc.onRefresh(),
                      ),
                    );
                    _debtListCubit.ilc.onRefresh();
                    _debtListCubit.report();
                  },
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200 + sp16,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(sp12),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.1),
                          blurRadius: sp2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: sp12),
                          title: Text(
                            '${FormatCurrency(
                              state.report?.revenue
                                  ?.firstWhere(
                                    (e) =>
                                        e.type == DebtNoteStatus.SETTLED.code,
                                  )
                                  .money,
                            )}đ',
                            style: h4.copyWith(color: mainColor),
                          ),
                          subtitle: Text(
                            'Đã thanh toán',
                            style: p5.copyWith(color: greyTextColor),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: greyTextColor,
                            size: sp20,
                          ),
                        ),
                        // gapHeight(sp12),
                        (state.report?.chart?.isEmpty ?? true)
                            ? const BaseLoading()
                            : ChartDebtReportView(
                                data: state.report?.chart ?? [],
                              ),
                      ],
                    ),
                  ),
                ),
                gapWidth(sp16),
                Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(sp12),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(sp12),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.1),
                            blurRadius: sp2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.report?.revenue
                                      ?.firstWhere(
                                        (e) =>
                                            e.type == DebtNoteStatus.OPEN.code,
                                      )
                                      .quantity
                                      .toString() ??
                                  '0',
                              style: h2.copyWith(color: yellow_1),
                            ),
                            Text(
                              'Chưa thanh toán',
                              style: p9.copyWith(color: greyColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    gapHeight(sp16),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(sp12),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.1),
                            blurRadius: sp2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.report?.revenue
                                      ?.firstWhere(
                                        (e) =>
                                            e.type ==
                                            DebtNoteStatus.OVERDUE.code,
                                      )
                                      .quantity
                                      .toString() ??
                                  '0',
                              style: h2.copyWith(color: red_1),
                            ),
                            Text(
                              'Quá hạn',
                              style: p9.copyWith(color: greyColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _sessionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danh sách phiếu',
          style: p1,
        ),
        gapHeight(sp12),
        Expanded(
          child: InfiniteList<DebtNoteEntity>(
            physics: const BouncingScrollPhysics(),
            getData: (page) {
              return _debtListCubit.list(page, widget.debtType.code);
            },
            itemBuilder: (context, item, index) => _oneItem(item),
            scrollController: _debtListCubit.scrollController,
            infiniteListController: _debtListCubit.ilc,
            circularProgressIndicator: const BaseLoading(),
            noItemFoundWidget: const EmptyContainer(),
          ),
        ),
      ],
    );
  }

  Widget _oneItem(DebtNoteEntity item) {
    return InkWell(
      onTap: () async {
        await context.router.push(
          DebtDetailRoute(
            debtType: widget.debtType,
            id: item.id!,
          ),
        );
        _debtListCubit.ilc.onRefresh();
        _debtListCubit.report();
      },
      child: Container(
        padding: const EdgeInsets.all(sp16).copyWith(top: 0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(sp12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                item.title ?? '',
                style: h5,
              ),
              subtitle: Text(item.code ?? ''),
              contentPadding: EdgeInsets.zero,
            ),
            Visibility(
              visible: item.status != null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: sp2, horizontal: sp12),
                decoration: BoxDecoration(
                  color: item.statusData?.backgroundColor,
                  borderRadius: BorderRadius.circular(sp8),
                ),
                child: Text(
                  item.statusData?.title ?? '',
                  style: p5.copyWith(color: item.statusData?.color),
                ),
              ),
            ),
            gapHeight(sp12),
            Row(
              children: [
                const Text('Tổng tiền'),
                const Spacer(),
                Text(
                  '${FormatCurrency(item.money ?? 0)} VNĐ',
                  style: h6,
                ),
              ],
            ),
            gapHeight(sp8),
            Row(
              children: [
                const Text('Đã thanh toán'),
                const Spacer(),
                Text(
                  '${FormatCurrency(item.paymented ?? 0)} VNĐ',
                  style: h6,
                ),
              ],
            ),
            gapHeight(sp8),
            Row(
              children: [
                const Text('Còn lại'),
                const Spacer(),
                Text(
                  '${FormatCurrency((item.money ?? 0) - (item.paymented ?? 0))} VNĐ',
                  style: h6,
                ),
              ],
            ),
            gapHeight(sp8),
            Row(
              children: [
                const Text('Người tạo'),
                const Spacer(),
                Text(
                  item.userCreatedName ?? '',
                  style: h6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
