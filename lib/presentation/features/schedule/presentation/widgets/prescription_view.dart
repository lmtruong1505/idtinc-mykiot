import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../shared/components/button/main_button.dart';
import '../../../../base/cache_image.dart';
import '../../../../constants/colors.dart';
import '../../../../features_v2/models/phieu_kham/detail_pk_v2_model.dart';
import '../../../../features_v2/models/product/product_v2_model.dart';
import '../../../../features_v2/screens/phieu_kham_v2/print_medical_bill.dart';
import '../../data/models/appointment_schedule_model.dart';
import '../../data/models/diagnosis_model.dart';
import '../../data/models/prescription_model.dart';
import 'prescription_create_bts.dart';

class PrescriptionView extends StatelessWidget {
  const PrescriptionView({
    super.key,
    this.prescription,
    this.callBack,
    this.detailSchedule,
    this.diagnosis,
  });

  final AppointmentScheduleModel? detailSchedule;
  final DiagnosisModel? diagnosis;
  final PrescriptionModel? prescription;
  final Function(List<ProductV2Model>)? callBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(sp16),
            child:
                prescription == null ? _emptyView(context) : _listView(context),
          ),
        ),
        if (prescription != null) _navBar(context),
      ],
    );
  }

  Widget _emptyView(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          '${AssetsPath.svg}/prescription_empty.svg',
        ),
        sp4.height,
        Text(
          'Chưa có đơn thuốc',
          style: s16w400.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        sp12.height,
        MainButton(
          title: 'Tạo đơn thuốc',
          icon: const Icon(Icons.add_rounded),
          largeButton: false,
          radius: sp24,
          event: () {
            _createPrescriptionHandle(context);
          },
        ),
      ],
    );
  }

  Widget _listView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(sp6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.border_tertiary,
                    ),
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: prescription?.code ?? '',
                      ),
                      sp8.height,
                      InkWell(
                        onTap: () {
                          context.push(
                            PrintMedicalBillPage(
                              phieuKham: DetailPkV2Model(
                                workspace: detailSchedule?.workspace,
                                medicalBill: MedicalBill(
                                  id: prescription?.id,
                                  code: prescription?.code,
                                  conclusion: diagnosis?.conclusion,
                                ),
                                customer: detailSchedule?.patient,
                                pathologies: diagnosis?.diagnosis?.map((e) {
                                  return Pathologies(
                                    id: e.id,
                                    code: e.code,
                                    name: e.nameVn,
                                    nameVn: e.nameVn,
                                  );
                                }).toList(),
                                prescriptions: [
                                  Prescriptions(
                                    id: prescription?.id,
                                    code: prescription?.code,
                                    note: diagnosis?.conclusion,
                                    items: prescription?.items?.map((e) {
                                      return ItemsPrescriptions(
                                        id: e.id,
                                        lieuDung: e.lieuDung,
                                        name: e.productData?.name,
                                        quantity: e.quantity,
                                        price:
                                            e.productData?.unitData?.sellPrice,
                                        unit: e.productData?.unitData?.name,
                                      );
                                    }).toList(),
                                  ),
                                ],
                                diagnosis: diagnosis,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'In đơn thuốc',
                              style: s14w500.copyWith(
                                color:
                                    AppColors.button_neutral_ghost_textDefault,
                              ),
                            ),
                            sp4.width,
                            FaIcon(iconCode: 'f02f'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sp12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      prescription?.createdAt.fomatCustom(
                            fomat: 'HH:mm dd/MM/yyyy',
                          ) ??
                          '',
                      style: s14w400.copyWith(color: AppColors.text_quaternary),
                    ),
                    sp4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prescription?.code ?? '',
                          style:
                              s16w700.copyWith(color: AppColors.text_secondary),
                        ),
                        FaIcon(
                          iconCode: 'f044',
                        ),
                      ],
                    ),
                    sp4.height,
                    Text(
                      'Khách hàng',
                      style: s12w400.copyWith(color: AppColors.text_tertiary),
                    ),
                    sp4.height,
                    Text(
                      prescription?.patient?.fullName ?? '',
                      style: s14w600.copyWith(color: AppColors.text_secondary),
                    ),
                    sp4.height,
                    Text(
                      prescription?.patient?.phone ?? '',
                      style: s14w400.copyWith(color: AppColors.text_tertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          sp16.height,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = prescription?.items?[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(sp0),
                    leading: BaseCacheImage(
                      loadPharmagoLogo: true,
                      url: item?.productData?.images?.firstOrNull?.url ?? '',
                      width: 56,
                      height: 56,
                      borderRadius: 4.radius,
                      fit: BoxFit.cover,
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: sp32,
                          child: Text(
                            '${index + 1}. ',
                            style: s14w500.copyWith(
                                color: AppColors.text_tertiary),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item?.productData?.name ?? '',
                            style:
                                s12w500.copyWith(color: AppColors.text_primary),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        sp32.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Số lượng',
                                style: s12w400.copyWith(
                                  color: AppColors.text_tertiary,
                                ),
                              ),
                              Text(
                                '${item?.quantity} ${item?.productData?.unitData?.name}',
                                style: s14w500.copyWith(
                                  color: AppColors.text_secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item?.productData?.unitSell?.sellPrice.formatCurrency} đ',
                                style: s14w500.copyWith(
                                  color: AppColors.text_secondary,
                                ),
                              ),
                              Text(
                                '${item?.productData?.unitSell?.name}',
                                style: s14w500.copyWith(
                                  color: AppColors.text_secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  sp12.height,
                  Text(
                    'Liều dùng',
                    style: s14w500.copyWith(
                      color: AppColors.input_label,
                    ),
                  ),
                  sp4.height,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: sp4, horizontal: sp8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sp6),
                      color: AppColors.bg_disable,
                    ),
                    child: Text(
                      item?.lieuDung ?? '---',
                      style: s14w500.copyWith(
                        color: AppColors.text_primary,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) => const Divider(height: sp24),
            itemCount: prescription?.items?.length ?? 0,
          ),
        ],
      ),
    );
  }

  Widget _navBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(
        bottom: sp32,
      ),
      // width: widthDevice(context),
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: black5o,
            offset: Offset(0, -1),
            spreadRadius: sp4,
            blurRadius: sp4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Tổng thanh toán',
                style: s14w400.copyWith(color: AppColors.text_primary),
              ),
              const Spacer(),
              Text(
                '${prescription?.totalPrice.formatCurrency}đ',
                style: s16w700.copyWith(color: AppColors.text_primary),
              ),
            ],
          ),
          sp12.height,
          Row(
            children: [
              Expanded(
                child: SupportButton(
                  largeButton: true,
                  radius: sp32,
                  backgroundColor:
                      AppColors.button_brand_alpha_backgroundDefault,
                  color: AppColors.button_brand_alpha_textDefault,
                  title: 'Sửa sản phẩm',
                  event: () {},
                ),
              ),
              sp12.width,
              Expanded(
                child: MainButton(
                  title: 'Tạo đơn sản phẩm',
                  radius: sp32,
                  event: () {
                    context.router.push(
                      CreateOrderRoute(
                        type: 'product',
                        customer: prescription?.patient?.id,
                        products: prescription?.items?.map((e) {
                          return e.productData!.copyWith(
                            quantity: e.quantity ?? 0,
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createPrescriptionHandle(BuildContext context) {
    PrescriptionCreateDialog.show(
      context,
      callBack: (products) async {
        DialogUtils.showLoadingDialog(context, 'Đang tạo đơn thuốc');
        await callBack?.call(products);
        if (!context.mounted) return;
        context.pop();
      },
    );
  }
}
