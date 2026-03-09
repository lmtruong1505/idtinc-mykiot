import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/conversation/data/models/conversation_model.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../features/conversation/domain/repositories/conversation_repository.dart';
import '../state/init_state.dart';

class ListChatBloc extends Cubit<CubitState> {
  ListChatBloc() : super(CubitState());

  final _repo = getIt<ChatRepository>();
  final List<ConversationModel> users = [];

  final callBack = DelayCallBack(delay: 500.milliseconds);
  onSearch(String value) {
    callBack.debounce(
      () {
        getChats();
      },
    );
  }

  int _page = 1;

  getChats({bool isMore = false}) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
      users.clear();
    }

    emit(state.copyWith(status: BlocStatus.loading));
    final res = await _repo.getChats(page: _page, limit: 20);
    users.addAll(res.data ?? []);
    emit(state.copyWith(status: BlocStatus.success));
  }
}
