import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/apis/end_point.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../shared/constants/pref_key.dart';
import '../state/init_state.dart';

@singleton
class ChatSocketBloc extends Cubit<CubitState> {
  ChatSocketBloc() : super(CubitState()) {
    final wsUrl = Uri.parse('${Api.urlSocket}?oa_id=${PrefKeys.oaId}');
    channel = WebSocketChannel.connect(wsUrl);
  }
  late WebSocketChannel? channel;

  init() async {
    try {
      if (channel == null) {
        final wsUrl = Uri.parse('${Api.urlSocket}?oa_id=${PrefKeys.oaId}');
        channel = WebSocketChannel.connect(wsUrl);
      }
      await channel?.ready;
      channel?.stream.listen((message) {
        emit(
          state.copyWith(
            data: jsonDecode(message),
            status: BlocStatus.success,
          ),
        );
      });
    } catch (e) {}
  }
}
