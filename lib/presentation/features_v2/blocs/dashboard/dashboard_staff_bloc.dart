import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/date_range.model.dart';
import '../../models/dashboard/employee.dart';
import '../../models/product/product_v2_model.dart';
import '../../repositories/dashboard/dashboard_repository.dart';
import '../enum/enum_bloc.dart';
import '../state/init_state.dart';

class DashboardStaffBloc extends Cubit<CubitState> {
  DashboardStaffBloc() : super(CubitState()) {
    weekDay = now.weekday;
    monday = now.subtract(Duration(days: now.weekday - 1));
  }

  final _repo = DashboardRepository();
  final now = DateTime.now();
  DateTime monday = DateTime.now();
  int weekDay = 0;
  List<DashboardEmployeeModel> employeeData = [];

  ProductV2Model _product = ProductV2Model();
  ProductV2Model get product => _product;
  set product(ProductV2Model newProduct) {
    _product = newProduct;
    getDataEmployeeDashboard();
  }

  SortEmployeeDashboard _employeeSort = SortEmployeeDashboard.totalOrder;
  SortEmployeeDashboard get employeeSort => _employeeSort;
  set employeeSort(SortEmployeeDashboard newSort) {
    _employeeSort = newSort;
    getDataEmployeeDashboard();
  }

  void setWeekDay(int index) {
    weekDay = index;
    emit(state.copyWith(status: BlocStatus.success));
  }

  void reload() {
    emit(state.copyWith(status: BlocStatus.reload));
  }

  Future<void> getDataEmployeeDashboard({
    DateRangeModel? dates,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.dataEmployee(
      sort: _employeeSort,
      dates: dates,
      productId: _employeeSort == SortEmployeeDashboard.totalSalesByProduct
          ? product.id
          : null,
    );
    employeeData = res.data ?? [];
    emit(state.copyWith(status: BlocStatus.success));
  }
}
