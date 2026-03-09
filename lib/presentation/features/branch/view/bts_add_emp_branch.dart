import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/bloc_to_page.dart';
import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/style_text.dart';
import '../../../base/dialog.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../di/di.dart';
import '../../../features_v2/blocs/state/init_state.dart';
import '../bloc/branch_staff_bloc/list_staff_branch_bloc.dart';
import '../data/entities/branch_emp_entity.dart';

class BtsAddEmpBranch extends StatefulWidget {
  final List<int> staff;
  const BtsAddEmpBranch({
    super.key,
    required this.company,
    required this.staff,
  });

  final int company;

  @override
  State<BtsAddEmpBranch> createState() => _BtsAddEmpBranchState();
}

class _BtsAddEmpBranchState extends State<BtsAddEmpBranch>
    with SingleTickerProviderStateMixin {
  final myBloc = getIt.get<ListStaffBranchBloc>();
  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBloc.getList();
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
    return BlocProvider(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: ColorApp.white,
        appBar: AppBar(
          title: const Text(
            'Thêm nhân viên',
            style: TextStyle(
              color: ColorApp.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorApp.white,
          elevation: 0.0,
        ),
        body: Container(
          padding: 16.pading,
          child: Column(
            children: [
              _buildBtn().size(height: 50),
              16.height,
              _buildSearch(),
              16.height,
              _buildStaffs().expanded(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  Widget _buildBtn() {
    return BlocBuilder<ListStaffBranchBloc, CubitState>(
      builder: (context, state) {
        myBloc.list.removeWhere(
          (element) => widget.staff.contains(element.employee?.id),
        );
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var name = myBloc.selections[index].toName;
            if (index != 0) {
              name =
                  '$name (${myBloc.list.where((element) => element.isSelect).length})';
            }
            return InkWell(
              onTap: () {
                myBloc.changeSelection(myBloc.selections[index]);
              },
              child: customBtn(
                name,
                myBloc.selections[index] == myBloc.selection,
              ),
            );
          },
          separatorBuilder: (context, index) => 16.width,
          itemCount: myBloc.selections.length,
        );
      },
    );
  }

  Widget customBtn(String title, bool isSelected) {
    return Container(
      padding: 16.padingVer,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: isSelected
            ? const Border(
                bottom: BorderSide(
                  color: ColorApp.teal,
                  width: 2,
                ),
              )
            : null,
      ),
      child: Text(
        title,
        style: isSelected
            ? StyleApp.semibold(
                fontSize: 14,
                color: ColorApp.black,
              )
            : StyleApp.normal(
                fontSize: 14,
                color: ColorApp.black,
              ),
      ),
    );
  }

  Widget _buildSearch() {
    return AppInputSupport(
      hintText: 'Tìm kiếm tên, số điện thoại nhân viên',
      prefixIcon: const Icon(
        Icons.search_outlined,
      ),
      onChanged: (value) {
        myBloc.changeSearch(value);
      },
    );
  }

  Widget _buildStaffs() {
    return BlocBuilder<ListStaffBranchBloc, CubitState>(
      builder: (context, state) {
        var staffs = myBloc.list;
        if (myBloc.selection == SelectionType.selected) {
          staffs = staffs.where((element) => element.isSelect).toList();
        }
        return LoadListPage(
          state: state,
          listEmpty: staffs.isEmpty,
          child: ListView.separated(
            itemCount: staffs.length,
            separatorBuilder: (context, index) => 16.height,
            itemBuilder: (context, index) {
              final model = staffs[index];
              return InkWell(
                onTap: () {
                  if (myBloc.selection == SelectionType.list) {
                    myBloc.selectStaff(index);
                  }
                },
                child: _item(model, index),
              );
            },
          ).expanded(),
        );
      },
    );
  }

  Widget _item(BranchEmpEntity item, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: 8.radius,
        border: Border.all(
          color: item.isSelect ? ColorApp.main : borderColor_2,
        ),
      ),
      padding: 16.pading,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.employee?.fullName ?? '',
                style: StyleApp.semibold(fontSize: 16),
              ),
              4.height,
              Text(
                item.employee?.username ?? '',
                style: StyleApp.normal(fontSize: 14),
              ),
            ],
          ).expanded(),
          Visibility(
            visible: item.isSelect,
            child: const Icon(
              Icons.check_circle,
              color: ColorApp.main,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      padding: 16.pading,
      decoration: const BoxDecoration(
        color: ColorApp.white,
        boxShadow: [
          BoxShadow(
            color: ColorApp.greyE2,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          ExtraButton(
            title: 'Huỷ bỏ',
            event: () {
              Navigator.pop(context);
            },
          ).expanded(),
          16.width,
          MainButton(
            title: 'Xác nhận',
            event: _handleAddStaff,
          ).expanded(),
        ],
      ),
    );
  }

  void _handleAddStaff() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang thêm nhân viên vui lòng đợi',
    );
    myBloc.addStaff(widget.company).then((value) {
      context.pop();
      if (value.code == 200) {
        context.pop(result: true);
        DialogUtils.showSuccessDialog(
          context,
          content: 'Thêm nhân viên thành công',
          barrierDismissible: true,
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Thêm nhân viên thất bại ${value.message}',
        );
      }
    });
  }
}
