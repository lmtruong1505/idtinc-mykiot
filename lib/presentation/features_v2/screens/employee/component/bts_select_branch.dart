import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/load_more_bloc.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../shared/utils/delay_callback.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../di/di.dart';
import '../../../../features/company/domain/entities/company_entity.dart';
import '../../../blocs/employee/select_branch_bloc.dart';
import 'branch_item.dart';

class BtsSelectBranch extends StatefulWidget {
  const BtsSelectBranch({super.key, this.id, this.onSelected});

  final int? id;
  final Function(CompanyEntity)? onSelected;

  @override
  State<BtsSelectBranch> createState() => _BtsSelectBranchState();
}

class _BtsSelectBranchState extends State<BtsSelectBranch> {
  final branchBloc = getIt<SelectBranchBloc>();
  final delay = DelayCallBack(delay: 500.milliseconds);

  int? selectedId;
  final textCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    branchBloc.getList(
      isAll: true,
    );
    scrollCtrl.onMore(() {
      branchBloc.getList(isAll: true, isMore: true);
    });

    selectedId = widget.id;
    super.initState();
  }

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Chọn cơ sở',
      needBottom: false,
      controller: scrollCtrl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearch(),
          16.height,
          _buildHeaderList(),
          16.height,
          _buildList(),
        ],
      ),
    );
  }

  _buildSearch() {
    return AppInputV2(
      hintText: 'Tìm kiếm tên cơ sở',
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      controller: textCtrl,
      suffixIcon: InkWell(
        onTap: () {
          textCtrl.clear();
          branchBloc.getList(
            isAll: true,
            search: '',
          );
        },
        child: const Icon(
          Icons.clear_outlined,
          size: 16,
        ),
      ),
      radius: 40,
      contentPadding: 12.padingHor,
      onChanged: (value) {
        delay.debounce(() {
          branchBloc.getList(
            isAll: true,
            search: value,
          );
        });
      },
    ).size(height: 40);
  }

  _buildHeaderList() {
    return Row(
      children: [
        Text(
          'Danh sách',
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        8.width,
        const Divider(
          thickness: 1,
          color: AppColors.border_tertiary,
        ).expanded(),
      ],
    );
  }

  _buildList() {
    return BlocBuilder<SelectBranchBloc, CubitState>(
      bloc: branchBloc,
      builder: (context, state) {
        // if (state.status == BlocStatus.loading && branchBloc.list.isEmpty) {
        //   return const Center(
        //     child: BaseLoading(),
        //   );
        // }
        // if(branchBloc.list.isEmpty) {
        //   return const EmptyContainer(msg: 'Không tìm thấy',);
        // }

        return LoadMoreListBloc(
          state: state,
          padding: 0.pading,
          separatorBuilder: const Divider(
            thickness: 1,
            color: AppColors.border_tertiary,
          ),
          itemBuilder: (context, item, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedId = branchBloc.list[index].id;
                });
                widget.onSelected?.call(branchBloc.list[index]);
                context.pop();
              },
              child: ItemBranch(
                isActive: branchBloc.list[index].id == selectedId,
                branch: branchBloc.list[index],
              ),
            );
          },
          list: branchBloc.list,
          height: 200,
          emptyView: const EmptyContainer(
            msg: 'Không tìm thấy',
          ),
        );
      },
    );
  }
}
