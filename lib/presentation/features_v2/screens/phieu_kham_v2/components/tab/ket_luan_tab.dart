import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/phieu_kham_v2/components/bts_benh.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/avatar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/button/label_button.dart';
import '../../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/phieu_kham_v2/create_phieu_kham_bloc.dart';
import '../../../../blocs/phieu_kham_v2/param/create_phieu_kham_param.dart';
import '../../../../models/order/order_detail_v2_model.dart';

class KetLuanTab extends StatefulWidget {
  const KetLuanTab({
    super.key,
    required this.model,
    required this.param,
    required this.bloc,
  });

  final OrderDetailV2Model model;
  final CreatePhieuKhamParam param;
  final CreatePhieuKhamBloc bloc;

  @override
  State<KetLuanTab> createState() => _KetLuanTabState();
}

class _KetLuanTabState extends State<KetLuanTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CreatePhieuKhamBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: 24.padingTop + 16.padingHor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomer(),
              16.height,
              _buildBenh(),
              16.height,
              InputColumn(
                label: 'Kết luận',
                padding: 0.pading,
                minLines: 5,
                onChanged: (value) {
                  widget.param.conclusion = value;
                },
              ),
              16.height,
              InputColumn(
                label: 'Ghi chú',
                padding: 0.pading,
                minLines: 5,
                onChanged: (value) {
                  widget.param.note = value;
                },
              ),
              24.height,
              context.padding.bottom.height,
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AvatarCustom(url: ''),
            16.width,
            Text(
              widget.model.customer?.prefixName ?? '',
              style: AppStyle.bodyBsSemiBold,
            ).expanded(),
          ],
        ),
        12.height,
        Text(
          'Dịch vụ',
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
          ),
        ),
        4.height,
        Text(
          widget.model.services
              .map((e) => e.service?.title.validator)
              .join(', '),
          style: AppStyle.bodyBsMedium,
        ),
        4.height,
        TextRow2(
          title: 'Thời gian khám',
          content: widget.model.createdAt.fomatDefaulft,
        ),
      ],
    ).container(
      padding: 16.pading,
      boxShadow: AppShadows.elevator0,
      radius: 16,
    );
  }

  Widget _buildList() {
    if (widget.bloc.benhs.isEmpty) {
      return const SizedBox();
    }
    final list = widget.bloc.benhs
        .map(
          (model) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.width,
              Text(
                '${model.code}-${model.nameVn}',
                style: AppStyle.bodyBsRegular,
              ).padding(6.padingVer).flexible(),
              IconBtn(
                onTap: () {
                  widget.bloc.removeById(model.id ?? -1);
                },
                backgroundColor: AppColors.bg_primary,
                size: const Size(32, 32),
                padding: 0.pading,
                icon: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.text_quaternary,
                ),
              ),
            ],
          ).container(
            radius: 4,
            padding: 0.padingHor,
            border: Border.all(color: AppColors.border_tertiary),
          ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Chẩn đoán',
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.input_label,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_brand_primary_variant2,
                ),
              ),
            ],
          ),
        ),
        12.height,
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 12,
          spacing: 12,
          children: [
            ...list,
            InkWell(
              onTap: () {
                context.bottomSheet(
                  BtsBenh(
                    models: widget.bloc.benhs,
                    onSelected: (value) {
                      widget.bloc.benhs = value;
                    },
                  ),
                );
              },
              child: ChipDashBorder(
                color: AppColors.ultility_gray_40,
                title: 'Thêm chẩn đoán',
                padding: 8.padingHor + 2.padingVer,
                radius: const Radius.circular(6),
                suffixIcon: const Icon(
                  Icons.add,
                  size: 14,
                  color: AppColors.ultility_gray_40,
                ).padding(2.padingLeft),
                titleStyle: AppStyle.bodyBsRegular,
              ).size(height: 40, width: 150),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildBenh() {
    return Column(
      children: [
        if (widget.bloc.benhs.isEmpty)
          ColumnLabelButton(
            title: 'Chẩn đoán',
            label: 'Chẩn đoán',
            isRequire: true,
            backgroundColor: AppColors.bg_primary,
            border: const BorderSide(
              color: AppColors.button_neutral_outlined_borderDefault,
            ),
            labelStyle: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.button_neutral_outlined_textDefault,
            ),
            suffixIcon: const Icon(
              Icons.add,
              size: 17,
              color: AppColors.button_neutral_outlined_textDefault,
            ),
            onPressed: () {
              context.bottomSheet(
                BtsBenh(
                  models: widget.bloc.benhs,
                  onSelected: (value) {
                    widget.bloc.benhs = value;
                  },
                ),
              );
            },
          ),
        16.height,
        _buildList(),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
