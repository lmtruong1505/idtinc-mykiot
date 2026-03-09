import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/extra_create_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/app_input.dart';
import '../../../../features/product/data/models/basic_model.dart';
import '../../../blocs/enum/bloc_status.dart';
import 'dialog_create_extra.dart';

class BtsChoseExtra extends StatefulWidget {
  const BtsChoseExtra({
    super.key,
    required this.type,
    required this.onChose,
    this.id = -1,
  });

  final ExtraType type;
  final Function(BasicModel) onChose;
  final int id;

  @override
  State<BtsChoseExtra> createState() => _BtsChoseExtraState();
}

class _BtsChoseExtraState extends State<BtsChoseExtra> {
  late final ExtraCreateBloc bloc;
  final ctrl = TextEditingController();

  @override
  void initState() {
    bloc = ExtraCreateBloc(widget.type);
    bloc.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Chọn ${widget.type.nameVn.toLowerCase()}',
      needBottom: false,
      child: Column(
        children: [
          AppInputV3(
            hintText: 'Tìm kiếm ${widget.type.nameVn.toLowerCase()}',
            extraOnTap: () {
              context.dialog(
                DialogCreateExtra(bloc: bloc),
              );
            },
            onChanged: (value) {
              bloc.search = value;
            },
            suffixIcon: InkWell(
              onTap: () {
                ctrl.clear();
                bloc.search = null;
              },
              child: const Icon(Icons.close_rounded),
            ),
            prefixIcon: const Icon(Icons.search),
            controller: ctrl,
            radius: 999,
          ).size(height: 40),
          16.height,
          Row(
            children: [
              Text(
                'Danh sách',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              8.width,
              const Divider(
                color: AppColors.border_tertiary,
                thickness: 1,
              ).expanded(),
            ],
          ),
          6.height,
          BlocBuilder<ExtraCreateBloc, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              if (state.status == BlocStatus.loading) {
                return const Center(child: BaseLoading());
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final bool isCheck = widget.id == bloc.list[index].id;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        widget.onChose(bloc.list[index]);
                        context.pop();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: 6.radius,
                        color: isCheck ? AppColors.bg_secondary : null,
                      ),
                      padding: 6.padingVer + 8.padingHor,
                      child: Row(
                        children: [
                          Text(bloc.list[index].name ?? '').expanded(),
                          isCheck
                              ? const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.fg_positive,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: bloc.list.length,
                shrinkWrap: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

enum ExtraType {
  brands('Thương hiệu'),
  categories('Danh mục'),
  types('Loại'),
  pharma('Công ty'),
  ;

  final String nameVn;

  const ExtraType(this.nameVn);
}
