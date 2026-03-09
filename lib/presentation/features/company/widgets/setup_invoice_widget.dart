import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/company/cubit/electric_invoice_bloc.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/style_app/color_app.dart';

import '../../../../shared/components/widgets/app_switch.dart';

class SetupInvoiceWidget extends StatelessWidget {
  const SetupInvoiceWidget({
    required this.formKey,
    required this.invoice,
    required this.bloc,
    this.canInput = true,
  });
  final Key formKey;
  final UserSerialModel? invoice;
  final ElectricInvoiceBloc bloc;
  final bool canInput;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            AppInputSupport(
              readOnly: !canInput,
              initialValue: invoice?.name,
              hintText: 'Nhập tên mẫu hóa đơn',
              label: 'Nhập tên mẫu hóa đơn',
              backgroundColor: ColorApp.white,
              borderColor: ColorApp.greyA7,
              onChanged: (value) => bloc.setName(value),
              required: true,
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập tên mẫu hóa đơn';
                }
                return null;
              },
            ),
            16.height,
            AppInputSupport(
              readOnly: !canInput,
              initialValue: invoice?.pattern,
              hintText: 'Nhập mẫu số hóa đơn. Ví dụ 1/001',
              label: 'Mã mẫu số hóa đơn',
              backgroundColor: ColorApp.white,
              borderColor: ColorApp.greyA7,
              onChanged: (value) => bloc.setPattern(value),
              required: true,
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập mẫu số hóa đơn';
                }
                return null;
              },
            ),
            16.height,
            AppInputSupport(
              readOnly: !canInput,
              initialValue: invoice?.serial,
              hintText: 'Nhập số serial',
              label: 'Mã serial',
              backgroundColor: ColorApp.white,
              borderColor: ColorApp.greyA7,
              onChanged: (value) => bloc.setSerial(value),
              required: true,
              validate: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập số serial';
                }
                return null;
              },
            ),
            16.height,
            Row(
              children: [
                const Text(
                  'Áp dụng mặc định',
                  style: s14w500,
                ),
                const Spacer(),
                BlocBuilder<ElectricInvoiceBloc, CubitState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return AppSwitch(
                      value: invoice?.defaultFlag ?? bloc.defaultFlag,
                      onChanged: (value) {
                        if (canInput) {
                          bloc.setDefault(value);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const Text(
              'Mẫu hóa đơn được mặc định sử dụng khi phát hành hóa đơn điện tử ',
              style: s10w400,
            ),
          ],
        ),
      ),
    );
  }
}
