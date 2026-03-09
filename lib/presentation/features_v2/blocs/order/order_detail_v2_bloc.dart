import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features/company/domain/repositories/electric_invoice_repository.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/order/order_v2_repo.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../data/models/base/response.dart';
import '../../../features/company/domain/enum/enum_data.dart';
import '../../../features/company/domain/usecase/pdf_red_invoice_use_case.dart';
import '../../repositories/order/order_v2_repository.dart';
import '../state/init_state.dart';

class OrderDetailV2Bloc extends Cubit<CubitState> {
  OrderDetailV2Bloc() : super(CubitState());
  final _repo = OrderRepositoryV2Impl();
  final _electricInvoiceRepo = getIt<ElectricInvoiceRepository>();
  final orderListRepo = OrderV2Repo();
  OrderDetailV2Model? order = OrderDetailV2Model();
  List<UserSerialModel>? userSerials;
  UserSerialModel? serialSelected;
  final _fdfRedInvoiceUseCase = getIt.get<PdfRedInvoiceUseCase>();

  TypeOrderEnum? type;
  String? medicalBill;

  Future<void> getDetail(int id, {bool isLoading = true}) async {
    if (isLoading) {
      emit(state.copyWith(status: BlocStatus.loading));
    }
    final res = await _repo.getDetail(id: id);
    if (res.data != null) {
      order = res.data!;
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<void> sendZaloOa() async {
    emit(state.copyWith(status: BlocStatus.reload));
    final res = await _repo.sendZalo(id: order?.id ?? 0);
    if (res.code == 200) {
      order = order?.copyWith(sendZalooa: true);
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> createPayment(num value, PaymentMethod type) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.paidOrder(
      id: order?.id ?? 0,
      payload: {
        'amount': value,
        'method': type.code,
      },
    );
    if (res.code == 200) {
      getDetail(order!.id!);
    }
    emit(state.copyWith(status: BlocStatus.success));
    return res;
  }

  Future<BaseResponseModel> delete(int id) async {
    return _repo.delete(id: id);
  }

  Future<BaseResponseModel> updateDeliver() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final payload = {
      'order': {
        'is_delivered': true,
      },
    };
    final res = await _repo.update(id: order!.id!, payload: payload);
    if (res.code == 200) {
      getDetail(order!.id!);
    }
    emit(state.copyWith(status: BlocStatus.success));
    return res;
  }

  Future<BaseResponseModel> updatePrescription({
    required int orderId,
    required String prescriptionCode,
    List<PrescriptionImageV2Model> prescriptionImages = const [],
    List<File> prescriptionImagesAdd = const [],
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final payloadImages = prescriptionImages
        .map(
          (e) => {
            'url': e.url,
            'is_main': e.isMain,
            'file_name': e.fileName,
          }..removeWhere((key, value) => value == null),
        )
        .toList();

    final res = await _repo.updatePrescription(
      id: orderId,
      prescriptionCode: prescriptionCode,
      prescriptionImages: payloadImages,
      prescriptionImagesAdd: prescriptionImagesAdd,
    );
    if (res.code == 200) {
      await getDetail(orderId, isLoading: false);
    }
    emit(state.copyWith(status: BlocStatus.success));
    return res;
  }

  num get hadPaid {
    return (order?.payments ?? []).fold<num>(
      0,
      (total, e) {
        total += e.amount.validator;
        return total;
      },
    );
  }

  num get totalDiscount {
    final discountProds = (order?.items ?? []).fold<num>(
      0,
      (total, e) {
        total += e.discountPrice.validator * e.quantity;
        return total;
      },
    );
    final discountServices = (order?.services ?? []).fold<num>(
      0,
      (total, e) {
        total += e.discountPrice.validator * (e.quantity ?? 0);
        return total;
      },
    );
    return discountProds + discountServices;
  }

  num vatProd(OrderItemV2 item) {
    return priceItem(item) * (item.productData?.vat ?? 0) / 100;
  }

  num priceItem(OrderItemV2 item) {
    return (item.price.validator - item.discountPrice.validator) *
        item.quantity.validator;
  }

  num get totalPriceItem {
    final totalServices = (order?.services ?? []).fold<num>(
      0,
      (total, e) {
        return total += (e.quantity ?? 0) * (e.price ?? 0);
      },
    );
    final totalProds = (order?.items ?? []).fold<num>(
      0,
      (total, e) {
        return total += priceItem(e);
      },
    );
    return totalProds + totalServices;
  }

  void createRedInvoice() async {
    emit(state.copyWith(status: BlocStatus.submit));
    final res = await orderListRepo.createExportInvoice(
      serialSelected?.serial ?? '',
      serialSelected?.id ?? 0,
      [order?.id ?? 0],
    );
    if (res.code == 200) {
      emit(state.copyWith(status: BlocStatus.submitSuccess));
      // getDetail(order!.id!);
    } else {
      emit(state.copyWith(status: BlocStatus.submitFailure));
    }
  }

  // void getListSerial() async {
  //   final id = getCompanyId ?? 0;
  //   final res = await _electricInvoiceRepo.getListSerial(id);
  //   if (res.code == 200) {
  //     if (res.data?.isNotEmpty == true) {
  //       userSerials = res.data!
  //         ..sort((a, b) {
  //           if (b.defaultFlag == true) {
  //             return 1;
  //           }
  //           return -1;
  //         });
  //       serialSelected = userSerials?.firstOrNull;
  //     }

  //     emit(state.copyWith(status: BlocStatus.success, msg: null));
  //   } else {
  //     emit(
  //       state.copyWith(status: BlocStatus.failure, msg: res.message),
  //     );
  //   }
  // }

  void selectInvoice(UserSerialModel? value) {
    serialSelected = value;
  }

  Future<int?> pdfRedInvoiceHandle() async {
    if (order?.id == null) return null;
    final input = PdfRedInvoiceUseCaseInput(
      orderId: order!.id!,
      publisher: RedInvoicePublisher.viettel,
    );
    final res = await _fdfRedInvoiceUseCase.execute(input);
    return res.response.code;
  }
}

enum PaymentMethod {
  cash('Tiền mặt', 'cash'),
  banking('Chuyển khoản', 'banking');

  final String title;
  final String code;

  const PaymentMethod(this.title, this.code);
}
