
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/associate_model.dart';

part 'workspace_associate_state.freezed.dart';

@freezed
abstract class WorkspaceAssociateState with _$WorkspaceAssociateState {
  const factory WorkspaceAssociateState({
    @Default([]) List<AssociateModel> wsAssociates,
    @Default(false) bool isLoading,
  }) = _WorkspaceAssociateState;
}
