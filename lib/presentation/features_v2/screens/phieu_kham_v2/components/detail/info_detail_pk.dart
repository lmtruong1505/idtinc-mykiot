import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../models/phieu_kham/detail_pk_v2_model.dart';

class InfoDetailPk extends StatefulWidget {
  final DetailPkV2Model phieuKham;
  const InfoDetailPk({
    super.key,
    required this.phieuKham,
  });

  @override
  State<InfoDetailPk> createState() => _InfoDetailPkState();
}

class _InfoDetailPkState extends State<InfoDetailPk> {
  TextStyle get hintStyle => AppStyle.bodySmRegular.copyWith(
        color: AppColors.text_quaternary,
        height: 1.5,
      );

  TextStyle get titleStyle => AppStyle.bodyBsMedium.copyWith(
        color: AppColors.text_secondary,
        height: 1.5,
      );
  String get codeOrderPrescription {
    final prescriptions = widget.phieuKham.prescriptions ?? [];
    if (prescriptions.isNotEmpty) {
      return prescriptions.first.code ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildQr,
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            6.height,
            Text(
              widget.phieuKham.medicalBill?.createdAt
                      .fomatCustom(fomat: 'HH:mm ∙ dd/MM/yyyy') ??
                  '',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_quaternary,
              ),
            ),
            6.height,
            RichText(
              text: TextSpan(
                text: '#',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_quaternary,
                ),
                children: [
                  TextSpan(
                    text: codeOrderPrescription,
                    style: AppStyle.headingMd.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                ],
              ),
            ),
            6.height,
            Text(
              'Khách hàng',
              style: hintStyle,
            ),
            Text(
              widget.phieuKham.customer?.fullName ?? '',
              style: titleStyle,
            ),
            Text(
              widget.phieuKham.customer?.phone ?? '',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.text_quaternary,
              ),
            ),
            6.height,
          ],
        ).expanded(),
      ],
    );
  }

  Widget get buildQr => Column(
        children: [
          Container(
            height: 140,
            width: 140,
            padding: 8.pading,
            child: QrImageView(
              data: codeOrderPrescription,
            ),
          ),
          InkWell(
            onTap: () {
              context.pushRoute(
                PrintMedicalBillRoute(
                  phieuKham: widget.phieuKham,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'In đơn thuốc',
                  style: AppStyle.bodyBsMedium,
                ),
                4.width,
                const Icon(
                  Icons.print_outlined,
                  size: 20,
                  color: AppColors.icon_iconPrimary,
                ),
              ],
            ).padding(8.padingVer),
          ),
        ],
      ).container(
        radius: 8,
        padding: 0.pading,
        border: Border.all(
          color: AppColors.border_tertiary,
          width: 2,
        ),
      );
}
