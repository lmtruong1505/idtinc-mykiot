import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/count_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/count_entity.dart';

@injectable
class CountMapper extends BaseDataMapper<CountModel, CountEntity> {
  @override
  CountEntity mapToEntity(CountModel? data) {
    return CountEntity(
        name: data?.name ?? '',
        code: data?.code ?? '',
        value: data?.value ?? 0,
    );
  }
}
