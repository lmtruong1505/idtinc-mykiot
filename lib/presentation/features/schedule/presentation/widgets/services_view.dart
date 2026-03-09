import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features/schedule/presentation/widgets/service_select_dialog.dart';
import 'package:pharmago/presentation/features_v2/models/employee/pre_emp_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../shared/components/button/main_button.dart';
import '../../../../base/button.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../../../features_v2/models/event/detail_event_model.dart';
import '../../../../features_v2/models/service/service.dart';
import '../../../../router/router.gr.dart';
import '../../data/models/appointment_schedule_model.dart';

class AppointmentScheduleServices extends StatelessWidget {
  const AppointmentScheduleServices({
    super.key,
    required this.services,
    required this.idCustomer,
    this.totalPrice = 0,
    this.editCallBack,
  });

  final List<AppointmentScheduleService> services;
  final int idCustomer;
  final num totalPrice;
  final Function(List<ServiceV2Model>)? editCallBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Danh sách dịch vụ',
          style: s18w700.copyWith(color: AppColors.text_primary),
        ).padding(const EdgeInsets.all(sp16)),
        sp12.height,
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: sp16),
            itemBuilder: (context, index) {
              final service = services[index].serviceData;
              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${index + 1}. ',
                        style: s14w500.copyWith(
                          color: AppColors.text_primary,
                        ),
                      ),
                      Text(
                        service?.title ?? '',
                        style: s12w500.copyWith(
                          color: AppColors.text_primary,
                        ),
                      ),
                    ],
                  ),
                  sp8.height,
                  Row(
                    children: [
                      Text(
                        'Số lượng ',
                        style: s12w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                      Text(
                        service?.quantity.toString() ?? '',
                        style: s14w500.copyWith(
                          color: AppColors.text_primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${service?.price?.price.formatCurrency} đ',
                        style: s14w500.copyWith(
                          color: AppColors.text_primary,
                        ),
                      ),
                      Text(
                        '/${servicePriceName(
                          context,
                          service?.price?.priceName ?? '',
                        )}',
                        style: s12w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) => const Divider(
              height: sp24,
              color: AppColors.border_primary,
            ),
            itemCount: services.length,
          ),
        ),
        _navBar(context),
      ],
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
                '${totalPrice.formatCurrency}đ',
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
                  title: 'Sửa dịch vụ',
                  event: () {
                    ServiceSelectDialog.show(
                      context,
                      services: services
                          .map(
                            (e) => e.serviceData!.copyWith(
                              serviceEventId: e.id,
                              employee: PreEmpModel(
                                id: e.employeeData?.id,
                                employee: e.employeeData?.id,
                              ),
                            ),
                          )
                          .toList(),
                      callBack: (services) {
                        editCallBack?.call(services);
                      },
                    );
                  },
                ),
              ),
              sp12.width,
              Expanded(
                child: MainButton(
                  title: 'Tạo đơn dịch vụ',
                  radius: sp32,
                  event: () {
                    context.router.push(
                      CreateOrderRoute(
                        type: 'service',
                        customer: idCustomer,
                        services: services
                            .map(
                              (e) => ServicesEvent(
                                serviceData: e.serviceData,
                                employeeData: e.employeeData,
                              ),
                            )
                            .toList(),
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
}
