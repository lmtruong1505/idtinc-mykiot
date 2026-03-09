import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/label_button.dart';
import '../../../blocs/product/extra_create_bloc.dart';

class DialogCreateExtra extends StatefulWidget {
  const DialogCreateExtra({super.key, required this.bloc});

  final ExtraCreateBloc bloc;

  @override
  State<DialogCreateExtra> createState() => _DialogCreateExtraState();
}

class _DialogCreateExtraState extends State<DialogCreateExtra> {
  final ctrlName = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: 16.radius,
      ),
      child: Padding(
        padding: 16.pading,
        child: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Thêm mới ${widget.bloc.type.nameVn.toLowerCase()}',
                    style: AppStyle.headingLg,
                  ).expanded(),
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                    ).container(
                      padding: 4.pading,
                      radius: 999,
                      bgColor: AppColors.button_neutral_alpha_backgroundDefault
                          .withOpacity(0.05),
                    ),
                  ),
                ],
              ),
              16.height,
              InputColumn(
                label: 'Tên ${widget.bloc.type.nameVn.toLowerCase()}',
                isRequired: true,
                hintText: 'Nhập tên ${widget.bloc.type.nameVn.toLowerCase()}',
                controller: ctrlName,
                padding: 0.pading,
              ),
              16.height,
              Row(
                children: [
                  LabelButton(
                    label: 'Huỷ bỏ',
                    backgroundColor:
                        AppColors.button_neutral_alpha_backgroundDefault,
                    labelStyle: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_neutral_alpha_textDefault,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ).expanded(),
                  12.width,
                  LabelButton(
                    label: 'Tiếp tục',
                    border: const BorderSide(
                      color: AppColors.button_brand_solid_textDefault,
                    ),
                    backgroundColor:
                        AppColors.button_neutral_solid_backgroundDefault,
                    labelStyle: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.button_brand_solid_textDefault,
                    ),
                    onPressed: () {
                      if (!key.currentState!.validate()) {
                        return;
                      }
                      widget.bloc.create(ctrlName.text).then((value) {
                        context.pop();
                        if (value.code == 200) {
                          widget.bloc.getList();
                        } else {
                        }
                      });
                    },
                  ).expanded(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
