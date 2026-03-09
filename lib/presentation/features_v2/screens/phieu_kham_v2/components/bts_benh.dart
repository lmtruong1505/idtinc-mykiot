import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham_v2/list_benh_bloc.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/bg/bg_bts.dart';
import '../../../../../shared/components/input/app_input.dart';
import '../../../../../shared/components/widgets/load_more_bloc.dart';
import '../../../../base/empty_container.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../blocs/state/cubit_state.dart';

class BtsBenh extends StatefulWidget {
  const BtsBenh({super.key, required this.models, this.onSelected});

  final List<BasicModel> models;
  final Function(List<BasicModel>)? onSelected;

  @override
  State<BtsBenh> createState() => _BtsBenhState();
}

class _BtsBenhState extends State<BtsBenh> {
  final bloc = ListBenhBloc();
  List<BasicModel> benhs = [];
  final scrollCtrl = ScrollController();
  final textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.getList();
    benhs = widget.models;
    scrollCtrl.onMore(() {
      bloc.getList(isMore: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Chẩn đoán bệnh',
      needBottom: true,
      controller: scrollCtrl,
      cancelText: 'Hủy',
      confirmText: 'Xác nhận',
      onCancel: () {
        context.pop();
      },
      subChild: benhs.isEmpty ? null : _buildCount(),
      onConfirm: () {
        widget.onSelected?.call(benhs);
        context.pop();
      },
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

  SizedBox _buildSearch() {
    return AppInputV2(
      hintText: 'Tìm kiếm',
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.input_iconDefault,
      ),
      controller: textCtrl,
      suffixIcon: InkWell(
        onTap: () {
          textCtrl.clear();
          bloc.search('');
          bloc.getList();
        },
        child: const Icon(
          Icons.clear_outlined,
          size: 16,
        ),
      ),
      radius: 40,
      contentPadding: 12.padingHor,
      onChanged: (value) {
        bloc.search(value);
      },
    ).size(height: 40);
  }

  Row _buildHeaderList() {
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

  BlocBuilder<ListBenhBloc, CubitState> _buildList() {
    return BlocBuilder<ListBenhBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return LoadMoreListBloc(
          state: state,
          padding: 0.pading,
          separatorBuilder: 0.height,
          itemBuilder: (context, item, index) {
            final item = bloc.list[index];
            final bool isSelected = checkIfSelected(item.id ?? -1);
            return InkWell(
              onTap: () {
                print('onTap $isSelected');
                if (isSelected) {
                  benhs.removeWhere((element) => element.id == item.id);
                } else {
                  benhs.add(item);
                }
                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    '${bloc.list[index].code}-${bloc.list[index].nameVn}',
                    style: isSelected
                        ? AppStyle.bodyBsMedium.copyWith(
                            color: AppColors.text_secondary,
                          )
                        : AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.text_secondary,
                          ),
                  ).expanded(),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.fg_positive,
                      size: 16,
                    ),
                ],
              )
                  .container(
                    radius: 6,
                    padding: 8.padingHor + 6.padingVer,
                    bgColor: isSelected
                        ? AppColors.bg_primary_active
                        : AppColors.bg_primary,
                  )
                  .padding(4.pading),
            );
          },
          list: bloc.list,
          height: 200,
          emptyView: const EmptyContainer(
            msg: 'Không tìm thấy',
          ),
        );
      },
    );
  }

  bool checkIfSelected(int id) {
    return benhs.any((element) => element.id == id);
  }

  Container _buildCount() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border_tertiary,
            width: 1,
          ),
        ),
      ),
      margin: 16.padingHor,
      padding: 12.padingTop + 8.padingBottom,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Đã chọn: ',
              style: AppStyle.bodyBsRegular
                  .copyWith(color: AppColors.text_tertiary),
            ),
            TextSpan(
              text: '(${benhs.length})',
              style: AppStyle.headingMd,
            ),
          ],
        ),
      ),
    );
  }
}
