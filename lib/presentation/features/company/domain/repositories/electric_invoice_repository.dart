import 'dart:io';

import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/company/data/models/electric_invoice_user_model.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';

import '../entities/invoice_attributes_entity.dart';
import '../enum/enum_data.dart';

abstract class ElectricInvoiceRepository {
  Future<BaseResponseModel<ElectricInvoiceAccountModel>> validInfor(
    String userSer,
    String passwordSer,
    String link,
    int id,
  );

  Future<BaseResponseModel> onConnect(
    String userSer,
    String passwordSer,
    String link,
    int id,
    String adminUser,
    String adminPassword,
    String name,
  );

  Future<BaseResponseModel<ElectricInvoiceUserModel>> getInfor(int id);

  Future<BaseResponseModel<List<UserSerialModel>>> getListSerial(int id);

  Future<BaseResponseModel> createSerial({
    required int workspace,
    required String? name,
    required String? serial,
    required String? pattern,
    required bool? defaultFlag,
  });

  Future<BaseResponseModel> createViettelAccount({
    required String username,
    required String password,
    required int workspaceId,
  });

  Future<Map<String, dynamic>?> getViettelAccount({
    required int workspaceId,
  });

  Future<BaseResponseModel<InvoiceAttributesEntity>> createInvoiceAttributes({
    required String name,
    required String pattern,
    required String serial,
    required int workspace,
    required bool defaultFlag,
  });

  Future<BaseResponseModel<List<InvoiceAttributesEntity>>> listInvoiceAttributes({
    required int workspace,
  });

  Future<BaseResponseModel<File>> pdfRedInvoice({
    required int orderId,
    required RedInvoicePublisher publisher,
  });
}
