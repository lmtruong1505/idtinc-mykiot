import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/customer_search.view.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../../../shared/components/bg/bg_btn_nav_bar.dart';
import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../../../features_v2/models/customer/v2/customer_model.dart';
import '../../../../features_v2/models/service/service.dart';
import '../../../../features_v2/screens/event/components/event_select_customer.dart';
import '../../../../features_v2/screens/order/components/bts/bts_add_customer.dart';
import '../../../customer/data/models/medical_record_customer_model.dart';
import '../../data/models/appointment_schedule_model.dart';
import '../../data/models/diagnosis_model.dart';
import '../cubits/medical_schedule_editor_cubit/medical_schedule_editor_cubit.dart';
import '../cubits/medical_schedule_editor_cubit/medical_schedule_editor_state.dart';
import '../widgets/file_picker_view.dart';
import '../widgets/info_customer.view.dart';
import '../widgets/schedule_dialog.dart';
import '../widgets/service_select_dialog.dart';
import '../widgets/setting_remind_dialog.dart';

@RoutePage()
class MedicalScheduleEditorPage extends StatefulWidget {
  const MedicalScheduleEditorPage({
    super.key,
    this.detailSchedule,
    this.diagnosis,
  });

  final AppointmentScheduleModel? detailSchedule;
  final DiagnosisModel? diagnosis;

  @override
  State<MedicalScheduleEditorPage> createState() =>
      _MedicalScheduleEditorPageState();
}

class _MedicalScheduleEditorPageState extends State<MedicalScheduleEditorPage> {
  final _medicalScheduleEditorCubit = getIt.get<MedicalScheduleEditorCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.detailSchedule != null && widget.diagnosis != null) {
      _medicalScheduleEditorCubit.initData(
        widget.detailSchedule!,
        widget.diagnosis!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.unFocus();
      },
      child: BlocProvider(
        create: (context) => _medicalScheduleEditorCubit,
        child: Scaffold(
          appBar: AppBarTitleCenter(
            title: 'Tạo mới lịch khám',
          ),
          bottomNavigationBar: _buildBtnBar(),
          body: SingleChildScrollView(
            padding: 16.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocSelector<MedicalScheduleEditorCubit,
                    MedicalScheduleEditorState, CustomerV2Model?>(
                  selector: (state) => state.customer,
                  builder: (context, customer) {
                    return EventSelectCustomer(
                      model: customer,
                      type: 'IDENTIFIED',
                      onEdit: customer?.id == null
                          ? () {
                              context.bottomSheet(
                                BtsAddCustomer(
                                  model: customer,
                                  isEvent: false,
                                  title: 'Chỉnh sửa khách hàng',
                                  success: (value) {
                                    _medicalScheduleEditorCubit
                                        .customerChange(value);
                                    _patientHandle(value);
                                  },
                                ),
                              );
                            }
                          : null,
                      onChanged: (value) {
                        _medicalScheduleEditorCubit.customerChange(value);
                        _patientHandle(value);
                      },
                    );
                  },
                ),
                _moreInfoEditorView,
                context.padding.bottom.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _moreInfoEditorView {
    return BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
        CustomerV2Model?>(
      selector: (state) => state.customer,
      builder: (context, customer) {
        if (customer == null) {
          return const SizedBox.shrink();
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _patientEditor,
              _formEditor,
              // sp16.height,
              // _imageView,
              sp16.height,
              _fileView,
            ],
          ),
        );
      },
    );
  }

  Widget get _patientEditor {
    return BlocListener<MedicalScheduleEditorCubit, MedicalScheduleEditorState>(
      listener: (context, state) {
        if (state.forMyself) {
          _patientHandle(_medicalScheduleEditorCubit.state.customer);
        } else {
          _patientHandle(null);
        }
      },
      listenWhen: (previous, current) {
        return previous.forMyself != current.forMyself;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sp16.height,
          Text(
            'Đăng ký khám cho',
            style: s14w400.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          sp12.height,
          BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
              bool>(
            selector: (state) {
              return state.forMyself;
            },
            builder: (context, isForMyself) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: sp8,
                        horizontal: sp12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        border: Border.all(color: AppColors.border_primary),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Chính mình',
                            style: s14w500.copyWith(
                              color: AppColors.text_primary,
                            ),
                          ),
                          const Spacer(),
                          AppSwitch(
                            value: isForMyself,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              _medicalScheduleEditorCubit.stateChange(
                                forMyself: !isForMyself,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  sp12.width,
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: sp8,
                        horizontal: sp12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp12),
                        border: Border.all(color: AppColors.border_primary),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Người thân',
                            style: s14w500.copyWith(
                              color: AppColors.text_primary,
                            ),
                          ),
                          const Spacer(),
                          AppSwitch(
                            value: !isForMyself,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              _medicalScheduleEditorCubit.stateChange(
                                forMyself: !isForMyself,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
              CustomerV2Model?>(
            selector: (state) {
              return state.patient;
            },
            builder: (context, patient) {
              return Padding(
                padding: const EdgeInsets.only(top: sp16),
                child: patient != null
                    ? InfoCustomerView(
                        customer: _medicalScheduleEditorCubit.state.patient!,
                        onClose: _medicalScheduleEditorCubit.state.forMyself
                            ? null
                            : () {
                                _medicalScheduleEditorCubit.patientChange(null);
                              },
                        onEdit: () {
                          context.bottomSheet(
                            BtsAddCustomer(
                              model: _medicalScheduleEditorCubit.state.patient,
                              isEvent: false,
                              title: 'Chỉnh sửa khách hàng',
                              success: (value) {
                                _medicalScheduleEditorCubit
                                    .patientChange(value);
                                if (_medicalScheduleEditorCubit
                                    .state.forMyself) {
                                  _medicalScheduleEditorCubit
                                      .customerChange(value);
                                }
                              },
                            ),
                          );
                        },
                      )
                    : CustomerSearchView(
                        onChanged: _patientHandle,
                        type: 'IDENTIFIED',
                        titleDialog: 'Tạo mới người thân',
                        parentCustomer:
                            _medicalScheduleEditorCubit.state.customer?.id,
                      ),
              );
            },
          ),
          sp12.height,
          BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
              List<MedicalRecordCustomerModel>>(
            selector: (state) {
              return state.medicalRecords;
            },
            builder: (context, medicalRecords) {
              if (medicalRecords.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp12),
                    color: bg_2,
                  ),
                  child: Text(
                    'Chưa có thông tin lịch sử khám',
                    style: s12w500.copyWith(color: AppColors.text_primary),
                  ),
                );
              }
              return SizedBox(
                width: widthDevice(context),
                height: sp80,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: sp12,
                    children: medicalRecords.map((e) {
                      return Container(
                        width: widthDevice(context) * 3 / 4,
                        padding: const EdgeInsets.all(sp12),
                        decoration: BoxDecoration(
                          color: AppColors.grey10,
                          borderRadius: BorderRadius.circular(sp16),
                          border: Border.all(color: AppColors.ultility_gray_20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(sp4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    border: Border.all(
                                      color: AppColors.blue50,
                                    ),
                                  ),
                                  child: Text(
                                    e.code ?? '',
                                    style: s10w500.copyWith(
                                      color: AppColors.blue70,
                                    ),
                                  ),
                                ),
                                sp12.width,
                                Container(
                                  padding: const EdgeInsets.all(sp4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    color: AppColors.white,
                                  ),
                                  child: Text(
                                    '${e.appointmentCount} lần khám',
                                    style: s12w600.copyWith(
                                      color: AppColors.grey90,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                sp4.height,
                                Text(
                                  'Khám gần nhất: ${e.latestAppointmentDate?.fomatCustom()}',
                                  style: s10w400.copyWith(
                                    color: AppColors.grey60,
                                  ),
                                ),
                              ],
                            ),
                            sp4.height,
                            Text(
                              e.nameVn ?? '',
                              style: s14w500.copyWith(
                                color: AppColors.grey80,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _patientHandle(CustomerV2Model? value) {
    _medicalScheduleEditorCubit.patientChange(value);
  }

  Widget get _formEditor {
    return BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
        CustomerV2Model?>(
      selector: (state) => state.patient,
      builder: (context, patient) {
        if (patient == null) return const SizedBox.shrink();
        final state = _medicalScheduleEditorCubit.state;
        return Column(
          children: [
            sp16.height,
            InputColumn(
              initialValue: state.trieuChung,
              label: 'Triệu chứng',
              hintText: 'Nhập triệu chứng',
              maxLength: 40,
              minLines: 3,
              radius: sp12,
              padding: const EdgeInsets.all(sp0),
              onChanged: (value) {
                _medicalScheduleEditorCubit.stateChange(trieuChung: value);
              },
            ),
            sp12.height,
            Row(
              children: [
                Expanded(
                  child: InputColumn(
                    initialValue: state.mach,
                    label: 'Mạch',
                    hintText: 'Nhập số',
                    textInputType: TextInputType.number,
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Lần/phút',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _medicalScheduleEditorCubit.stateChange(
                        mach: value,
                      );
                    },
                  ),
                ),
                sp12.width,
                Expanded(
                  child: InputColumn(
                    initialValue: state.nhietDo,
                    label: 'Nhiệt độ',
                    hintText: 'Nhập số',
                    textInputType: TextInputType.number,
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        '°C',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _medicalScheduleEditorCubit.stateChange(
                        nhietDo: value,
                      );
                    },
                  ),
                ),
              ],
            ),
            sp12.height,
            Row(
              children: [
                Expanded(
                  child: InputColumn(
                    initialValue: state.huyetAp,
                    label: 'Huyết áp',
                    hintText: 'VD: 120/120',
                    // textInputType: TextInputType.number,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9\/\*\-\+.,]'),
                      ),
                    ],
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'mmHg',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _medicalScheduleEditorCubit.stateChange(
                        huyetAp: value,
                      );
                    },
                  ),
                ),
                sp12.width,
                Expanded(
                  child: InputColumn(
                    initialValue: state.nhipTho,
                    label: 'Nhịp thở',
                    hintText: 'Nhập số',
                    textInputType: TextInputType.number,
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Lần/phút',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _medicalScheduleEditorCubit.stateChange(
                        nhipTho: value,
                      );
                    },
                  ),
                ),
              ],
            ),
            sp12.height,
            Row(
              children: [
                Expanded(
                  child: InputColumn(
                    initialValue: state.canNang,
                    label: 'Cân nặng',
                    hintText: 'Nhập số',
                    textInputType: TextInputType.number,
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Kg',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _medicalScheduleEditorCubit.stateChange(
                        canNang: value,
                      );
                    },
                  ),
                ),
                sp12.width,
                Expanded(
                  child: InputColumn(
                    initialValue: state.chieuCao,
                    label: 'Chiều cao',
                    hintText: 'Nhập số',
                    textInputType: TextInputType.number,
                    maxLength: 40,
                    radius: sp12,
                    padding: const EdgeInsets.all(sp0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Text(
                        'Cm',
                        style: s14w400.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _medicalScheduleEditorCubit.stateChange(
                        chieuCao: value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBtnBar() {
    return BgBtnNavBar(
      child: DoubleButton(
        confirmText: 'Khám trực tiếp',
        cancelText: 'Đặt lịch',
        onCancel: _pickTimeHandle,
        onConfirm: _serviceSelectDialog,
      ),
    );
  }

  void _pickTimeHandle() async {
    if (!_validate) return;
    ScheduleDialog.show(
      context,
      selectedDateTime: _medicalScheduleEditorCubit.state.timeBooking,
      isUseZaloOa: _medicalScheduleEditorCubit.state.isUseZaloOa,
      scheduleNote: _medicalScheduleEditorCubit.state.scheduleNote,
      onConfirm: (p0, p1, p2) {
        _medicalScheduleEditorCubit.stateChange(
          timeBooking: p0,
          isUseZaloOa: p1,
          scheduleNote: p2,
        );
        _serviceSelectDialog();
      },
      onSettingRemind: () {
        Navigator.of(context).pop();
        SettingRemindDialog.show(
          context,
          data: _medicalScheduleEditorCubit.state.remindData,
          note: _medicalScheduleEditorCubit.state.remindNote,
          callBack: (p0, p1) {
            _medicalScheduleEditorCubit.stateChange(
              remindData: p0,
              remindNote: p1,
            );
            _serviceSelectDialog();
          },
        );
      },
    );
  }

  // Widget get _imageView {
  //   return BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
  //       List<File>>(
  //     selector: (state) {
  //       return state.images;
  //     },
  //     builder: (context, images) {
  //       return ImagePickerView(
  //         images: images,
  //         callBack: (images) {
  //           final listCopy = List<File>.from(
  //             _medicalScheduleEditorCubit.state.images,
  //           );
  //           final imagesConvert = images.map((e) => File(e.path)).toList();
  //           listCopy.addAll(imagesConvert);
  //           _medicalScheduleEditorCubit.stateChange(images: imagesConvert);
  //         },
  //         onDelete: _medicalScheduleEditorCubit.deleteImage,
  //       );
  //     },
  //   );
  // }

  Widget get _fileView {
    return BlocSelector<MedicalScheduleEditorCubit, MedicalScheduleEditorState,
        List<File>>(
      selector: (state) {
        return state.files;
      },
      builder: (context, files) {
        return FilePickerView(
          files: files,
          callBack: (files) {
            final listCopy =
                List<File>.from(_medicalScheduleEditorCubit.state.files);
            listCopy.addAll(files);
            _medicalScheduleEditorCubit.stateChange(files: listCopy);
          },
          removeCallBack: _medicalScheduleEditorCubit.deleteFile,
        );
      },
    );
  }

  void _serviceSelectDialog() {
    if (!_validate) return;
    ServiceSelectDialog.show(
      context,
      services: _medicalScheduleEditorCubit.state.services,
      callBack: _callBackServiceDialog,
    );
  }

  void _callBackServiceDialog(List<ServiceV2Model> services) async {
    _medicalScheduleEditorCubit.stateChange(services: services);
    _medicalScheduleEditorCubit.state.idSchedule == null
        ? _createHandle()
        : _updateHandle();
  }

  void _createHandle() async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang đặt lịch hẹn, vui lòng đợi',
    );
    final res = await _medicalScheduleEditorCubit.create();
    if (!mounted) return;
    context.pop();
    if (res != null) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Tạo lịch khám thành công',
        titleClose: 'Danh sách lịch khám',
        titleConfirm: 'Chi tiết lịch hẹn',
        close: () {
          context.pop();
          context.pop();
        },
        accept: () {
          context.pop();
          context.pop();
          context.router.push(
            MedicalScheduleDetailRoute(id: res),
          );
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Đặt lịch hẹn thất bại',
      );
    }
  }

  void _updateHandle() async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang cập nhật lịch hẹn, vui lòng đợi',
    );
    final res = await _medicalScheduleEditorCubit.update();
    if (!mounted) return;
    context.pop();
    if (res != null) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Cập nhật lịch khám thành công',
        titleClose: 'Danh sách lịch khám',
        titleConfirm: 'Chi tiết lịch hẹn',
        close: () {
          context.pop();
          context.pop();
          context.pop();
        },
        accept: () {
          context.router.popUntil(
            (route) => route.settings.name == MedicalScheduleDetailRoute.name,
          );
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật lịch hẹn thất bại',
      );
    }
  }

  bool get _validate {
    if (_medicalScheduleEditorCubit.state.customer == null) {
      toastification.show(
        title: const Text('Vui lòng chọn khách hàng'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return false;
    }

    if (_medicalScheduleEditorCubit.state.patient == null) {
      toastification.show(
        title: const Text('Vui lòng chọn đối tượng khám bệnh'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return false;
    }
    return true;
  }
}
