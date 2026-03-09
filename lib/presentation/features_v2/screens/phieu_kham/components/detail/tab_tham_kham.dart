import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/file_customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/param/param_update.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/phieu_kham_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/calendar/event_model.dart';
import 'package:pharmago/presentation/features_v2/models/customer/file_model.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/bg_action.dart';
import 'package:pharmago/presentation/features_v2/screens/customer/components/item_benh_an.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/ext_context.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/ext_widget.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../blocs/local/file_bloc.dart';

class TabThamKhamPK extends StatefulWidget {
  final EventModel item;

  const TabThamKhamPK({required this.item});

  @override
  State<TabThamKhamPK> createState() => _TabThamKhamPKState();
}

class _TabThamKhamPKState extends State<TabThamKhamPK> {
  final file1Bloc = FileBloc();
  final file2Bloc = FileBloc();

  final testFileBloc = FileCustomerBloc();
  final diagnosticFileBloc = FileCustomerBloc();

  final bloc = PhieuKhamBloc();

  final symptoms = TextEditingController();
  final diagnostic = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    symptoms.text = widget.item.symptoms ?? '';
    diagnostic.text = widget.item.diagnostic ?? '';
    testFileBloc.getList(
      customerId: widget.item.customerId ?? 0,
      companyId: getCompany ?? 0,
      uuidBill: widget.item.uuid,
      type: TypeFileCustomer.test,
    );
    diagnosticFileBloc.getList(
      customerId: widget.item.customerId ?? 0,
      companyId: getCompany ?? 0,
      uuidBill: widget.item.uuid,
      type: TypeFileCustomer.diagnostic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PhieuKhamBloc, CubitState>(
          bloc: bloc,
          listener: (context, state) {
            CheckStateBloc.check(
              context,
              state,
              successBtnText: 'Đóng',
            );
          },
        ),
        BlocListener<FileBloc, CubitState>(
          bloc: file1Bloc,
          listener: (context, state) {
            CheckStateBloc.check(
              context,
              state,
              success: () {
                testFileBloc.getList(
                  customerId: widget.item.customerId ?? 0,
                  companyId: getCompany ?? 0,
                  uuidBill: widget.item.uuid,
                  type: TypeFileCustomer.test,
                );
                context.pop();
              },
            );
          },
        ),
        BlocListener<FileBloc, CubitState>(
          bloc: file2Bloc,
          listener: (context, state) {
            CheckStateBloc.check(
              context,
              state,
              success: () {
                diagnosticFileBloc.getList(
                  customerId: widget.item.customerId ?? 0,
                  companyId: getCompany ?? 0,
                  uuidBill: widget.item.uuid,
                  type: TypeFileCustomer.diagnostic,
                );
                context.pop();
              },
            );
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: sp16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInput(
              onTap: () {
                bloc.update(
                  id: widget.item.id ?? 0,
                  param: ParamUpdatedPk(
                    symptoms: symptoms.text,
                  ),
                );
                widget.item.symptoms = symptoms.text;
              },
              title: 'Ghi chú/mô tả thăm khám',
              controller: symptoms,
            ),
            sp16.height,
            _buildInput(
              onTap: () {
                bloc.update(
                  id: widget.item.id ?? 0,
                  param: ParamUpdatedPk(
                    diagnostic: diagnostic.text,
                  ),
                );
                widget.item.diagnostic = diagnostic.text;
              },
              title: 'Kế hoạch điều trị',
              controller: diagnostic,
            ),
            sp16.height,
            BlocBuilder<FileCustomerBloc, CubitState>(
              bloc: testFileBloc,
              builder: (context, state) {
                return _buildUploadFile(
                  onTap: () {
                    file1Bloc.uploadFile(
                      customerId: widget.item.customerId ?? 0,
                      type: TypeFileCustomer.test.code,
                      medicalBill: widget.item.uuid,
                    );
                  },
                  delete: (p0) => file1Bloc.remove(p0),
                  files: testFileBloc.list,
                  title: 'Kết quả xét nghiệm',
                );
              },
            ),
            sp16.height,
            BlocBuilder<FileCustomerBloc, CubitState>(
              bloc: diagnosticFileBloc,
              builder: (context, state) {
                return _buildUploadFile(
                  onTap: () {
                    file2Bloc.uploadFile(
                      customerId: widget.item.customerId ?? 0,
                      type: TypeFileCustomer.diagnostic.code,
                      medicalBill: widget.item.uuid,
                    );
                  },
                  delete: (p0) => file2Bloc.remove(p0),
                  files: diagnosticFileBloc.list,
                  title: 'Kết quả chuẩn đoán',
                );
              },
            ),
            context.padding.bottom.height,
          ],
        ),
      ),
    );
  }

  Widget _buildUploadFile({
    required String title,
    Function()? onTap,
    List<FileModel> files = const [],
    Function(int)? delete,
  }) {
    return BgAction(
      title: title,
      isTextClick: false,
      click: true,
      fontSize: 14,
      colorTitle: ColorApp.grey47,
      child: Container(
        padding: sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ItemFile(
                item: files[index],
                isBorder: true,
              ),
              separatorBuilder: (context, index) => sp16.height,
              itemCount: files.length,
            ),
            if (files.isNotEmpty) sp16.height,
            MainButtonV2(
              onTap: onTap,
              title: 'Tải lên ${title.toLowerCase()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String title,
    String? initialValue,
    bool readOnly = false,
    Function()? onTap,
    Function(String)? onChanged,
    TextEditingController? controller,
  }) {
    return Container(
      padding: sp16.pading,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                title,
                style: StyleApp.normal(fontSize: 16),
              ).expanded(),
              12.width,
              InkWell(
                onTap: onTap,
                child: Text(
                  //readOnly ? 'Chỉnh sửa' : 'Lưu',
                  'Chỉnh sửa',
                  style: StyleApp.normal(
                    fontSize: 16,
                    color: ColorApp.blue20,
                  ),
                ),
              ),
            ],
          ),
          sp16.height,
          AppInputV2(
            initialValue: initialValue,
            hintText: 'Nhập ${title.toLowerCase()}',
            maxLines: null,
            minLines: 5,
            radius: 8,
            readOnly: readOnly,
            onChanged: onChanged,
            controller: controller,
          ),
        ],
      ),
    );
  }
}
