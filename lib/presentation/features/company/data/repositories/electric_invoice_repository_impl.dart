import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:pharmago/data/config/dio.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/company/data/models/electric_invoice_user_model.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features/company/domain/entities/invoice_attributes_entity.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/electric_invoice_repository.dart';
import 'dart:convert';

import 'package:xml/xml.dart';

import '../../../../../shared/constants/pref_key.dart';
import '../../../../../shared/constants/storage/shared_preference.dart';
import '../../helpers/company_helper.dart';
import '../models/invoice_attributes_model.dart';

@LazySingleton(as: ElectricInvoiceRepository)
class ElectricInvoiceRepositoryImpl extends ElectricInvoiceRepository {
  ElectricInvoiceRepositoryImpl(
    this._dioV2,
    this._dio,
  );

  final BaseDioV2 _dioV2;
  final BaseDio _dio;

  @override
  Future<BaseResponseModel<ElectricInvoiceAccountModel>> validInfor(
    String userSer,
    String passwordSer,
    String link,
    int id,
  ) async {
    try {
      final payload = {
        'user_service': userSer,
        'pass_service': passwordSer,
        'login_link': link,
      };
      final res = await _dioV2.post(Api.checkInfor, data: payload);

      if (res.data['success'] == true) {
        final data = base64.decode(res.data['data']['data']);
        final decodedString = utf8.decode(data);
        final document = XmlDocument.parse(decodedString);

        final userInfor = ElectricInvoiceAccountModel(
          ownCA: document.findAllElements('OwnCA').first.text.trim(),
          serialNumber:
              document.findAllElements('SerialNumber').first.text.trim(),
          validFrom: document.findAllElements('ValidFrom').first.text.trim(),
          validTo: document.findAllElements('ValidTo').first.text.trim(),
          organizationCA:
              document.findAllElements('OrganizationCA').first.text.trim(),
        );
        print('==========$document');
        return BaseResponseModel(code: 200, data: userInfor);
      } else {
        return BaseResponseModel(
            code: res.data['status'], message: res.data['message']);
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel> onConnect(
    String userSer,
    String passwordSer,
    String link,
    int id,
    String adminUser,
    String adminPassword,
    String name,
  ) async {
    try {
      final payload = {
        'custom_id': id,
        'system': 'PMG_dev',
        'user_admin': adminUser,
        'pass_admin': passwordSer,
        'user_service': userSer,
        'pass_service': passwordSer,
        'login_link': link,
        'type': 1,
        'name': name,
      };

      final res = await _dioV2.post(Api.createOriganization, data: payload);

      if (res.data['success'] == true) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
            code: res.data['status'], message: res.data['message']);
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<ElectricInvoiceUserModel>> getInfor(int id) async {
    try {
      final payload = {
        'id': id,
        'system': 'PMG_dev',
        'type': 1,
      };

      final res = await _dioV2.post(Api.getInfor, data: payload);

      if (res.data['status'] == 200) {
        final user = ElectricInvoiceUserModel.fromJson(res.data['data']);
        return BaseResponseModel(code: 200, data: user);
      } else {
        return BaseResponseModel(
          code: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<List<UserSerialModel>>> getListSerial(int id) async {
    try {
      final payload = {'workspace_id': id};
      final res = await _dio.get(Api.getSerials, data: payload);

      if (res.data['code'] == 200) {
        final serials = (res.data['details'] as List)
            .map((e) => UserSerialModel.fromJson(e))
            .toList();
        return BaseResponseModel(code: 200, data: serials);
      } else {
        return BaseResponseModel(
          code: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel> createSerial({
    required int workspace,
    required String? name,
    required String? serial,
    required String? pattern,
    required bool? defaultFlag,
  }) async {
    try {
      final payload = {
        'pattern': pattern,
        'serial': serial,
        'workspace': workspace,
        'name': name,
        'default_flag': defaultFlag,
      };
      payload.removeWhere((key, value) => value == null);
      final res = await _dio.post(Api.createSerial, data: payload);

      if (res.data['code'] == 200) {
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: res.data['status'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      print(e);
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel> createViettelAccount({
    required String username,
    required String password,
    required int workspaceId,
  }) async {
    try {
      final payload = {
        'username': username,
        'password': password,
        'workspace_id': workspaceId,
      };
      final resViettel = await Dio().post(Api.viettelLogin, data: payload);
      final token = resViettel.data['access_token'] as String?;
      if (token == null) {
        return BaseResponseModel(code: 400);
      }
      final res = await _dio.post(Api.createViettelAccount, data: payload);

      if (res.data['code'] == 200) {
        CompanyHelper.setViettelInvoiceAccount(
          username: username,
          password: password,
          workspaceId: workspaceId,
        );
        return BaseResponseModel(code: 200);
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<Map<String, dynamic>?> getViettelAccount({
    required int workspaceId,
  }) async {
    try {
      final data = CompanyHelper.viettelInvoiceAccount(workspaceId);
      return data;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<BaseResponseModel<InvoiceAttributesModel>> createInvoiceAttributes({
    required String name,
    required String pattern,
    required String serial,
    required int workspace,
    required bool defaultFlag,
  }) async {
    try {
      final payload = {
        'name': name,
        'pattern': pattern,
        'serial': serial,
        'workspace': workspace,
        'default_flag': defaultFlag,
      };
      final res = await _dio.post(Api.invoiceAttributes, data: payload);

      if (res.data['code'] == 200) {
        final dataModel = InvoiceAttributesModel.fromJson(res.data['details']);
        return BaseResponseModel(
          code: 200,
          data: dataModel,
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<List<InvoiceAttributesEntity>>>
      listInvoiceAttributes({
    required int workspace,
  }) async {
    try {
      final payload = {
        'workspace_id': workspace,
      };
      final res = await _dio.get(Api.invoiceAttributes, data: payload);

      if (res.data['code'] == 200) {
        final dataModel = (res.data['details'] as List)
            .map((e) => InvoiceAttributesModel.fromJson(e))
            .toList();
        return BaseResponseModel(
          code: 200,
          data: dataModel,
        );
      } else {
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
        );
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: 'Đã có lỗi xảy ra');
    }
  }

  @override
  Future<BaseResponseModel<File>> pdfRedInvoice({
    required int orderId,
    required RedInvoicePublisher publisher,
  }) async {
    try {
      final payload = {
        'order_id': orderId,
        'publisher': publisher.code,
      };
      final token = AppSharedPreference.instance.getValue(PrefKeys.token);
      // final res = await FileSaver.instance.saveFile(
      //   name: 'red_invoice_$orderId',
      //   mimeType: MimeType.pdf,
      //   link: LinkDetails(
      //     link: 'https://mykiot-pharmago.too.onl/api/v1/order/pdf-red-invoice',
      //     headers: {
      //       'authorization': 'Bearer $token',
      //     },
      //     method: 'POST',
      //     body: payload,
      //   ),
      // );
      // log('--- res: $res');
      final res = await Dio().post(
        'https://mykiot-pharmago.too.onl/api/v1/order/pdf-red-invoice',
        data: payload,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'authorization': 'Bearer $token',
          },
        ),
      );
      // final res = await _dio.post(Api.pdfRedInvoice, data: payload);
      // final bytes = base64Decode(res.data);
      savePdfToDownloads(res.data, 'red_invoice_$orderId');
      // final directory = await getTemporaryDirectory();
      // final file = File('${directory.path}/red_invoice_$orderId.pdf');
      // await file.writeAsBytes(res.data);
      return BaseResponseModel(
        code: 200,
        message: 'success',
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: 'Đã có lỗi xảy ra',
      );
    }
  }
}

Future<void> savePdfToDownloads(Uint8List bytes, String fileName) async {
  try {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Get downloads directory
      Directory? directory;
      
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }
      
      if (directory != null) {
        final file = File('${directory.path}/$fileName.pdf');
        await file.writeAsBytes(bytes);
        print('PDF saved to: ${file.path}');
      }
    }
  } catch (e) {
    print('Error saving PDF: $e');
  }
}
