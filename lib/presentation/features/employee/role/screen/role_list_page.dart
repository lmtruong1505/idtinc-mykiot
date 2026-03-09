import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_cubit.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_state.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/role_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

@RoutePage()
class RoleListPage extends StatefulWidget {
  @override
  State<RoleListPage> createState() => _RoleListPageState();
}

class _RoleListPageState extends State<RoleListPage> {
  final myBloc = getIt.get<RoleCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title: 'Danh sách vai trò',
          actions: [
            InkWell(
              onTap: () async {},
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: const BoxDecoration(color: Colors.white),
                child: const Icon(Icons.search, size: 27, color: bg_1),
              ),
            ),
            InkWell(
              onTap: () async {
                await context.router.push(RoleUpdateRoute());
                myBloc.entityILC.onRefresh();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: const BoxDecoration(color: Colors.white),
                child: const Icon(Icons.add, size: 30, color: bg_1),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(sp16, 0, sp16, sp16),
          child: BlocProvider<RoleCubit>(
            create: (context) => myBloc,
            child: BlocBuilder<RoleCubit, RoleState>(
              builder: (context, state) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tổng số vai trò: ${state.total}',
                          style: p5.copyWith(color: blackColor),
                        ),
                      ),
                      const SizedBox(width: sp16),
                      InkWell(
                        onTap: () async => DialogUtils.showBottomDialogText(
                          context,
                          SearchPopup(),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(sp16 + 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp8),
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _oneItem(RoleEntity item) => GestureDetector(
        onTap: () async {
          await context.router.push(RoleDetailRoute(id: item.id!));
          myBloc.entityILC.onRefresh();
        },
        child: Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên vai trò: ${item.title}',
                        style: p6.copyWith(color: blackColor),
                      ),
                      Text(
                        '150 nhân viên',
                        style: p5.copyWith(color: borderColor_4),
                      ),
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
              gapHeight(sp16),
              gapHeight(sp16),
              RowItem(title: 'Người tạo', content: item.userCreatedName),
              gapHeight(sp12),
              const RowItem(
                title: 'Thời gian tạo',
                content: '10:11 11-02-2022',
              ),
              gapHeight(sp12),
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
            gapHeight(sp12),
            _oneDoubleTime(context, 'Thời gian tạo', null, (value) => {}),
            gapHeight(sp12),
            _oneDoubleTime(context, 'Thời gian cập nhật', null, (value) => {}),
            gapHeight(sp20),
            gapHeight(sp20),
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
                _oneDate(context, value, changeDate, 'Từ ngày'),
                const SizedBox(width: sp12),
                _oneDate(context, value, changeDate, 'Đến ngày'),
              ],
            ),
          ),
        ],
      );

  Widget _oneDate(
    BuildContext context,
    DateTime? value,
    ValueChanged changeDate,
    String textDefault,
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
                    value == null ? textDefault : Date.formatDateDay(value),
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
