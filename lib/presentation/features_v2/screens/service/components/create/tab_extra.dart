import 'package:flutter/material.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/components/input/input_column.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../blocs/service/bloc_index.dart';

class TabExtraCreateService extends StatefulWidget {
  final CreateServiceV2Bloc bloc;
  const TabExtraCreateService({
    super.key,
    required this.bloc,
  });

  @override
  State<TabExtraCreateService> createState() => _TabExtraCreateServiceState();
}

class _TabExtraCreateServiceState extends State<TabExtraCreateService>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputColumn(
            label: 'Thời gian thực hiện (phút)',
            hintText: '00:00',
            textInputType: TextInputType.number,
            padding: 0.pading,
          ),
          16.height,
          DropDownColumn(
            label: 'Danh mục',
            padding: 0.pading,
            onChanged: (p0) {},
          ),
          16.height,
          InputColumn(
            label: 'Công dụng',
            minLines: 5,
            padding: 0.pading,
            initialValue: widget.bloc.additional.congDung,
            onChanged: (p0) {
              widget.bloc.additional.congDung = p0;
            },
          ),
          16.height,
          InputColumn(
            label: 'Đối tượng',
            minLines: 5,
            padding: 0.pading,
            initialValue: widget.bloc.additional.entity,
            onChanged: (p0) {
              widget.bloc.additional.entity = p0;
            },
          ),
          16.height,
          InputColumn(
            label: 'Chỉ định',
            hintText: 'VD: Đau dạ dày',
            minLines: 5,
            padding: 0.pading,
            initialValue: widget.bloc.additional.chiDinh,
            onChanged: (p0) {
              widget.bloc.additional.chiDinh = p0;
            },
          ),
          16.height,
          InputColumn(
            label: 'Chống chỉ định',
            hintText: 'VD: Viêm gan',
            minLines: 5,
            padding: 0.pading,
            initialValue: widget.bloc.additional.chongChiDinh,
            onChanged: (p0) {
              widget.bloc.additional.chongChiDinh = p0;
            },
          ),
          16.height,
          InputColumn(
            label: 'Tác dụng phụ',
            minLines: 5,
            padding: 0.pading,
            initialValue: widget.bloc.additional.tacDungPhu,
            onChanged: (p0) {
              widget.bloc.additional.tacDungPhu = p0;
            },
          ),
          16.height,
          InputColumn(
            label: 'Lưu ý thận trọng',
            minLines: 5,
            padding: 0.pading,
            initialValue: widget.bloc.additional.luuY,
            onChanged: (p0) {
              widget.bloc.additional.luuY = p0;
            },
          ),
          16.height,
          context.padding.bottom.height,
        ],
      ),
    );
  }

  Widget createCategory() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const Icon(
        //   Icons.keyboard_arrow_down_rounded,
        // ),
        FaIcon(
          iconCode: 'f0d7',
          type: FaIconType.solid,
        ),
        8.width,
        const VerticalDivider(
          color: AppColors.input_borderDefault,
          thickness: 1,
          width: 0,
        ).size(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: LabelButton(
            label: 'Tạo mới',
            labelStyle: AppStyle.bodySmMedium.copyWith(
              color: AppColors.button_neutral_ghost_textDefault,
            ),
            padding: 12.padingHor,
            radius: 8.radiusRight,
            fixedSize: const Size(double.infinity, 46),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
