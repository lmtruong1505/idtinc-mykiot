import 'dart:typed_data';
import 'dart:ui';
import 'package:pharmago/presentation/base/barcode_widget.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:printing/printing.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features_v2/models/phieu_kham/detail_pk_v2_model.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../constants/spacing.dart';

@RoutePage()
class PrintMedicalBillPage extends StatefulWidget {
  final DetailPkV2Model phieuKham;
  const PrintMedicalBillPage({
    super.key,
    required this.phieuKham,
  });

  @override
  State<PrintMedicalBillPage> createState() => _PrintMedicalBillPageState();
}

class _PrintMedicalBillPageState extends State<PrintMedicalBillPage> {
  final _globalKey = GlobalKey();

  Future<Uint8List> genPdf() async {
    final pdf = pw.Document();
    final boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Image(
              pw.MemoryImage(pngBytes),
            ),
          ); // Center
        },
      ),
    ); //
    return pdf.save();
  }

  String get codeOrderPrescription {
    final prescriptions = widget.phieuKham.prescriptions ?? [];
    if (prescriptions.isNotEmpty) {
      return prescriptions.first.code ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final phieuKham = widget.phieuKham;
    final pathologies = widget.phieuKham.pathologies ?? [];
    final prescriptions = widget.phieuKham.prescriptions ?? [];
    final dateTime = widget.phieuKham.medicalBill?.createdAt ?? DateTime.now();
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Trở về',
        subTitle: 'In đơn thuốc',
      ),
      floatingActionButton: InkWell(
        //onTap: _shareImageBill,
        onTap: () async {
          await Printing.layoutPdf(
            onLayout: (_) => genPdf(),
          );
        },
        child: const CircleAvatar(
          radius: sp24,
          child: Icon(
            Icons.print_rounded,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: _globalKey,
            child: Padding(
              padding: 16.pading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  DividerCustom().padding(8.padingVer),
                  Stack(
                    children: [
                      SizedBox(
                        width: widthDevice(context),
                        child: Column(
                          children: [
                            Text(
                              'ĐƠN THUỐC',
                              textAlign: TextAlign.center,
                              style: AppStyle.headingXl,
                            ),
                            Text(
                              '${dateTime.hour} giờ ${dateTime.minute} phút, ngày ${dateTime.day} tháng ${dateTime.month} năm ${dateTime.year}',
                              textAlign: TextAlign.center,
                              style: AppStyle.bodyBsRegular
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            Text(
                              widget.phieuKham.medicalBill?.createdAt
                                      .formatDateTimeFull ??
                                  '',
                              textAlign: TextAlign.center,
                              style:
                                  s14w500.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: BaseContainer(
                          borderRadius: 0,
                          borderColor: AppColors.black,
                          width: 50,
                          height: 30,
                          child: Center(
                            child: Text(
                              (phieuKham.medicalBill?.id ?? '').toString(),
                              style: s14w700.copyWith(height: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  24.height,
                  Row(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Họ tên: ',
                            style: s14w400,
                          ),
                          Text(
                            (widget.phieuKham.customer?.fullName ?? '')
                                .toUpperCase(),
                            style: s14w700,
                          ),
                        ],
                      ).expanded(),
                      8.width,
                      Row(
                        children: [
                          const Text(
                            'Tuổi: ',
                            style: s14w400,
                          ),
                          Text(
                            '${phieuKham.customer?.orders ?? '-'} tuổi',
                            style: s14w700,
                          ),
                          8.width,
                          const Text(
                            'Giới tính: ',
                            style: s14w400,
                          ),
                          Text(
                            getGender(phieuKham.customer?.gender),
                            style: s14w700,
                          ),
                        ],
                      ).expanded(),
                    ],
                  ),
                  8.height,
                  const Text(
                    'Địa chỉ:',
                    style: s14w400,
                  ),
                  8.height,
                  Text(
                    'Số điện thoại:  ${phieuKham.customer?.phone}',
                    style: s14w400,
                  ),
                  8.height,
                  _buildRow(
                    title: 'Chẩn đoán:',
                    content: pathologies
                        .map((e) => '[${e.code ?? '-'}] ${e.nameVn}')
                        .join('; '),
                  ),
                  8.height,
                  _buildRow(
                    title: 'Kết luận:',
                    content: widget.phieuKham.diagnosis?.conclusion ?? '',
                  ),
                  32.height,
                  ...List.generate(
                    prescriptions.length,
                    (index) => _buildPrd(
                      prescriptions[index],
                    ),
                  ),
                  8.height,
                  Text(
                    'Hẹn khám lại sau:        ngày',
                    style: s14w400.copyWith(fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Bác sĩ khám bệnh'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppStyle.headingMd,
                          ),
                          Text(
                            '(Ký, ghi rõ họ tên)',
                            textAlign: TextAlign.center,
                            style:
                                s14w400.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getGender(String? gender) {
    switch (gender) {
      case 'MALE':
        return 'Nam';
      case 'FEMALE':
        return 'Nữ';
      default:
        return 'Nam';
    }
  }

  Widget _buildHeader() {
    final workspace = widget.phieuKham.workspace;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            6.height,
            Text(
              (workspace?.workspaceName ?? '').toUpperCase(),
              style: s16w700,
            ),
            4.height,
            Text(
              workspace?.address?.fullAddress ?? workspace?.workspaceCode ?? '',
              style: s14w500,
            ),
            4.height,
            Text(
              workspace?.phone ?? workspace?.phoneNumber ?? '',
              style: s14w500,
            ),
          ],
        ).expanded(),
        8.width,
        Column(
          children: [
            Container(
              height: 50,
              width: 120,
              child: BarcodeWidget(codeOrderPrescription, const Size(150, 50)),
            ),
            Text(
              codeOrderPrescription,
              style: AppStyle.bodyBsRegular,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrd(Prescriptions item) {
    final items = item.items ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...List.generate(
          items.length,
          (index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}.',
                  style: AppStyle.headingMd,
                ),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: items[index].name ?? '',
                            style: s14w700,
                          ),
                          TextSpan(
                            text:
                                ' x${items[index].quantity.formatPercent()} ${items[index].unit ?? ""}',
                            style: s14w700,
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   items[index].name ?? '',
                    //   style: AppStyle.headingMd,
                    // ),
                    4.width,
                    Text(
                      items[index].lieuDung ?? '',
                      style: AppStyle.bodyBsRegular.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        16.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lời dặn của bác sĩ:',
              style: AppStyle.bodyBsRegular.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            12.width,
            Text(
              widget.phieuKham.diagnosis?.note ?? '',
              style: AppStyle.headingMd,
            ).expanded(),
          ],
        ),
      ],
    );
  }

  Widget _buildRow({
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.bodyBsRegular,
        ).expanded(flex: 1),
        12.width,
        Text(
          content,
          style: AppStyle.headingMd,
        ).expanded(flex: 3),
      ],
    );
  }
}
