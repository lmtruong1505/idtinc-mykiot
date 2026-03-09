import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/data/models/media_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/product/image_model.dart';
import 'package:pharmago/presentation/features_v2/repositories/wholesale_drug/wholesale_drug_repo.dart';

@injectable
class WholesaleDrugBannerBloc extends Cubit<CubitState> {
  WholesaleDrugBannerBloc(this.repo) : super(CubitState());
  final WholesaleDrugRepo repo;

  List<MediaDatum>? list;

  void getBanners() async {
    final res = await repo.getBanners();
    list = (res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
