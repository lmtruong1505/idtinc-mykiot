import 'package:auto_route/auto_route.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/two_button_box.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_cubit.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_detail_cubit/debt_detail_cubit.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_detail_cubit/debt_detail_state.dart';
import 'package:pharmago/presentation/features/debt/domain/entities/debt_note_entity.dart';
import 'package:pharmago/presentation/features/debt/screens/debt_list_page.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

@RoutePage()
class DebtDetailPage extends StatefulWidget {
  const DebtDetailPage({
    super.key,
    required this.debtType,
    required this.id,
  });

  @override
  State<DebtDetailPage> createState() => _DebtDetailPageState();

  final DebtNoteType debtType;
  final int id;
}

class _DebtDetailPageState extends State<DebtDetailPage> {
  final _detailCubit = getIt.get<DebtDetailCubit>();

  late ExpandableController expandableController;
  final _repaymentTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DebtDetailCubit>(
      create: (context) => _detailCubit..getDetail(debtId: widget.id),
      child: BlocBuilder<DebtDetailCubit, DebtDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_5,
            appBar: BaseAppBar(
              title:
                  'Chi tiết công nợ ${widget.debtType == DebtNoteType.REVENUE ? DebtNoteType.REVENUE.title.toLowerCase() : DebtNoteType.EXPENSE.title.toLowerCase()}',
            ),
            body: Container(
              height: heightDevice(context),
              width: widthDevice(context),
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp24,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: state.isLoading
                    ? const BaseLoading()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(sp16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp8),
                              color: whiteColor,
                            ),
                            child: Visibility(
                              visible: state.debtNoteData != null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.debtNoteData?.title ??
                                        'Không tìm thấy dữ liệu',
                                    style: h3,
                                  ),
                                  Text(
                                    state.debtNoteData?.code ??
                                        'Không tìm thấy dữ liệu',
                                    style: p6.copyWith(color: greyColor),
                                  ),
                                  gapHeight(sp12),
                                  Visibility(
                                    visible: state.debtNoteData?.status != null,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: sp8,
                                        horizontal: sp16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: state.debtNoteData?.statusData?.backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                      ),
                                      child: Text(
                                        DebtNoteStatus.values
                                            .firstWhere(
                                              (element) =>
                                                  element.code ==
                                                  state.debtNoteData!.status,
                                            )
                                            .title,
                                        style: p5.copyWith(color: state.debtNoteData?.statusData?.color),
                                      ),
                                    ),
                                  ),
                                  gapHeight(sp16),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: bg_5,
                                      borderRadius: BorderRadius.circular(sp8),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'Tổng tiền',
                                        style: p4.copyWith(color: greyColor),
                                      ),
                                      subtitle: Text(
                                        '${FormatCurrency(state.debtNoteData?.money ?? 0)} đ',
                                        style: h4.copyWith(color: blackColor),
                                      ),
                                    ),
                                  ),
                                  gapHeight(sp16),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: bg_5,
                                      borderRadius: BorderRadius.circular(sp8),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'Đã thanh toán',
                                        style: p4.copyWith(color: greyColor),
                                      ),
                                      subtitle: Text(
                                        '${FormatCurrency(state.debtNoteData?.paymented ?? 0)} đ',
                                        style: h4.copyWith(color: blackColor),
                                      ),
                                    ),
                                  ),
                                  gapHeight(sp16),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: bg_5,
                                      borderRadius: BorderRadius.circular(sp8),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'Còn lại',
                                        style: p4.copyWith(color: greyColor),
                                      ),
                                      subtitle: Text(
                                        '${FormatCurrency((state.debtNoteData?.money ?? 0) - (state.debtNoteData?.paymented ?? 0))} đ',
                                        style: h4.copyWith(color: green_1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          gapHeight(sp16),
                          ExpandablePanel(
                            controller: expandableController,
                            theme: const ExpandableThemeData(
                              hasIcon: false,
                            ),
                            header: Container(
                              padding: const EdgeInsets.all(sp16),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.vertical(
                                  top: const Radius.circular(sp8),
                                  bottom: Radius.circular(
                                    expandableController.expanded ? sp0 : sp8,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Thông tin khoản nợ',
                                    style: h5.copyWith(color: blackColor),
                                  ),
                                  AnimatedRotation(
                                    turns: !expandableController.expanded
                                        ? 0
                                        : 0.5,
                                    duration: const Duration(milliseconds: 300),
                                    child: IcSvg.asset('/ic_arrow_down.svg'),
                                  ),
                                ],
                              ),
                            ),
                            collapsed: const SizedBox(),
                            expanded: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(sp16).copyWith(top: 0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(sp12),
                                ),
                                color: whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: blackColor.withOpacity(0.1),
                                    offset: const Offset(1, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      state.debtNoteData?.entity?.name ??
                                          'Không có dữ liệu',
                                      style: h4.copyWith(color: blackColor),
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Đối tượng: ',
                                            style:
                                                p5.copyWith(color: greyColor),
                                          ),
                                          TextSpan(
                                            text: 'Khách hàng',
                                            style:
                                                p5.copyWith(color: blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Người tạo',
                                        style: p5.copyWith(color: greyColor),
                                      ),
                                      const Spacer(),
                                      Text(
                                        state.debtNoteData?.userCreatedName ??
                                            'Không có dữ liệu',
                                        style: h6,
                                      ),
                                    ],
                                  ),
                                  gapHeight(sp8),
                                  Row(
                                    children: [
                                      Text('Ngày ghi nợ',
                                          style: p5.copyWith(color: greyColor)),
                                      const Spacer(),
                                      Text(
                                        state.debtNoteData?.debtNoteAt != null
                                            ? DateFormat('HH:mm dd-MM-yyyy')
                                                .format(state
                                                    .debtNoteData!.debtNoteAt!)
                                            : 'Không có dữ liệu',
                                        style: h6,
                                      ),
                                    ],
                                  ),
                                  gapHeight(sp8),
                                  Row(
                                    children: [
                                      Text('Hạn trả',
                                          style: p5.copyWith(color: greyColor)),
                                      const Spacer(),
                                      Text(
                                        state.debtNoteData?.exprise != null
                                            ? DateFormat('HH:mm dd-MM-yyyy')
                                                .format(state
                                                    .debtNoteData!.exprise!)
                                            : 'Không có dữ liệu',
                                        style: h6,
                                      ),
                                    ],
                                  ),
                                  gapHeight(sp8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(sp12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(sp8),
                                      color: bg_5,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Ghi chú: ',
                                              style: h6.copyWith(
                                                  color: blackColor)),
                                          TextSpan(
                                              text: state.debtNoteData?.note ??
                                                  'Không có ghi chú',
                                              style: p5.copyWith(
                                                  color: greyColor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          gapHeight(sp16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lịch sử thanh toán',
                                style: h5,
                              ),
                              Visibility(
                                visible: state.debtNoteData?.statusData !=
                                    DebtNoteStatus.SETTLED,
                                child: IconButton(
                                  onPressed: _showDialogAddRepayment,
                                  icon: const Icon(Icons.add_rounded),
                                ),
                              ),
                            ],
                          ),
                          gapHeight(sp16),
                          state.debtNoteData?.repayments?.isEmpty ?? true
                              ? const EmptyContainer()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final data =
                                        state.debtNoteData!.repayments![index];
                                    return PaymentCard(data: data);
                                  },
                                  separatorBuilder: (context, index) =>
                                      gapHeight(sp16),
                                  itemCount:
                                      state.debtNoteData?.repayments?.length ??
                                          0,
                                ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDialogAddRepayment() async {
    await showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: whiteColor.withOpacity(0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(sp12),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: sp24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp12),
                color: whiteColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(sp16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khoảng tiền thanh toán',
                            style: p3.copyWith(color: blackColor),
                          ),
                          gapHeight(sp24),
                          InputCurrency(
                            label: 'Số tiền',
                            hintText: 'Nhập số tiền thanh toán',
                            controller: _repaymentTEC,
                            validate: (value) {
                              final debt = _detailCubit.state.debtNoteData;
                              if ((int.tryParse(
                                        (value ?? '').replaceAll('.', ''),
                                      ) ??
                                      0) >
                                  ((debt?.money ?? 0) -
                                      (debt?.paymented ?? 0))) {
                                return 'Số tiền vượt quá công nợ';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  TwoButtonBox(
                    extraTitle: 'Huỷ bỏ',
                    mainTitle: 'Thêm',
                    borderRadius: BorderRadius.circular(sp12),
                    extraOnTap: () => Navigator.of(context).pop(),
                    mainOnTap: _addRepaymentHandle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    _repaymentTEC.clear();
  }

  void _addRepaymentHandle() {
    final validate = _formKey.currentState?.validate();
    if (!(validate ?? true)) return;
    _detailCubit.createRepaymet(_repaymentTEC.text).then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
            content: Text(
              'Tạo thanh toán công nợ thành công',
              style: p5.copyWith(color: whiteColor),
            ),
            backgroundColor: green_1,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
            content: Text(
              'Tạo thanh toán công nợ thành công',
              style: p5.copyWith(color: whiteColor),
            ),
            backgroundColor: red_1,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.data});

  final RepaymentEntity data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(sp16).copyWith(top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp8),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              data.code ?? 'Không có dữ liệu',
              style: h4.copyWith(color: blackColor),
            ),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Người tạo thanh toán: ',
                    style: p5.copyWith(color: greyColor),
                  ),
                  TextSpan(
                    text: data.userCreatedName ?? '',
                    style: h6.copyWith(color: blackColor),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: sp8,
          ),
          Row(
            children: [
              Text(
                'Số tiền thanh toán',
                style: p5.copyWith(color: greyColor),
              ),
              const Spacer(),
              Text(
                '${FormatCurrency(data.money ?? 0)} đ',
                style: h6,
              ),
            ],
          ),
          gapHeight(sp8),
          Row(
            children: [
              Text('Ngày ghi nợ', style: p5.copyWith(color: greyColor)),
              const Spacer(),
              Text(
                data.createdAt != null
                    ? DateFormat('HH:mm dd-MM-yyyy').format(data.createdAt!)
                    : 'Không có dữ liệu',
                style: h6,
              ),
            ],
          ),
          // gapHeight(sp8),
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(sp12),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(sp8),
          //     color: bg_5,
          //   ),
          //   child: RichText(
          //     text: TextSpan(
          //       children: [
          //         TextSpan(
          //             text: 'Ghi chú: ', style: h6.copyWith(color: blackColor)),
          //         TextSpan(
          //             text: data.note ?? 'Không có ghi chú',
          //             style: p5.copyWith(color: greyColor)),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
