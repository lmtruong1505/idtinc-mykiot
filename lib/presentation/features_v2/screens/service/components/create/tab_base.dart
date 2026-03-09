import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/button/switch_label.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../blocs/service/bloc_index.dart';

class TabBaseCreateService extends StatefulWidget {
  final CreateServiceV2Bloc bloc;
  const TabBaseCreateService({
    super.key,
    required this.bloc,
  });

  @override
  State<TabBaseCreateService> createState() => _TabBaseCreateServiceState();
}

class _TabBaseCreateServiceState extends State<TabBaseCreateService>
    with AutomaticKeepAliveClientMixin {
  final vatController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<int> vats = [0, 5, 8, 10];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: 16.pading,
      child: Form(
        key: widget.bloc.baseKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputColumn(
              label: 'Tên dịch vụ',
              isRequired: true,
              padding: 0.pading,
              initialValue: widget.bloc.baseService.title,
              onChanged: (p0) {
                widget.bloc.setTitle(p0);
              },
            ),
            16.height,
            InputColumn(
              label: 'Mã dịch vụ',
              padding: 0.pading,
              initialValue: widget.bloc.baseService.code,
              onChanged: (p0) {
                widget.bloc.baseService.code = p0;
              },
            ),
            16.height,
            InputColumn(
              label: 'Mô tả',
              minLines: 5,
              padding: 0.pading,
              initialValue: widget.bloc.baseService.description,
              onChanged: (p0) {
                widget.bloc.baseService.description = p0;
              },
            ),
            16.height,
            DropDownColumn(
              label: 'Thuế VAT',
              padding: 0.pading,
              hintText: 'Chọn thuế VAT',
              prefixIcon: FaIcon(
                iconCode: '25',
                color: AppColors.input_iconDefault,
              ).padding(16.padingLeft),
              value: vats.firstWhere(
                (element) => widget.bloc.baseService.vat == element,
                orElse: () => 0,
              ),
              items: vats
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        '$e%',
                        style: AppStyle.bodyBsRegular,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p0) {
                widget.bloc.baseService.vat = p0;
              },
            ),
            16.height,
            SwitchLabel(
              label: 'Trạng thái hoạt động',
              value: widget.bloc.baseService.active ?? false,
              onChanged: (p0) {
                widget.bloc.baseService.active = p0;
              },
            ),
            context.padding.bottom.height,
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
