import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../../data/apis/end_point.dart';

@Singleton()
class CompanyChooseBloc extends Cubit<CubitState> {
  CompanyChooseBloc() : super(CubitState());

  CompanyEntity? _company;
  CompanyEntity? get company => _company;

  WebSocketChannel? _channel;

  set company(CompanyEntity? val) {
    _company = val;
    _socketHandle();
    emit(state.copyWith(status: BlocStatus.success));
  }

  void _socketHandle() async {
    if (_channel != null) {
      await _channel?.sink.close(status.goingAway);
      _channel = null;
    }
    final wsUrl = Uri.parse('${SocketUrl.invoiceStatus}/${_company?.id}');
    _channel = WebSocketChannel.connect(wsUrl);

    await _channel?.ready;

    _channel?.stream.listen((message) {
      _channel?.sink.add('received!');
      print('--- channel.stream.listen: $message');
      emit(state.copyWith(msg: message));
    });
  }
}
