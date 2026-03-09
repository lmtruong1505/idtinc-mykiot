import 'io/input.dart';
import 'io/output.dart';
import 'use_case.dart';

abstract class BaseSyncUseCase<Input extends BaseInput,
    Output extends BaseOutput> extends BaseUseCase<Input, Output> {
  BaseSyncUseCase();

  Output execute(Input input) {
    try {
      final output = buildUseCase(input);
      return output;
    } catch (e) {
      rethrow;
    }
  }
}
