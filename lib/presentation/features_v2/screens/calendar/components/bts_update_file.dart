import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/local/file_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/item_benh_an.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../models/calendar/event_model.dart';

class BtsUpdateFile extends StatelessWidget {
  final EventModel event;
  BtsUpdateFile({required this.event});
  final fileBloc = FileBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets.bottom.padingBottom,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 16.radiusTop,
      ),
      child: SingleChildScrollView(
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thông tin khám bệnh',
              textAlign: TextAlign.center,
              style: StyleApp.semibold(
                color: ColorApp.grey47,
              ),
            ),
            16.height,
            AppInputV2(
              hintText: 'Nhập ghi chú/mô tả thăm khám',
              radius: 8,
              maxLines: 5,
            ),
            16.height,
            BlocBuilder<FileBloc, CubitState>(
              bloc: fileBloc,
              builder: (context, state) {
                return Column(
                  children: List.generate(
                    fileBloc.files.length,
                    (index) => ItemFile(
                      isLocal: true,
                      delete: () => fileBloc.remove(index),
                      item: FileModel(
                        url: fileBloc.files[index].path,
                        title: fileBloc.files[index].name,
                      ),
                    ),
                  ),
                );
              },
            ),
            MainButtonV2(
              title: 'Tải lên kết quả xét nghiệm và chẩn đoán',
              onTap: () {
                context.unFocus();
                fileBloc.chooseFile();
              },
            ),
            16.height,
            RowBtn(
              onCancel: () => context.pop(),
              onConfirm: () {
                fileBloc.uploadFile(
                  customerId: event.customerId ?? 0,
                  appointmentSchedule: event.uuid,
                  type: TypeFileCustomer.test.code,
                );
              },
            ),
            context.padding.bottom.height,
          ],
        ),
      ),
    );
  }
}
