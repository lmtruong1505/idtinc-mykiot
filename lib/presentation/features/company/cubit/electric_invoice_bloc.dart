import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/data/models/electric_invoice_user_model.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/electric_invoice_repository.dart';
import 'package:xml/xml.dart';

import '../../../features_v2/blocs/state/init_state.dart';

class ElectricInvoiceBloc extends Cubit<CubitState> {
  ElectricInvoiceBloc() : super(CubitState());
  final _repo = getIt<ElectricInvoiceRepository>();

  String? name;
  String? serial;
  String? pattern;
  bool defaultFlag = false;

  bool showPasswordAdmin = false;
  bool showPasswordServer = false;
  ElectricInvoiceAccountModel? userResponse;
  ElectricInvoiceUserModel? userInfor;
  List<UserSerialModel>? userSerials;

  void showHidePasswordAdmin() {
    showPasswordAdmin = !showPasswordAdmin;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void showHidePasswordServer() {
    showPasswordServer = !showPasswordServer;
    emit(state.copyWith(status: BlocStatus.reload));
  }

  void validInfor({
    required String userSer,
    required String passwordSer,
    required String link,
    required BuildContext context,
  }) async {
    DialogUtils.showLoadingDialog(context, 'Đang kiểm tra vui lòng đợi!');
    final id = getAccountId ?? 0;
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.validInfor(userSer, passwordSer, link, id);
    Navigator.of(context).pop();
    if (res.code == 200) {
      userResponse = res.data;
      emit(state.copyWith(status: BlocStatus.success, msg: null));
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg: res.message,
        ),
      );
    }
  }

  void onConnect({
    required String link,
    required String passwordSer,
    required String userSer,
    required String adminPassword,
    required String adminUser,
    required BuildContext context,
  }) async {
    DialogUtils.showLoadingDialog(context, 'Đang kết nối vui lòng đợi!');
    final id = getAccountId ?? 0;
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.onConnect(
      userSer,
      passwordSer,
      link,
      id,
      adminUser,
      passwordSer,
      userResponse?.organizationCA ?? '',
    );
    Navigator.of(context).pop();
    if (res.code == 200) {
      emit(state.copyWith(status: BlocStatus.submitSuccess, msg: null));
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.submitFailure,
          msg: res.message,
        ),
      );
    }
  }

  void getInfor() async {
    try {
      final id = getAccountId ?? 0;
      emit(state.copyWith(status: BlocStatus.loading));
      final res = await _repo.getInfor(id);
      if (res.code == 200) {
        final data = base64.decode(res.data?.vnptRes ?? '');
        final decodedString = utf8.decode(data);
        final document = XmlDocument.parse(decodedString);

        userResponse = ElectricInvoiceAccountModel(
          ownCA: document.findAllElements('OwnCA').first.text.trim(),
          serialNumber:
              document.findAllElements('SerialNumber').first.text.trim(),
          validFrom: document.findAllElements('ValidFrom').first.text.trim(),
          validTo: document.findAllElements('ValidTo').first.text.trim(),
          organizationCA:
              document.findAllElements('OrganizationCA').first.text.trim(),
        );

        userInfor = res.data;
        // emit(state.copyWith(status: BlocStatus.submitSuccess, msg: null));
        getListSerial();
      } else {
        emit(
            state.copyWith(status: BlocStatus.submitFailure, msg: res.message));
      }
    } catch (e) {
      print(e);
      emit(
        state.copyWith(status: BlocStatus.submitFailure, msg: e.toString()),
      );
    }
  }

  void onClear() {
    userResponse = null;
    emit(state.copyWith(status: BlocStatus.reload, msg: null));
  }

  void getListSerial() async {
    final id = getCompanyId ?? 0;
    // emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getListSerial(id);
    if (res.code == 200) {
      if (res.data?.isNotEmpty == true) {
        userSerials = res.data!
          ..sort((a, b) {
            if (b.defaultFlag == true) {
              return 1;
            }
            return -1;
          });
      }

      emit(state.copyWith(status: BlocStatus.success, msg: null));
    } else {
      emit(state.copyWith(status: BlocStatus.failure, msg: res.message));
    }
  }

  void createSerial() async {
    final id = getCompanyId ?? 0;
    emit(state.copyWith(status: BlocStatus.submit));
    final res = await _repo.createSerial(
      serial: serial,
      name: name,
      pattern: pattern,
      workspace: id,
      defaultFlag: defaultFlag,
    );
    if (res.code == 200) {
      emit(state.copyWith(status: BlocStatus.submitSuccess, msg: null));
    } else {
      emit(state.copyWith(status: BlocStatus.submitFailure, msg: res.message));
    }
  }

  void setName(String value) {
    name = value;
  }

  void setPattern(String value) {
    pattern = value;
  }

  void setSerial(String value) {
    serial = value;
  }

  void setDefault(bool value) {
    defaultFlag = value;
    emit(state.copyWith(status: BlocStatus.reload));
  }
}
