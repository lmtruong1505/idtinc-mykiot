import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/variant_entity.dart';
import 'service_selection_product_state.dart';

@injectable
class ServiceSelectionProductCubit extends Cubit<ServiceSelectionProductState> {
  ServiceSelectionProductCubit() : super(const ServiceSelectionProductState());

  void addVariant(VariantEntity? value) {
    final variants = List<VariantEntity>.from(state.variants);
    variants.add(value!);
    emit(state.copyWith(variants: variants));
  }

  void removeVariant(VariantEntity? value) {
    final variants = List<VariantEntity>.from(state.variants);
    variants.remove(value);
    emit(state.copyWith(variants: variants));
  }

}
