import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/order_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class ExportElectricInvoiceBottomSheet extends StatefulWidget {
  const ExportElectricInvoiceBottomSheet({
    super.key,
    required this.bloc,
  });

  final OrderManagerBloc bloc;

  @override
  State<ExportElectricInvoiceBottomSheet> createState() =>
      _ExportElectricInvoiceBottomSheetState();
}

class _ExportElectricInvoiceBottomSheetState
    extends State<ExportElectricInvoiceBottomSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: seri);
    tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  final seri = AppSharedPreference.instance.getString(PrefKeys.serialNumber);
  final serialKey = GlobalKey<FormState>();
  late TabController tabCtrl;

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    return BlocBuilder<OrderManagerBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final isExport = bloc.invoice != null;
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp12),
              color: greyFF3,
            ),
            height: 0.9 * heightDevice(context),
            child: Scaffold(
              body: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => context.router.maybePop(),
                      child: const CircleAvatar(
                        radius: sp20,
                        backgroundColor: greyFF3,
                        child: Icon(
                          Icons.close_rounded,
                          color: blackColor,
                          size: sp16,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    isExport ? 'Phát hành HĐĐT' : 'Đồng bộ CSDL Dược',
                    style: s16w500,
                  ),
                  gapHeight(sp16),
                  TabBarView(
                    controller: tabCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _inputSerialSection(bloc, context),
                      ExportInvoice(bloc: bloc),
                    ],
                  ).padding(16.padingHor).expanded(),
                ],
              ),
              bottomNavigationBar: Row(
                children: [
                  if (tabCtrl.index == 1)
                    MainButtonV2(
                      radius: 999,
                      title: 'Quay lại màn danh sách',
                      onTap: () => Navigator.of(context).pop(),
                    ).expanded()
                  else ...[
                    ExtraButton(
                      title: 'Huỷ bỏ',
                      borderRadius: sp24,
                      event: () => context.router.maybePop(),
                    ).expanded(),
                    gapWidth(sp16),
                    MainButton(
                      title: 'Phát hành',
                      radius: sp24,
                      event: () async {
                        if (!serialKey.currentState!.validate()) {
                          return;
                        }
                        if (bloc.invoice != null) {
                          if (bloc.isRemember) {
                            AppSharedPreference.instance.setValue(
                              PrefKeys.serialNumber,
                              controller.text,
                            );
                          } else {
                            AppSharedPreference.instance
                                .remove(PrefKeys.serialNumber);
                          }
                          bloc.createExportInvoice(controller.text);
                          tabCtrl.animateTo(1, curve: Curves.linearToEaseOut);
                        }
                      },
                    ).expanded(),
                  ],
                ],
              ).padding(16.padingHor + 16.padingBottom),
            ),
          ),
        );
      },
    );
  }

  Form _inputSerialSection(OrderManagerBloc bloc, BuildContext context) {
    return Form(
      key: serialKey,
      child: Column(
        children: [
          AppInputSupport(
            label: 'Serial',
            controller: controller,
            hintText: 'Nhập serial',
            validate: (value) {
              if (value.isEmptyOrNull) {
                return 'Ban chưa nhập số serial';
              }
              return null;
            },
            // onChanged: myBloc.changeName,
          ),
          gapHeight(sp16),
          Row(
            children: [
              BaseCheckbox2(
                value: bloc.isRemember,
                onChanged: (value) => bloc.changeRemember(),
              ),
              4.width,
              const Text(
                'Ghi nhớ mã',
                style: s14w400,
              ),
            ],
          ),
          const Spacer(),
          const Divider(),
        ],
      ),
    );
  }
}

class ExportInvoice extends StatelessWidget {
  const ExportInvoice({
    super.key,
    required this.bloc,
  });

  final OrderManagerBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderManagerBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đã chọn ${bloc.listSelected?.length} Hóa đơn',
              style: s16w500,
            ),
            16.height,
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final invoice = bloc.listSelected?[index];
                return Row(
                  children: [
                    Text('#${invoice?.code}'),
                    const Spacer(),
                    state.status == BlocStatus.loadList
                        ? const BaseLoadingV2(height: 24)
                        : FaIcon(
                            iconCode: 'f058',
                            color: AppColors.brand,
                            size: 14,
                          ),
                  ],
                ).padding(8.padingVer);
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: bloc.listSelected?.length ?? 0,
            ),
          ],
        );
      },
    );
  }
}
