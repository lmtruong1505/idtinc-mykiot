import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/medical_record_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/navigation.dart';

import '../../../base/date.dart';
import '../../../base/svg.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../cubit/medical_record_cubit/medical_record_cubit.dart';
import '../cubit/medical_record_cubit/medical_record_state.dart';

@RoutePage()
class MedicalRecordListPage extends StatefulWidget {
  const MedicalRecordListPage({
    super.key,
    this.customer,
  });

  final int? customer;

  @override
  State<MedicalRecordListPage> createState() => _MedicalRecordListPageState();
}

class _MedicalRecordListPageState extends State<MedicalRecordListPage> {
  final _cubit = getIt.get<MedicalRecordCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicalRecordCubit>(
      create: (context) => _cubit..init(id: widget.customer),
      child: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_4,
            appBar: BaseAppBar(
              title: 'Hồ sơ bệnh án',
              actions: [
                InkWell(
                  onTap: () => context.navPush(
                    MedicalRecordCreateRoute(customer: widget.customer),
                  ).then((value) => _cubit.medicalRecordsILC.onRefresh()),
                  child: const Icon(Icons.add_rounded),
                ),
                gapWidth(sp16),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              height: heightDevice(context),
              width: widthDevice(context),
              child: RefreshIndicator(
                onRefresh: () async {
                  _cubit.medicalRecordsILC.onRefresh();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InfiniteList(
                        shrinkWrap: true,
                        getData: (page) async {
                          return _cubit.list(page);
                        },
                        itemBuilder: (context, item, index) => _oneItem(item),
                        scrollController: _cubit.scrollController,
                        infiniteListController: _cubit.medicalRecordsILC,
                        circularProgressIndicator: const BaseLoading(),
                        noItemFoundWidget: const EmptyContainer(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _oneItem(MedicalRecordEntity item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp12),
        color: whiteColor,
      ),
      padding: const EdgeInsets.all(sp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                item.result ?? '',
                style: p1.copyWith(color: blackColor),
              ),
              const Spacer(),
              InkWell(onTap: () {}, child: IcSvg.asset('/ic_pen.svg')),
              gapWidth(sp32),
              InkWell(onTap: () {}, child: IcSvg.asset('/ic_trash.svg')),
            ],
          ),
          gapHeight(sp16),
          Text(
            item.symptom ?? '',
            style: p6.copyWith(color: blackColor),
          ),
          gapHeight(sp16),
          RowItem(
              title: 'Ngày khám', content: Date.formatDateTime(item.createdAt)),
          gapHeight(sp16),
          RowItem(
              title: 'Số lần tái khám', content: item.reExamination.toString()),
        ],
      ),
    );
  }
}
