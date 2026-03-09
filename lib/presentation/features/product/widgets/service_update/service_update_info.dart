import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features/product/cubit/service_update_cubit/service_update_detail_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/service_update_cubit/service_update_detail_state.dart';

import '../../../../base/date.dart';
import '../../../../base/svg.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../service_create/bts_chose_emp.dart';

class ServiceUpdateInfoBasic extends StatefulWidget {
  const ServiceUpdateInfoBasic({required this.myBloc, super.key});

  final ServiceUpdateDetailCubit myBloc;

  @override
  State<ServiceUpdateInfoBasic> createState() => _ServiceUpdateInfoBasicState();
}

class _ServiceUpdateInfoBasicState extends State<ServiceUpdateInfoBasic> {
  late ExpandableController _expandableController;

  @override
  void initState() {
    _expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceUpdateDetailCubit, ServiceUpdateDetailState>(
      bloc: widget.myBloc,
      builder: (BuildContext context, ServiceUpdateDetailState state) {
        if (state.isLoading) {
          return const BaseLoading();
        }
        return ExpandableNotifier(
          controller: _expandableController,
          child: ExpandablePanel(
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
                    _expandableController.expanded ? sp0 : sp8,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thông tin cơ bản',
                    style: p3.copyWith(color: blackColor),
                  ),
                  AnimatedRotation(
                    turns: !_expandableController.expanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: IcSvg.asset('/ic_arrow_down.svg'),
                  ),
                ],
              ),
            ),
            collapsed: Container(),
            expanded: _buildExpanded(context, state),
          ),
        );
      },
    );
  }

  Widget _buildExpanded(BuildContext context, ServiceUpdateDetailState state) {
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
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
          const Divider(),
          state.imageService != null
              ? Container(
                  width: widthDevice(context),
                  height: widthDevice(context) * 0.5,
                  margin: const EdgeInsets.only(top: sp12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    image: DecorationImage(
                      image: FileImage(state.imageService!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : gapHeight(sp0),
          gapHeight(sp12),
          InkWell(
            onTap: () async {
              final picker = ImagePicker();
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                widget.myBloc.imageServiceChange(image);
              }
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(sp12),
              padding: const EdgeInsets.all(sp12),
              color: blue_1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.upload_rounded,
                    size: sp20,
                    color: blue_1,
                  ),
                  gapWidth(sp12),
                  Text(
                    'Tải lên ảnh/video',
                    style: p5.copyWith(color: blue_1),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Chấp nhận định dạng .png, .jpg, .jpeg',
            style: p6.copyWith(color: greyColor),
          ),
          gapHeight(sp16),
          AppInput(
            initialValue: (state.service?.title == null)
                ? 'NULL'
                : state.service?.title ?? '',
            label: 'Tên dịch vụ',
            required: true,
            hintText: 'Nhập tên dịch vụ',
            backgroundColor: bg_4,
            borderColor: bg_4,
            textInputType: TextInputType.text,
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng điền tên dịch vụ';
              }
            },
            onChanged: (value) => widget.myBloc.infoFormChange(title: value.trim()),
          ),
          gapHeight(sp16),
          AppInput(
            initialValue: state.service?.entity ?? '',
            label: 'Đối tượng',
            hintText: 'Nhập tên đối tượng',
            backgroundColor: bg_4,
            borderColor: bg_4,
            textInputType: TextInputType.text,
            onChanged: (value) => widget.myBloc.infoFormChange(entity: value.trim()),
          ),
          gapHeight(sp16),
          AppInput(
            required: true,
            controller: TextEditingController(
              text: state.service?.staff?.username ?? '',
            ),
            hintText: 'Chọn nhân viên',
            label: 'Nhân viên phòng khám',
            backgroundColor: bg_4,
            borderColor: bg_4,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng chọn nhân viên';
              }
            },
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(sp12),
                  ),
                ),
                enableDrag: false,
                context: context,
                builder: (context) => BTSChoseEmp(
                  staffSelected: state.service?.staff,
                  onConfirm: (value) {
                    widget.myBloc.selectStaff(value);
                    FocusScope.of(context).unfocus();
                  },
                ),
              );
            },
          ),
          gapHeight(sp16),
          AppInput(
            hintText: 'Nhập tần suất',
            label: 'Tần suất sử dụng',
            initialValue: state.service?.frequency ?? '',
            backgroundColor: bg_4,
            borderColor: bg_4,
            textInputType: TextInputType.text,
            onChanged: (value) =>
                widget.myBloc.infoFormChange(frequency: value.trim()),
          ),
          gapHeight(sp16),
          AppInput(
            initialValue: Date.convertSecondToDay(
              state.service?.reminderTime ?? 259200,
            ).toString(),
            hintText: 'Chọn thời gian nhắc hẹn ',
            label: 'Thời gian nhắc hẹn (ngày)',
            backgroundColor: bg_4,
            borderColor: bg_4,
            textInputType: TextInputType.number,
            onChanged: (value) {
              widget.myBloc.reminderTimeChange(value.trim());
            },
          ),
        ],
      ),
    );
  }
}
