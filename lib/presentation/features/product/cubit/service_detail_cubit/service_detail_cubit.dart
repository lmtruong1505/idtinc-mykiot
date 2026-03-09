import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/product/cubit/service_detail_cubit/service_detail_state.dart';

import '../../../../../data/models/base/response.dart';
import '../../domain/usecase/service_delete_use_case.dart';
import '../../domain/usecase/service_detail_use_case.dart';

@injectable
class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit(
    this._serviceDetailUseCase,
    this._serviceDeleteUseCase,
  ) : super(const ServiceDetailState());

  final ServiceDetailUseCase _serviceDetailUseCase;
  final ServiceDeleteUseCase _serviceDeleteUseCase;

  Future<void> getDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final input = ServiceDetailInput(id: id);
    final res = await _serviceDetailUseCase.execute(input);
    emit(state.copyWith(
      service: res.response.data,
      variants: res.response.data?.variants ?? [],
      isLoading: false,
    ),);
  }

  void searchVariant(String value) {
    if(value.isEmpty) {
      emit(state.copyWith(variants: state.service?.variants ?? []));
      return;
    }

    final list = state.variants.where((e) {
      final code = e.code?.toLowerCase();
      final name = e.name?.toLowerCase();
      final search = value.toLowerCase();
      return (code?.contains(search) ?? false) || (name?.contains(search) ?? false);
    }).toList();

    emit(state.copyWith(variants: list));
  }

  Future<BaseResponseModel> deleteService(int id) async {
    final input = ServiceDeleteInput(id: id);
    final res = await _serviceDeleteUseCase.execute(input);
    return res.response;
  }


}
