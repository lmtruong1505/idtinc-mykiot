import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/base_check_box.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/bloc_to_page.dart';
import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/style_text.dart';
import '../../../base/dialog.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../../features_v2/blocs/state/cubit_state.dart';
import '../bloc/branch_staff_bloc/list_staff_branch_bloc.dart';
import '../data/entities/branch_emp_entity.dart';
import 'bts_add_emp_branch.dart';

class StaffInfoView extends StatefulWidget {
  const StaffInfoView({super.key, required this.id});

  final int id;

  @override
  State<StaffInfoView> createState() => _StaffInfoViewState();
}

class _StaffInfoViewState extends State<StaffInfoView>
    with AutomaticKeepAliveClientMixin {
  final myBloc = getIt.get<ListStaffBranchBloc>();
  final scroll = ScrollController();

  var isShowBottomBar = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBloc.company = widget.id;
    scroll.onMore(
      () => myBloc.getList(isMore: true),
    );
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        MainButton(
          title: 'Thêm nhân viên vào cơ sở',
          event: () => context
              .bottomSheet(
            BtsAddEmpBranch(
              company: widget.id,
              staff: myBloc.list.map((e) => e.employee?.id ?? -1).toList(),
            ),
          )
              .then((value) {
            if (value == true) {
              myBloc.getList();
            }
          }),
        )
            .size(
              width: double.infinity,
            )
            .padding(16.padingHor + 16.padingTop),
        _buildListStaff().expanded(),
        _buildBottom(),
      ],
    );
  }

  Widget _buildListStaff() {
    return BlocBuilder<ListStaffBranchBloc, CubitState>(
      bloc: myBloc,
      builder: (context, state) {
        final count =
            myBloc.list.where((element) => element.isSelect).toList().length;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isShowBottomBar.value = count;
        });
        return RefreshIndicator(
          onRefresh: () async {
            await myBloc.getList();
          },
          child: LoadListPage(
            state: state,
            listEmpty: myBloc.list.isEmpty,
            child: ListView.separated(
              padding: sp16.pading,
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => _staffItem(
                myBloc.list[index],
                index,
              ),
              separatorBuilder: (context, index) => sp16.height,
              itemCount: myBloc.list.length,
            ).expanded(),
          ),
        );
      },
    );
  }

  Widget _staffItem(BranchEmpEntity item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
        border: Border.all(
          color: borderColor_2,
        ),
      ),
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BaseCheckbox(
                        value: item.isSelect,
                        onChanged: (value) {
                          myBloc.selectStaff(index);
                        },
                      ),
                      8.width,
                      Text(
                        item.employee?.fullName ?? '',
                        style: StyleApp.semibold(fontSize: 16),
                      ),
                    ],
                  ),
                  8.height,
                  Text(
                    item.employee?.username ?? '',
                    style: StyleApp.normal(
                      fontSize: 14,
                    ),
                  ),
                ],
              ).expanded(),
              const Icon(
                Icons.circle,
                size: 12,
                color: ColorApp.main,
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              const Icon(
                Icons.check,
                color: ColorApp.main,
                size: 16,
              ),
              12.width,
              Text(
                item.employee?.accountType ?? '',
                style: StyleApp.semibold(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _buildBottom() {
    return ValueListenableBuilder(
      valueListenable: isShowBottomBar,
      builder: (context, value, child) {
        if (value == 0) return const SizedBox();
        return Container(
          padding: 16.pading,
          decoration: const BoxDecoration(
            color: ColorApp.white,
            boxShadow: [
              BoxShadow(
                color: ColorApp.greyE2,
                blurRadius: 8,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đã chọn ($value)',
                style: StyleApp.normal(
                  fontSize: 16,
                  color: ColorApp.grey79,
                ),
              ),
              16.width,
              ExtraButton(
                title: 'Xóa khỏi cơ sở',
                backgroundColor: ColorApp.red,
                titleColor: ColorApp.white,
                event: () {
                  _handleRemoveStaff();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleRemoveStaff() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang xoá nhân viên vui lòng đợi',
    );
    myBloc.removeStaff(widget.id).then((value) {
      Navigator.pop(context);
      myBloc.getList();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Xoá nhân viên thành công',
          barrierDismissible: true,
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Xoá nhân viên thất bại ${value.message}',
        );
      }
    });
  }
}
