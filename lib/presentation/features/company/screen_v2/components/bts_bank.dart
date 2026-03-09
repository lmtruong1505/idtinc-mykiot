import 'package:flutter/material.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../config/app_style/init_app_style.dart';
import '../../domain/entities/bank_entity.dart';

class BtsBank extends StatefulWidget {
  final List<BankEntity> banks;
  final BankEntity? bank;
  const BtsBank({super.key, this.bank, required this.banks});

  @override
  State<BtsBank> createState() => _BtsBankState();
}

class _BtsBankState extends State<BtsBank> {
  List<BankEntity> banks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    banks = widget.banks;
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Chọn ngân hàng',
      needBottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInputV2(
            hintText: 'Tìm kiếm',
            radius: 8,
            onChanged: (p0) {
              banks = widget.banks
                  .where(
                    (element) =>
                        element.shortName
                                ?.toLowerCase()
                                .contains(p0.toLowerCase()) ==
                            true ||
                        element.name
                                ?.toLowerCase()
                                .contains(p0.toLowerCase()) ==
                            true,
                  )
                  .toList();
              setState(() {});
            },
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.input_iconDefault,
            ),
          ),
          if (banks.isEmpty)
            EmptyContainer(
              msg: 'Không tìm thấy',
              icon: FaIcon(
                iconCode: 'f19c',
                size: 32,
              ),
            ),
          ...List.generate(
            banks.length,
            (index) => ListTile(
              onTap: () => context.pop(result: banks[index]),
              contentPadding: 16.padingHor,
              dense: true,
              trailing: banks[index].code == widget.bank?.code
                  ? const Icon(
                      Icons.check,
                      color: AppColors.brand,
                    )
                  : null,
              title: Text(
                banks[index].shortName ?? '',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              subtitle: Text(
                banks[index].name ?? '',
                style: AppStyle.bodySmRegular.copyWith(
                  color: AppColors.text_quaternary,
                ),
              ),
            ),
          ),
        ],
      ),
    ).size(
      height: context.height,
    );
  }
}
