import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../features/customer/cubit/customer_medical_record_cubit/customer_medical_record_cubit.dart';
import '../../../../features/customer/cubit/customer_medical_record_cubit/customer_medical_record_state.dart';
import '../../../../features/customer/data/models/medical_record_customer_model.dart';
import '../../../models/customer/v2/customer_model.dart';
import '../../event/components/tab_list.dart';
import 'medical_record_item_view.dart';

class HealthRecordsView extends StatefulWidget {
  const HealthRecordsView({
    super.key,
    required this.customer,
  });

  final CustomerV2Model customer;

  @override
  State<HealthRecordsView> createState() => _HealthRecordsViewState();
}

class _HealthRecordsViewState extends State<HealthRecordsView> {
  final _cusMRCubit = getIt.get<CustomerMedicalRecordCubit>();
  CustomerV2Model get _customer => widget.customer;
  int _tabSelected = 0;
  @override
  void initState() {
    super.initState();

    _cusMRCubit.initCustomer(_customer);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerMedicalRecordCubit>(
      create: (context) => _cusMRCubit,
      child: Stack(
        children: [
          Image.asset(
            '${AssetsPath.image}/bg_v4.png',
            width: widthDevice(context),
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.all(sp16),
            padding: const EdgeInsetsGeometry.all(sp16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border_primary),
              borderRadius: BorderRadius.circular(sp16),
              color: whiteColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.icon_iconSecondary,
                      ),
                      sp12.width,
                      Expanded(
                        child: BlocSelector<CustomerMedicalRecordCubit,
                            CustomerMedicalRecordState, List<CustomerV2Model>>(
                          selector: (state) {
                            return state.customers;
                          },
                          builder: (context, members) {
                            return Row(
                              children: [_customer, ...members].map((e) {
                                return _itemCusView(e);
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      sp12.width,
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.icon_iconSecondary,
                      ),
                    ],
                  ),
                  sp16.height,
                  _tabView,
                  sp16.height,
                  _tabSelected == 0 ? _khamBenhView : _lichSuKhamView,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _lichSuKhamView {
    return BlocSelector<CustomerMedicalRecordCubit, CustomerMedicalRecordState,
        CustomerV2Model?>(
      selector: (state) {
        return state.customerSelected;
      },
      builder: (context, customer) {
        return TabListEvent(
          customer: customer?.id,
          padding: const EdgeInsets.all(sp0),
        );
      },
    );
  }

  Widget get _khamBenhView {
    return Column(
      children: [
        _searchView,
        _listView,
      ],
    );
  }

  Widget _itemCusView(CustomerV2Model item) {
    return InkWell(
      onTap: () {
        _cusMRCubit.customerChange(item);
        setState(() {
          _tabSelected = 0;
        });
      },
      child: BlocSelector<CustomerMedicalRecordCubit,
          CustomerMedicalRecordState, bool>(
        selector: (state) {
          return state.customerSelected == item;
        },
        builder: (context, isSelected) {
          return Container(
            margin: const EdgeInsets.only(right: sp12),
            width: sp56 + sp8,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp124),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.border_brandSolid
                          : AppColors.border_primary,
                      width: sp4,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: sp28,
                    backgroundColor: whiteColor.withOpacity(0),
                    backgroundImage: const AssetImage('assets/logo_no_bg.png'),
                  ),
                ),
                sp4.height,
                Text(
                  item.fullName ?? '',
                  style: s12w400.copyWith(
                    color: isSelected
                        ? AppColors.text_primary
                        : AppColors.text_tertiary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget get _tabView {
    return CupertinoSlidingSegmentedControl(
      children: {
        0: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sp16,
            vertical: sp8,
          ),
          child: Text(
            'Khám bệnh',
            style: _tabSelected == 0
                ? h6.copyWith(color: blackColor)
                : p5.copyWith(color: greyColor),
          ),
        ),
        1: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sp16,
            vertical: sp8,
          ),
          child: Text(
            'Lịch sử khám',
            style: _tabSelected == 1
                ? h6.copyWith(color: blackColor)
                : p5.copyWith(color: greyColor),
          ),
        ),
      },
      groupValue: _tabSelected,
      onValueChanged: (value) {
        setState(() {
          _tabSelected = value ?? 0;
        });
      },
    );
  }

  Widget get _searchView {
    return BlocSelector<CustomerMedicalRecordCubit, CustomerMedicalRecordState,
        String>(
      selector: (state) {
        return state.search;
      },
      builder: (context, search) {
        return AppInputV2(
          controller: TextEditingController(text: search),
          hintText: 'Mã ICD, tên bệnh',
          radius: sp48,
          prefixIcon: const Icon(Icons.search_rounded),
          onConfirm: _cusMRCubit.searchChange,
          suffixIcon: search.isNotEmpty
              ? InkWell(
                  onTap: () => _cusMRCubit.searchChange(''),
                  child: const Icon(
                    Icons.close_rounded,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget get _listView {
    return BlocSelector<CustomerMedicalRecordCubit, CustomerMedicalRecordState,
        List<MedicalRecordCustomerModel>>(
      selector: (state) {
        return state.medicalRecords;
      },
      builder: (context, medicalRecords) {
        return Column(
          children: [
            BlocSelector<CustomerMedicalRecordCubit, CustomerMedicalRecordState,
                CustomerV2Model?>(
              selector: (state) {
                return state.customerSelected;
              },
              builder: (context, customerSelected) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(sp0),
                  title: Text(
                    customerSelected?.fullName ?? '',
                    style: s14w600.copyWith(color: AppColors.text_primary),
                  ),
                  subtitle: Text(
                    '(${customerSelected?.birthday ?? '-'})',
                    style: s12w400.copyWith(color: AppColors.text_tertiary),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: sp4,
                      horizontal: sp8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ultility_gray_10,
                      border: Border.all(color: AppColors.ultility_gray_20),
                      borderRadius: BorderRadius.circular(sp24),
                    ),
                    child: Text(
                      '${medicalRecords.length} Bệnh',
                      style:
                          s12w500.copyWith(color: AppColors.ultility_gray_60),
                    ),
                  ),
                );
              },
            ),
            ...medicalRecords.map((e) {
              return MedicalRecordItemView(data: e);
            }),
          ],
        );
      },
    );
  }
}
