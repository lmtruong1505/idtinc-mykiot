import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/input/input_column.dart';
import '../../../../../shared/components/widgets/chip_custom.dart';
import '../../../../features_v2/models/product/image_model.dart';
import '../../data/models/appointment_schedule_model.dart';
import '../../data/models/diagnosis_model.dart';
import '../../data/models/pathology_model.dart';
import 'conclusion_bts.dart';
import 'pathology_bts.dart';
import 'service_conclusion_bts.dart';

class DiagnosisView extends StatelessWidget {
  const DiagnosisView({
    super.key,
    required this.detailSchedule,
    required this.diagnosis,
    this.pathologiesCallback,
    this.createPathologyCallBack,
    this.conclusionCallBack,
    this.serviceConclusionCallBack,
  });

  final AppointmentScheduleModel detailSchedule;
  final DiagnosisModel diagnosis;
  final Function(List<PathologyModel>)? pathologiesCallback;
  final Function(String, String)? createPathologyCallBack;
  final Function(
    String conclusion,
    String note,
    List<File> images,
    List<File> files,
  )? conclusionCallBack;
  final Function(
    int id,
    String conclusion,
    List<File>? files,
    List<ImageModel>? filesNetwork,
  )? serviceConclusionCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(sp16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Triệu chứng',
              style: s18w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            sp16.height,
            Text(
              'Triệu chứng',
              style: s14w400.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            Text(
              diagnosis.symptoms ?? '---',
              style: s14w500.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
            sp16.height,
            Row(
              children: [
                Expanded(
                  child: InputColumn(
                    initialValue: diagnosis.vitalSigns?.mch ?? '-',
                    readOnly: true,
                    label: 'Mạch',
                    hintText: 'Nhập số',
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    fillColor: AppColors.bg_disable,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Lần/phút',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                sp12.width,
                Expanded(
                  child: InputColumn(
                    initialValue: diagnosis.vitalSigns?.nhit ?? '-',
                    readOnly: true,
                    label: 'Nhiệt độ',
                    hintText: 'Nhập số',
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    fillColor: AppColors.bg_disable,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        '°C',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            sp12.height,
            Row(
              children: [
                Expanded(
                  child: InputColumn(
                    initialValue: diagnosis.vitalSigns?.huytP ?? '-',
                    readOnly: true,
                    label: 'Huyết áp',
                    hintText: 'VD: 120/120',
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    fillColor: AppColors.bg_disable,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'mmHg',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                sp12.width,
                Expanded(
                  child: InputColumn(
                    initialValue: diagnosis.vitalSigns?.nhipTh ?? '-',
                    readOnly: true,
                    label: 'Nhịp thở',
                    hintText: 'Nhập số',
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    fillColor: AppColors.bg_disable,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Lần/phút',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            sp12.height,
            Row(
              children: [
                Expanded(
                  child: InputColumn(
                    initialValue: diagnosis.vitalSigns?.cnNng ?? '-',
                    readOnly: true,
                    label: 'Cân nặng',
                    hintText: 'Nhập số',
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    fillColor: AppColors.bg_disable,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Kg',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                sp12.width,
                Expanded(
                  child: InputColumn(
                    initialValue: diagnosis.vitalSigns?.chiuCao ?? '-',
                    readOnly: true,
                    label: 'Chiều cao',
                    hintText: 'Nhập số',
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    fillColor: AppColors.bg_disable,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Cm',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            sp16.height,
            _servicesView(context),
            sp16.height,
            _chuanDoanKetLuan(context),
            _imagesView,
            _filesView,
            sp16.height,
          ],
        ),
      ),
    );
  }

  Widget get _imagesView {
    if (detailSchedule.images == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sp16.height,
        Text(
          'Ảnh liên quan',
          style: s14w500.copyWith(
            color: AppColors.input_label,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: sp6),
          padding: const EdgeInsets.all(sp12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            border: Border.all(
              color: AppColors.border_primary,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: detailSchedule.images!.map((e) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        border: Border.all(color: AppColors.border_secondary),
                      ),
                      margin: const EdgeInsets.only(right: sp8),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(sp12),
                        child: Image.network(
                          // loadingBuilder: (_, __, loadingProgress) => const BaseLoading(),
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('${AssetsPath.image}/pharmago_v2.png');
                          },
                          e.url!,
                          width: sp48,
                          height: sp48,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              sp4.height,
              Text(
                '${detailSchedule.images!.length}/10',
                style: s14w500.copyWith(color: AppColors.text_primary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _filesView {
    if (detailSchedule.filesConclusion == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sp16.height,
        Text(
          'Tài liệu liên quan (${detailSchedule.filesConclusion!.length}/5)',
          style: s14w500.copyWith(
            color: AppColors.input_label,
          ),
        ),
        ...detailSchedule.filesConclusion!.map((e) {
          return Container(
            margin: const EdgeInsets.only(top: sp6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e.fileName ?? '',
                    style: s14w500.copyWith(color: AppColors.text_hyperlink),
                  ),
                ),
                sp16.width,
                CircleAvatar(
                  radius: sp16,
                  backgroundColor:
                      AppColors.button_neutral_alpha_backgroundDefault,
                  child: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.button_neutral_alpha_iconDefault,
                    size: sp16,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _servicesView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kết luận sau thực hiện dịch vụ',
          style: s18w700.copyWith(
            color: AppColors.text_primary,
          ),
        ),
        sp16.height,
        ...(diagnosis.appointmentService ?? []).asMap().map((i, e) {
          return MapEntry(
            e.id,
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${i + 1}. ',
                      style: s14w400.copyWith(color: AppColors.text_tertiary),
                    ),
                    sp4.width,
                    Expanded(
                      child: Text(
                        '${e.serviceData?.serviceName}',
                        style: s12w500.copyWith(color: AppColors.text_primary),
                      ),
                    ),
                  ],
                ),
                sp4.height,
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Người thực hiện',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ),
                        Text(
                          e.employeeName ?? '',
                          style:
                              s12w500.copyWith(color: AppColors.text_primary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Số lượng',
                          style:
                              s12w400.copyWith(color: AppColors.text_tertiary),
                        ),
                        Text(
                          '1',
                          style:
                              s12w500.copyWith(color: AppColors.text_primary),
                        ),
                      ],
                    ),
                  ],
                ),
                sp4.height,
                if (e.medicalBillData?.isEmpty ?? true)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChipCustom(
                      color: AppColors.border_primary,
                      title: 'Thêm kết luận',
                      suffixIcon: const Icon(
                        Icons.add_rounded,
                        size: sp12,
                      ),
                      titleStyle: s12w500,
                      padding: const EdgeInsets.all(sp8),
                      onTap: () {
                        ServiceConclusionBts.show(
                          context,
                          service: e,
                          callBack: serviceConclusionCallBack,
                        );
                      },
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Kết quả sau thực hiện',
                            style: s14w400.copyWith(
                              color: AppColors.text_secondary,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ServiceConclusionBts.show(
                                context,
                                service: e,
                                callBack: serviceConclusionCallBack,
                              );
                            },
                            child: FaIcon(
                              iconCode: 'f044',
                              color: AppColors.fg_quaternary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        e.medicalBillData?.first.conclusion ?? '',
                        style: s14w500.copyWith(
                          color: AppColors.text_primary,
                        ),
                      ),
                      Text(
                        'Tài liệu liên quan (${e.medicalBillData?.first.files?.length ?? 0}/5)',
                        style: s14w500.copyWith(
                          color: AppColors.input_label,
                        ),
                      ),
                      ...(e.medicalBillData?.first.files ?? []).map((e) {
                        return Container(
                          margin: const EdgeInsets.only(top: sp6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e.fileName ?? '',
                                  style: s14w500.copyWith(
                                      color: AppColors.text_hyperlink),
                                ),
                              ),
                              sp16.width,
                              CircleAvatar(
                                radius: sp16,
                                backgroundColor: AppColors
                                    .button_neutral_alpha_backgroundDefault,
                                child: const Icon(
                                  Icons.file_download_outlined,
                                  color: AppColors
                                      .button_neutral_alpha_iconDefault,
                                  size: sp16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                const Divider(),
              ],
            ),
          );
        }).values,
      ],
    );
  }

  Widget _chuanDoanKetLuan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chẩn đoán và kết luận chung',
          style: s18w700.copyWith(
            color: AppColors.text_primary,
          ),
        ),
        Text(
          'Chẩn đoán',
          style: s16w500.copyWith(
            color: AppColors.input_label,
          ),
        ),
        sp16.height,
        if (diagnosis.diagnosis?.isEmpty ?? true)
          ChipDashBorder(
            padding: const EdgeInsets.symmetric(vertical: sp8),
            color: AppColors.border_primary,
            title: 'Chẩn đoán',
            suffixIcon: const Icon(
              Icons.add_rounded,
              size: sp16,
              color: AppColors.fg_quaternary,
            ),
            titleStyle: s14w500.copyWith(color: AppColors.text_secondary),
            onTap: () {
              PathologyBts.show(
                context,
                callBack: pathologiesCallback,
                createPathologyCallBack: createPathologyCallBack,
              );
              // ConclusionBts.show(context);
            },
          )
        else
          Wrap(
            spacing: sp8,
            runSpacing: sp8,
            children: [
              ...diagnosis.diagnosis!.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp4,
                    horizontal: sp8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    border: Border.all(color: AppColors.border_primary),
                  ),
                  child: Text(
                    e.nameVn ?? '',
                    style: s14w400.copyWith(
                      color: AppColors.text_primary,
                    ),
                  ),
                );
              }),
              ChipDashBorder(
                padding: const EdgeInsets.symmetric(
                  vertical: sp4,
                  horizontal: sp8,
                ),
                color: AppColors.border_primary,
                radius: const Radius.circular(sp8),
                title: 'chỉnh sửa',
                suffixIcon: FaIcon(
                  iconCode: 'f044',
                  size: sp16,
                  color: AppColors.fg_quaternary,
                ),
                titleStyle: s14w500.copyWith(color: AppColors.text_secondary),
                onTap: () {
                  PathologyBts.show(
                    context,
                    callBack: pathologiesCallback,
                    pathologies: diagnosis.diagnosis,
                    createPathologyCallBack: createPathologyCallBack,
                  );
                  // ConclusionBts.show(context);
                },
              ),
            ],
          ),
        sp16.height,
        Row(
          children: [
            Text(
              'Kết luận chung',
              style: s16w500.copyWith(
                color: AppColors.input_label,
              ),
            ),
            const Spacer(),
            Visibility(
              visible: diagnosis.conclusion != null,
              child: InkWell(
                onTap: () {
                  ConclusionBts.show(
                    context,
                    conclusion: diagnosis.conclusion,
                    note: diagnosis.note,
                    callBack: conclusionCallBack,
                  );
                },
                child: FaIcon(
                  iconCode: 'f044',
                  size: sp16,
                  color: AppColors.fg_quaternary,
                ),
              ),
            ),
          ],
        ),
        sp4.height,
        if (diagnosis.conclusion == null)
          ChipDashBorder(
            padding: const EdgeInsets.symmetric(vertical: sp8),
            color: AppColors.border_primary,
            title: 'Thêm kết luận chung',
            suffixIcon: const Icon(
              Icons.add_rounded,
              size: sp16,
              color: AppColors.fg_quaternary,
            ),
            titleStyle: s14w500.copyWith(color: AppColors.text_secondary),
            onTap: () {
              ConclusionBts.show(
                context,
                callBack: conclusionCallBack,
              );
            },
          )
        else
          Text(
            diagnosis.conclusion!,
            style: s14w500.copyWith(
              color: AppColors.text_primary,
            ),
          ),
        if (diagnosis.note != null) ...[
          sp16.height,
          Row(
            children: [
              Text(
                'Lời dặn của bác sĩ',
                style: s16w500.copyWith(
                  color: AppColors.input_label,
                ),
              ),
              const Spacer(),
              Visibility(
                visible: diagnosis.conclusion != null,
                child: InkWell(
                  onTap: () {
                    ConclusionBts.show(
                      context,
                      conclusion: diagnosis.conclusion,
                      note: diagnosis.note,
                      callBack: conclusionCallBack,
                    );
                  },
                  child: FaIcon(
                    iconCode: 'f044',
                    size: sp16,
                    color: AppColors.fg_quaternary,
                  ),
                ),
              ),
            ],
          ),
          sp4.height,
          Text(
            diagnosis.note!,
            style: s14w500.copyWith(
              color: AppColors.text_primary,
            ),
          ),
        ],
      ],
    );
  }
}
