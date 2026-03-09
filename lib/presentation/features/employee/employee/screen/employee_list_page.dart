import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../cubit/employee_cubit.dart';
import '../cubit/employee_state.dart';
import '../domain/entities/employee_entity.dart';

@RoutePage()
class EmployeeListPage extends StatefulWidget {
  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final myBloc = getIt.get<EmployeeCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title: 'Danh sách nhân viên',
          actions: [
            IconButton(
              onPressed: () async {
                await context.router.push(EmployeeUpdateRoute());
                myBloc.entityILC.onRefresh();
              },
              icon: const Icon(Icons.search, size: sp20, color: greyTextColor),
            ),
            IconButton(
              onPressed: () async {
                await context.router.push(EmployeeUpdateRoute());
                myBloc.entityILC.onRefresh();
              },
              icon: const Icon(Icons.add, size: sp20, color: greyTextColor),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(sp16, 0, sp16, sp16),
          child: BlocProvider<EmployeeCubit>(
            create: (context) => myBloc,
            child: BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tổng số nhân viên: ${state.total}',
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
                        noItemFoundWidget: const EmptyContainer(),
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

  Widget _oneItem(EmployeeEntity item) => GestureDetector(
        onTap: () async {
          await context.router.push(EmployeeDetailRoute(id: item.id!));
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
                  Text(
                    '${item.fullName}',
                    style: p3.copyWith(color: blackColor),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: sp4,
                      horizontal: sp8,
                    ),
                    decoration: const BoxDecoration(
                      color: green_2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(sp8),
                      ),
                    ),
                    child: Text(
                      'Hoạt động',
                      style: p9.copyWith(color: green_1),
                    ),
                  ),
                ],
              ),
              gapHeight(sp16),
              const RowItem(title: 'Vai trò', content: 'Nhân viên'),
              gapHeight(sp8),
              RowItem(title: 'Số điện thoại', content: item.username ?? ''),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
                    color: Colors.transparent,
                    child: Text('Đặt lại', style: p3.copyWith(color: blue_1)),
                  )),
              Text('Bộ lọc', style: p3),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 5, 16),
                    color: Colors.transparent,
                    child: Text('Áp dụng', style: p3.copyWith(color: blue_1)),
                  ))
            ]),
            gapHeight(sp12),
            Container(
                alignment: Alignment.centerLeft,
                child: Text('Xắp xếp theo', style: p5)),
            // SizedBox(height: 8),
            Column(children: [
              for (final String option in options) oneRadio(option)
            ]),
            gapHeight(sp12),
            CommonDropdown(
              label: 'Vai trò',
              items: [
                DropdownMenuItem(value: 0, child: Text('Vai trò 1', style: p6)),
                DropdownMenuItem(value: 1, child: Text('Vai trò 2', style: p6)),
              ],
              // value: 0,
              hintText: 'Chọn vai trò', onChanged: (p0) {},
            ),
            gapHeight(sp12),
            CommonDropdown(
              label: 'Trạng thái',
              items: [
                DropdownMenuItem(
                    value: 0, child: Text('Trạng thái 1', style: p6)),
                DropdownMenuItem(
                    value: 1, child: Text('Trạng thái 2', style: p6)),
              ],
              // value: 0,
              hintText: 'Chọn trạng thái', onChanged: (p0) {},
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
          ]));
}
