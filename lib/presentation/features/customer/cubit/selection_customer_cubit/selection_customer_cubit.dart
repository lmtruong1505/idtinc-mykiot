import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/customer/cubit/selection_customer_cubit/selection_customer_state.dart';

import '../../domain/entities/customer_entity.dart';

@injectable
class SelectionCustomerCubit extends Cubit<SelectionCustomerState> {
  SelectionCustomerCubit() : super(const SelectionCustomerState());

  void addCustomer(CustomerEntity? value) {
    final customers = List<CustomerEntity>.from(state.customers);
    customers.add(value!);
    emit(state.copyWith(customers: customers));
  }

  void removeCustomer(CustomerEntity? value) {
    final customers = List<CustomerEntity>.from(state.customers);
    customers.remove(value);
    emit(state.copyWith(customers: customers));
  }

}
