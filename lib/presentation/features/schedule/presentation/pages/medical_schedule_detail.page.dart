import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../base/svg.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../../../features_v2/blocs/enum/enum_calendar_time.dart';
import '../../data/models/appointment_schedule_model.dart';
import '../../data/models/diagnosis_model.dart';
import '../../data/models/prescription_model.dart';
import '../cubits/medical_schedule_editor_cubit/medical_schedule_editor_cubit.dart';
import '../cubits/medical_schedule_manager_cubit/medical_schedule_manager_cubit.dart';
import '../cubits/medical_schedule_manager_cubit/medical_schedule_manager_state.dart';
import '../widgets/diagnosis_view.dart';
import '../widgets/examination_form_view.dart';
import '../widgets/prescription_view.dart';
import '../widgets/services_view.dart';

@RoutePage()
class MedicalScheduleDetailPage extends StatefulWidget {
  const MedicalScheduleDetailPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<MedicalScheduleDetailPage> createState() =>
      _MedicalScheduleDetailPageState();
}

class _MedicalScheduleDetailPageState extends State<MedicalScheduleDetailPage>
    with TickerProviderStateMixin {
  final _medicalScheduleManagerCubit = getIt.get<MedicalScheduleManagerCubit>();
  final _medicalScheduleEditorCubit = getIt.get<MedicalScheduleEditorCubit>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();

    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicalScheduleManagerCubit>(
      create: (context) =>
          _medicalScheduleManagerCubit..getDetailSchedule(widget.id),
      child: BlocListener<MedicalScheduleManagerCubit,
          MedicalScheduleManagerState>(
        listener: (context, state) {
          if (state.detailSchedule != null && state.diagnosis != null) {
            _medicalScheduleEditorCubit.initData(
              state.detailSchedule!,
              state.diagnosis!,
            );
          }
        },
        listenWhen: (previous, current) {
          return previous.detailSchedule != current.detailSchedule ||
              previous.diagnosis != current.diagnosis;
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBarCustom(
            title: 'Trở về',
            subTitle: 'Chi tiết lịch hẹn',
            actions: [
              _buildMenu(),
            ],
          ),
          body: _body,
        ),
      ),
    );
  }

  // Widget get _navBar {
  Widget get _body {
    return BlocSelector<MedicalScheduleManagerCubit,
        MedicalScheduleManagerState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, isLoading) {
        if (isLoading) return const Center(child: BaseLoading());
        return Container(
          width: widthDevice(context),
          height: heightDevice(context),
          child: Column(
            children: [
              _tabBar,
              Expanded(child: _tabBarView),
              // _navBar,
            ],
          ),
        );
      },
    );
  }

  Widget get _tabBar {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: AppColors.border_brandSolid,
      labelColor: AppColors.text_brand_primary_variant1,
      labelStyle: AppStyle.bodyBsMedium,
      unselectedLabelColor: AppColors.text_tertiary,
      unselectedLabelStyle: AppStyle.bodyBsRegular,
      labelPadding: 16.padingHor,
      tabs: const [
        Tab(
          text: 'Phiếu khám',
        ),
        Tab(
          text: 'Dịch vụ',
        ),
        Tab(
          text: 'Chuẩn đoán kết luận',
        ),
        Tab(
          text: 'Đơn thuốc',
        ),
        Tab(
          text: 'Đơn hàng dịch vụ',
        ),
      ],
    );
  }

  Widget get _tabBarView {
    return TabBarView(
      controller: _tabController,
      children: [
        _examinationForm,
        _servicesView,
        _diagnosisView,
        _prescriptionView,
        // _examinationForm,
        Center(child: IcSvg.asset('/ic_empty.svg')),
      ],
    );
  }

  Widget get _examinationForm {
    return BlocSelector<MedicalScheduleManagerCubit,
        MedicalScheduleManagerState, AppointmentScheduleModel?>(
      selector: (state) {
        return state.detailSchedule;
      },
      builder: (context, detailSchedule) {
        if (detailSchedule == null) return const SizedBox.shrink();
        return ExaminationFormView(
          data: detailSchedule,
          cancelCallback: () {
            DialogUtils.showWarningDialog(
              context,
              content: 'Bạn chắc chắn muốn huỷ lịch hẹn',
              close: () => Navigator.of(context).pop(),
              accept: () {
                Navigator.of(context).pop();
                _medicalScheduleManagerCubit.cancel('Huỷ');
              },
            );
          },
          confirmCallback: () {
            final enumStatus = EnumCalendarTime.values.firstWhere(
              (e) => e.code == detailSchedule.status,
            );
            final status = switch (enumStatus) {
              EnumCalendarTime.all => throw UnimplementedError(),
              EnumCalendarTime.booked => EnumCalendarTime.comfirmed.code,
              EnumCalendarTime.comfirmed => EnumCalendarTime.arrived.code,
              EnumCalendarTime.arrived => EnumCalendarTime.consulting.code,
              EnumCalendarTime.consulting => EnumCalendarTime.completed.code,
              EnumCalendarTime.canceled => EnumCalendarTime.comfirmed.code,
              EnumCalendarTime.completed => throw UnimplementedError(),
            };
            _medicalScheduleManagerCubit.updateStatus(status);
          },
          oaCallback: () {
            _medicalScheduleManagerCubit.reSendEventZalo().then((isSuccess) {
              toastification.show(
                title: Text(
                  isSuccess ? 'Gửi lịch hẹn qua Zalo thành công' : 'Lỗi gửi',
                ),
                type: isSuccess
                    ? ToastificationType.success
                    : ToastificationType.warning,
                autoCloseDuration: const Duration(seconds: 3),
              );
            });
          },
        );
      },
    );
  }

  Widget get _servicesView {
    return BlocSelector<MedicalScheduleManagerCubit,
        MedicalScheduleManagerState, AppointmentScheduleModel?>(
      selector: (state) {
        return state.detailSchedule;
      },
      builder: (context, detailSchedule) {
        if (detailSchedule?.services == null) return const SizedBox.shrink();
        return AppointmentScheduleServices(
          services: detailSchedule!.services!,
          idCustomer: detailSchedule.customer!.id!,
          totalPrice: detailSchedule.totalPriceService,
          editCallBack: (p0) {
            _medicalScheduleEditorCubit.stateChange(
              services: p0,
            );
            _medicalScheduleEditorCubit.update().then((_) {
              _medicalScheduleManagerCubit.getDetailSchedule(widget.id);
            });
          },
        );
      },
    );
  }

  Widget get _diagnosisView {
    return BlocSelector<MedicalScheduleManagerCubit,
        MedicalScheduleManagerState, DiagnosisModel?>(
      selector: (state) {
        return state.diagnosis;
      },
      builder: (context, diagnosis) {
        if (diagnosis == null) return const SizedBox.shrink();
        return BlocSelector<MedicalScheduleManagerCubit,
            MedicalScheduleManagerState, AppointmentScheduleModel?>(
          selector: (state) {
            return state.detailSchedule;
          },
          builder: (context, detailSchedule) {
            return DiagnosisView(
              detailSchedule: detailSchedule!,
              diagnosis: diagnosis,
              pathologiesCallback: (list) {
                _medicalScheduleEditorCubit.stateChange(pathologies: list);
                _medicalScheduleEditorCubit.update().then((_) {
                  _medicalScheduleManagerCubit.getDiagnosis();
                });
              },
              conclusionCallBack: (conclusion, note, images, files) {
                toastification.show(
                  title: const Text('Đang xử lý dữ liệu, vui lòng đợi'),
                  type: ToastificationType.info,
                  autoCloseDuration: const Duration(seconds: 5),
                );
                _medicalScheduleEditorCubit.stateChange(
                  conclusion: conclusion,
                  scheduleNote: note,
                  images: images,
                  files: files,
                );
                toastification.show(
                  title: const Text('Cập nhật thông tin thành công'),
                  type: ToastificationType.success,
                  autoCloseDuration: const Duration(seconds: 3),
                );
                _medicalScheduleEditorCubit.updateConclusion().then((_) {
                  _medicalScheduleManagerCubit.getDetailSchedule(widget.id);
                  _medicalScheduleManagerCubit.getDiagnosis();
                });
              },
              serviceConclusionCallBack: (id, conclusion, files, filesUpdate) {
                final listServiceSchedule = _medicalScheduleManagerCubit
                    .state.diagnosis?.appointmentService;
                final serviceSchedule =
                    listServiceSchedule?.firstWhereOrNull((e) => e.id == id);
                if (serviceSchedule?.medicalBillData?.isEmpty ?? true) {
                  _medicalScheduleManagerCubit.createServiceConclusion(
                    idService: id,
                    conclusion: conclusion,
                    files: files,
                  );
                } else {
                  _medicalScheduleManagerCubit.updateServiceConclusion(
                    idService: id,
                    conclusion: conclusion,
                    files: files,
                    filesUpdate: filesUpdate,
                  );
                }
              },
              createPathologyCallBack: (p0, p1) async {
                context.pop();
                final res =
                    await _medicalScheduleManagerCubit.createPathologies(
                  name: p0,
                  code: p1,
                );
                if (res != null) {
                  toastification.show(
                    title: const Text('Tạp mới chuẩn đoán thành công'),
                    type: ToastificationType.success,
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget get _prescriptionView {
    return BlocSelector<MedicalScheduleManagerCubit,
        MedicalScheduleManagerState, PrescriptionModel?>(
      selector: (state) {
        return state.prescription;
      },
      builder: (context, prescription) {
        return PrescriptionView(
          detailSchedule: _medicalScheduleManagerCubit.state.detailSchedule,
          diagnosis: _medicalScheduleManagerCubit.state.diagnosis,
          prescription: prescription,
          callBack: (products) {
            _medicalScheduleManagerCubit.createPrescription(products);
          },
        );
      },
    );
  }

  Widget _buildMenu() {
    return BlocSelector<MedicalScheduleManagerCubit,
        MedicalScheduleManagerState, EnumCalendarTime?>(
      selector: (state) {
        return state.detailSchedule?.enumStatus;
      },
      builder: (context, enumStatus) {
        return PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(sp12),
          ),
          child: const Padding(
            padding: EdgeInsetsGeometry.all(sp16),
            child: Icon(
              Icons.more_vert_rounded,
              color: AppColors.icon_iconPrimary,
            ),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  context.router.push(
                    MedicalScheduleEditorRoute(
                      detailSchedule:
                          _medicalScheduleManagerCubit.state.detailSchedule,
                      diagnosis: _medicalScheduleManagerCubit.state.diagnosis,
                    ),
                  );
                },
                child: Row(
                  children: [
                    FaIcon(iconCode: 'f044'),
                    sp8.width,
                    Text(
                      'Sửa lịch khám',
                      textAlign: TextAlign.center,
                      style: s14w400.copyWith(color: AppColors.text_secondary),
                    ),
                  ],
                ),
              ),
              if (enumStatus != EnumCalendarTime.consulting &&
                  enumStatus != EnumCalendarTime.completed)
                PopupMenuItem(
                  onTap: () {
                    DialogUtils.showWarningDialog(
                      context,
                      content: 'Bạn chắc chắn muốn huỷ lịch hẹn',
                      close: Navigator.of(context).pop,
                      accept: () {
                        context.pop();
                        _medicalScheduleManagerCubit.deleteSchedule().then(
                          (value) {
                            if (value && context.mounted) {
                              context.pop();
                            }
                          },
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      FaIcon(iconCode: 'f1f8'),
                      sp8.width,
                      Text(
                        'Xóa lịch khám',
                        textAlign: TextAlign.center,
                        style:
                            s14w400.copyWith(color: AppColors.text_secondary),
                      ),
                    ],
                  ),
                ),
            ];
          },
        );
      },
    );
  }
}
