import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_state.freezed.dart';

@freezed
class BannerState with _$BannerState {
  const factory BannerState({
    @Default([]) List<String> urls, 
  }) = _BannerState;
}
