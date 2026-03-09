import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/app_input.dart';

class InvoiceAttributesSetupBts extends StatefulWidget {
  const InvoiceAttributesSetupBts(
      {super.key,
      this.defaultFlag = false,
      required this.workspace,
      this.name,
      this.pattern,
      this.serial,
      this.callBack});

  final String? name;
  final String? pattern;
  final String? serial;
  final int workspace;
  final bool defaultFlag;
  final Function(
    String name,
    String pattern,
    String serial,
    bool defaultFlag,
  )? callBack;

  static void show(
    BuildContext context, {
    required int workspace,
    bool defaultFlag = false,
    String? name,
    String? pattern,
    String? serial,
    Function(
      String name,
      String pattern,
      String serial,
      bool defaultFlag,
    )? callBack,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return InvoiceAttributesSetupBts(
          name: name,
          pattern: pattern,
          serial: serial,
          workspace: workspace,
          defaultFlag: defaultFlag,
          callBack: callBack,
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp16),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<InvoiceAttributesSetupBts> createState() =>
      _InvoiceAttributesSetupBtsState();
}

class _InvoiceAttributesSetupBtsState extends State<InvoiceAttributesSetupBts> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtl;
  late TextEditingController _patternCtl;
  late TextEditingController _serialCtl;
  late bool _defaultFlag;

  @override
  void initState() {
    super.initState();

    _nameCtl = TextEditingController(text: widget.name ?? '');
    _patternCtl = TextEditingController(text: widget.pattern ?? '');
    _serialCtl = TextEditingController(text: widget.serial ?? '');
    _defaultFlag = widget.defaultFlag;
  }

  @override
  void dispose() {
    super.dispose();

    _nameCtl.dispose();
    _patternCtl.dispose();
    _serialCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets.copyWith(
        left: sp16, right: sp16, top: sp16,
      ),
      duration: const Duration(milliseconds: 100),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: sp48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.border_tertiary,
                  width: sp4,
                ),
                borderRadius: BorderRadius.circular(sp24),
              ),
            ),
            sp16.height,
            Text(
              'Thiết lập mẫu hoá đơn',
              style: s16w700.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            sp16.height,
            AppInputV2(
              controller: _nameCtl,
              label: 'Tên mẫu hoá đơn',
              hintText: 'Nhập tên mẫu hoá đơn',
              required: true,
              validate: (value) {
                if (value.isEmptyOrNull) {
                  return 'Vui lòng nhập';
                }
              },
            ),
            sp16.height,
            AppInputV2(
              controller: _patternCtl,
              label: 'Mã mẫu số hóa đơn',
              hintText: 'Nhập mã mẫu số hóa đơn',
              required: true,
              validate: (value) {
                if (value.isEmptyOrNull) {
                  return 'Vui lòng nhập';
                }
              },
            ),
            sp16.height,
            AppInputV2(
              controller: _serialCtl,
              label: 'Mã serial',
              hintText: 'Nhập mã serial',
              required: true,
              validate: (value) {
                if (value.isEmptyOrNull) {
                  return 'Vui lòng nhập';
                }
              },
            ),
            sp16.height,
            ListTile(
              contentPadding: const EdgeInsets.all(sp0),
              title: Text(
                'Áp dụng mặc định',
                style: s14w500.copyWith(
                  color: AppColors.text_primary,
                ),
              ),
              subtitle: Text(
                'Mẫu hóa đơn được mặc định sử dụng khi phát hành hóa đơn điện tử ',
                style: s12w400.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              trailing: AppSwitch(
                value: _defaultFlag,
                onChanged: (value) {
                  setState(() {
                    _defaultFlag = value;
                  });
                },
              ),
            ),
            const Divider(),
            MainButton(
              title: 'Xác nhận',
              event: _confirmHandle,
              radius: sp48,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmHandle() {
    final validate = _formKey.currentState?.validate() ?? false;
    if (!validate) return;

    widget.callBack?.call(
      _nameCtl.text,
      _patternCtl.text,
      _serialCtl.text,
      _defaultFlag,
    );
  }
}
