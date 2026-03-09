import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features_v2/repositories/phieu_kham/phieu_kham_repository.dart';

import '../../models/prescription/prescription_model.dart';
import '../state/init_state.dart';
import 'param/param_create_prescription.dart';

class CreatePrescriptionBloc extends Cubit<CubitState> {
  CreatePrescriptionBloc() : super(CubitState());
  final param = ParamCreatePrescription();
  final _repo = PhieuKhamRepository();
  final List<ItemsPrdData> items = [
    ItemsPrdData(),
  ];

  setDataItems(List<ItemsPrescription> values) {
    items.clear();
    for (final element in values) {
      items.add(
        ItemsPrdData(
          variantName: element.variant?.name,
          lieuDung: element.lieuDung,
          quantity: element.quantity,
          variantId: element.variantId,
          units: element.units,
          level: element.level,
          unit: element.unit,
        ),
      );
    }
    emit(state.copyWith(status: BlocStatus.success));
  }

  addPrd() {
    items.add(ItemsPrdData());
    emit(state.copyWith(status: BlocStatus.success));
  }

  editItem({
    required int index,
    ItemsPrdData? item,
  }) {
    items[index].lieuDung = item?.lieuDung;
    items[index].quantity = item?.quantity;
    items[index].variantId = item?.variantId;
    items[index].variantName = item?.variantName;
    emit(state.copyWith(status: BlocStatus.success));
  }

  removeItem(
    int index,
  ) {
    items.removeAt(index);
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<BaseResponseModel> create() async {
    param.items = items;
    final res = await _repo.createPrescription(req: param.toJson());
    return res;
  }

  Future<BaseResponseModel> update(String uuid) async {
    param.items = items;
    final res = await _repo.updatePrescription(uuid: uuid, req: param.toJson());
    return res;
  }
}
