import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_cubit.dart';
import 'package:pharmago/presentation/features/debt/cubit/debt_create_cubit/debt_create_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import '../../product/domain/entities/basic_entity.dart';
import '../widgets/overlay_suggest_entity.dart';

@RoutePage()
class DebtCreatePage extends StatefulWidget {
  const DebtCreatePage({
    super.key,
    required this.debtType,
    required this.onSuccess,
  });

  @override
  State<DebtCreatePage> createState() => _DebtCreatePageState();

  final DebtNoteType debtType;
  final Function onSuccess;
}

class _DebtCreatePageState extends State<DebtCreatePage>
    with TickerProviderStateMixin {
  late FocusNode _fnCustomer;
  late OverlayEntry? _overlayEntry;
  late AnimationController _controllerDropdownAnimation;
  late Animation<double> _animationDropDown;

  final _cubit = getIt.get<DebtCreateCubit>();

  final LayerLink _layerLinkEntity = LayerLink();
  final _name = TextEditingController();

  final inputDebitDateController = TextEditingController();
  final inputExpriseDateController = TextEditingController();
  final inputTotalMoneyController = TextEditingController();
  final inputPaymentedMoneyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _controllerDropdownAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animationDropDown = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(_controllerDropdownAnimation);

    _fnCustomer = FocusNode()
      ..addListener(() {
        if (_fnCustomer.hasFocus) {
          _overlayEntry = overlaySuggetEntity(
            layerLink: _layerLinkEntity,
            controllerDropdownAnimation: _controllerDropdownAnimation,
            animationDropDown: _animationDropDown,
            myBloc: _cubit,
            onSelected: _selectEntity,
          );
          Overlay.of(context).insert(_overlayEntry!);
          _controllerDropdownAnimation.forward();
        } else {
          _controllerDropdownAnimation.reverse();
          Timer(const Duration(milliseconds: 150), () {
            _overlayEntry?.remove();
          });
        }
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DebtCreateCubit>(
      create: (context) => _cubit..initial(debtType: widget.debtType),
      child: BlocBuilder<DebtCreateCubit, DebtCreateState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_5,
              appBar: BaseAppBar(
                  title:
                      'Tạo công nợ ${widget.debtType == DebtNoteType.REVENUE ? DebtNoteType.REVENUE.title.toLowerCase() : DebtNoteType.EXPENSE.title.toLowerCase()}'),
              body: Container(
                height: heightDevice(context),
                width: widthDevice(context),
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp24,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        gapHeight(sp4),
                        CompositedTransformTarget(
                          link: _layerLinkEntity,
                          child: AppInput(
                            controller: _name,
                            label: 'Đối tượng',
                            required: true,
                            hintText: 'Tìm kiếm theo sđt/mã',
                            backgroundColor: whiteColor,
                            borderColor: whiteColor,
                            fn: _fnCustomer,
                            prefixIcon: SizedBox(
                              width: sp28,
                              height: sp28,
                              child: Center(
                                child: Container(
                                  width: sp28,
                                  height: sp28,
                                  decoration: BoxDecoration(
                                    color: blackColor,
                                    borderRadius: BorderRadius.circular(sp8),
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: whiteColor,
                                    size: sp16,
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              _cubit.checkEntity(value);
                            },
                            onConfirm: (value) {
                              if (value.length == 10 &&
                                  state.suggestEntity.isNotEmpty) {
                                _selectEntity(state.suggestEntity.first);
                              }
                            },
                            onTapOutside: () {
                              if (state.entitySelected == null) {
                                _name.text = '';
                              }
                            },
                            validate: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Vui lòng chọn đối tượng';
                              }
                            },
                          ),
                        ),
                        gapHeight(sp24),
                        AppInput(
                          label: 'Tiêu đề công nợ',
                          hintText: 'Nhập tiêu đề công nợ',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          required: true,
                          onChanged: (value) {
                            _cubit.setValueInput(title: value);
                          },
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập';
                            }
                          },
                        ),
                        gapHeight(sp24),
                        AppInput(
                          label: 'Mã công nợ',
                          hintText: 'Nhập mã công nợ',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          onChanged: (value) {
                            _cubit.setValueInput(code: value);
                          },
                        ),
                        gapHeight(sp24),
                        // const CommonDropdown(
                        //   label: 'Loại phiếu',
                        //   items: [],
                        //   required: true,
                        //   hintText: 'Chọn loại phiếu',
                        //   color: whiteColor,
                        //   borderColor: whiteColor,
                        //   // prefixIcon: SizedBox(
                        //   //   width: sp20,
                        //   //   child: Icon(
                        //   //     Icons.note_add,
                        //   //     size: sp20,
                        //   //     color: mainColor,
                        //   //   ),
                        //   // ),
                        // ),
                        // gapHeight(sp24),
                        InputCurrency(
                          controller: inputTotalMoneyController,
                          label: 'Tổng tiền',
                          hintText: 'Nhập tổng tiền',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          required: true,
                          onChanged: (value) {
                            _cubit.setValueInput(totalMoney: value);
                          },
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập';
                            }
                          },
                        ),
                        gapHeight(sp24),
                        InputCurrency(
                          controller: inputPaymentedMoneyController,
                          initialValue: state.paymented,
                          label: 'Đã thanh toán',
                          hintText: 'Nhập số tiền đã thanh toán',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          required: true,
                          onChanged: (value) {
                            _cubit.setValueInput(paymented: value);
                          },
                          validate: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập';
                            }
                          },
                        ),
                        gapHeight(sp24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppInput(
                                controller: inputDebitDateController,
                                label: 'Ngày ghi nợ',
                                hintText: 'dd/mm/y',
                                backgroundColor: whiteColor,
                                borderColor: whiteColor,
                                radius: sp12,
                                readOnly: true,
                                suffixIcon: SizedBox(
                                  width: sp28,
                                  height: sp28,
                                  child: Center(
                                    child: Container(
                                      width: sp28,
                                      height: sp28,
                                      decoration: BoxDecoration(
                                        color: blackColor,
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: whiteColor,
                                        size: sp16,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  final dates =
                                      await DialogUtils.showCalendarDatePicker(
                                    context,
                                  );
                                  if (dates != null) {
                                    _cubit.setDateInput(debitDate: dates[0]);
                                    inputDebitDateController.text =
                                        Date.formatDateDay(dates[0]);
                                  }
                                },
                              ),
                            ),
                            gapWidth(sp16),
                            Expanded(
                              child: AppInput(
                                controller: inputExpriseDateController,
                                label: 'Hết hạn',
                                hintText: 'dd/mm/y',
                                backgroundColor: whiteColor,
                                borderColor: whiteColor,
                                required: true,
                                radius: sp12,
                                readOnly: true,
                                suffixIcon: SizedBox(
                                  width: sp28,
                                  height: sp28,
                                  child: Center(
                                    child: Container(
                                      width: sp28,
                                      height: sp28,
                                      decoration: BoxDecoration(
                                        color: blackColor,
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month_rounded,
                                        color: whiteColor,
                                        size: sp16,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  final dates =
                                      await DialogUtils.showCalendarDatePicker(
                                          context);
                                  if (dates != null) {
                                    _cubit.setDateInput(expriseDate: dates[0]);
                                    inputExpriseDateController.text =
                                        Date.formatDateDay(dates[0]);
                                  }
                                },
                                validate: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Vui lòng nhập';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        gapHeight(sp24),
                        AppInput(
                          label: 'Ghi chú',
                          hintText: 'Nhập ghi chú',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          maxLines: 3,
                          onChanged: (value) {
                            _cubit.setValueInput(note: value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      blurRadius: sp2,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Tổng tiền',
                    //         style: p5.copyWith(color: greyTextColor),
                    //       ),
                    //       gapHeight(sp4),
                    //       Text(
                    //         '${FormatCurrency(100000)}đ',
                    //         style: p1.copyWith(color: blackColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: MainButton(
                        icon: const Icon(
                          Icons.note_add_rounded,
                          color: whiteColor,
                        ),
                        title: 'Tạo phiếu',
                        event: () {
                          _createReceipt();
                        },
                      ),
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

  void _selectEntity(BasicEntity? item) {
    setState(() {
      _cubit.selectEntity(item);
      _name.text = item?.name ?? '';
      _fnCustomer.unfocus();
    });
  }

  Future<void> _createReceipt() async {
    final bool isValid = formKey.currentState?.validate() ?? false;
    if (isValid) {
      DialogUtils.showLoadingDialog(
        context,
        'Đang tạo công nợ vui lòng đợi',
      );
      await _cubit.createDebtNoteReceipt().then((value) {
        Navigator.of(context).pop();
        if (value.code == 200) {
          // widget.onSuccess?.call();
          // context.router.push(OrderCreateSuccessRoute());
          DialogUtils.showSuccessDialog(
            context,
            content: 'Tạo công nợ thành công',
            titleClose: 'Danh sách',
            titleConfirm: 'Chi tiết',
            close: () => context.router
                .popUntil((route) => route.settings.name == 'DebtListRoute'),
            accept: () {
              context.router.replace(DebtDetailRoute(
                  debtType: widget.debtType, id: value.data ?? 0));
            },
          );
        } else {
          DialogUtils.showErrorDialog(
            context,
            content: 'Tạo công nợ thất bại',
          );
        }
      });
    }
  }
}
