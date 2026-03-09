import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_hub_state.freezed.dart';

@freezed
class OrderHubState with _$OrderHubState {
  const factory OrderHubState({
    @Default(false) bool isCommit,
    @Default(false) bool isReceive,
    int? notiId,
    String? messageErr,
    @Default(false) bool isLoadingAction,
  }) = _OrderHubState;
}
