import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/features/wallet/data/models/deep_link_bank_model.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../../../env/env_config.dart';
import '../../data/models/wallet_model.dart';
import '../../data/models/wallet_transaction_model.dart';
import '../../data/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

@singleton
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _walletRepository;

  WalletBloc(this._walletRepository) : super(WalletInitState()) {
    on<WalletEvent>((event, emit) async {
      switch (event.runtimeType) {
        case WalletConnectSocketEvent:
          await _connectWalletSocket(event as WalletConnectSocketEvent, emit);
        case WalletCloseSocketEvent:
          await _closeWalletSocket(event as WalletCloseSocketEvent, emit);
        case WalletConnectDepositSocketEvent:
          await _connectWalletDepositSocket(
              event as WalletConnectDepositSocketEvent, emit);
        case WalletCloseDepositSocketEvent:
          await _closeWalletDepositSocket(
              event as WalletCloseDepositSocketEvent, emit);
        case WalletSocketMessageEvent:
          await _newMessageSocket(event as WalletSocketMessageEvent, emit);
        case WalletSocketDepositMessageEvent:
          await _newMessageDepositSocket(
              event as WalletSocketDepositMessageEvent, emit);
        case WalletDetailEvent:
          await _detailWallet(event as WalletDetailEvent, emit);
        case WalletDepositEvent:
          await _getUrlDepositWallet(event as WalletDepositEvent, emit);
        case SelectedDeeplinkBankEvent:
          await _selectedDeeplinkBankHandle(
              event as SelectedDeeplinkBankEvent, emit);
      }
    });
  }

  WalletModel? _wallet;
  WalletModel? get wallet => _wallet;

  WebSocketChannel? _channel;
  WebSocketChannel? _channelDeposit;
  int count = 5;
  int depositCount = 5;
  final callback = DelayCallBack(delay: 1.seconds);
  // num balance = 0;

  Future<void> _connectWalletSocket(
    WalletConnectSocketEvent event,
    Emitter<WalletState> emit,
  ) async {
    // count = 5;
    print('---------------connectWalletSocket');
    String domain = 'wss://127.0.0.1:8000';
    if (EnvironmentConfig.BASE_URL_HTTP.contains('mykiot-pharmago.too.onl')) {
      domain = 'wss://mykiot-pharmago.too.onl';
      // domain = 'wss://128.199.209.130:8000';
    }
    final wsUrl = Uri.parse('$domain/ws/wallet/${_wallet?.id}');
    print('-----WalletConnectSocketEvent-----$wsUrl');
    try {
      _channel = WebSocketChannel.connect(wsUrl);

      await _channel?.ready;
      _channel!.sink.add(jsonEncode({'type': 'ping'}));

      _channel?.stream.listen(
        (message) {
          print('-----WalletConnectSocketEvent-----$message');
          print('---------------$message');
          add(WalletSocketMessageEvent(messageData: message));
        },
        onDone: () {
          print('----------------- DONE');
        },
        onError: (e) {},
      );
    } catch (e) {
      print('-----WalletConnectSocketEventError-----$e');
      count--;
      if (count > 0) {
        callback.debounce(() => add(WalletConnectSocketEvent()));
        print('-----ReconnectWalletConnectSocketEvent-----error');
      }
      print('----------------- ERR: $e');
    }
  }

  Future<void> _closeWalletSocket(
    WalletCloseSocketEvent event,
    Emitter<WalletState> emit,
  ) async {
    if (_channel != null) {
      // _channel?.sink.close(status.goingAway);
    }
  }

  Future<void> _connectWalletDepositSocket(
    WalletConnectDepositSocketEvent event,
    Emitter<WalletState> emit,
  ) async {
    try {
      String domain = 'wss://127.0.0.1:8000';
      if (EnvironmentConfig.BASE_URL_HTTP.contains('mykiot-pharmago.too.onl')) {
        domain = 'wss://mykiot-pharmago.too.onl';
        // domain = 'wss://128.199.209.130:8000';
      }
      final wsUrl =
          Uri.parse('$domain/ws/wallet/deposit/${event.paymentLinkId}');
      print('------WalletConnectDepositSocketEvent---$wsUrl');
      _channelDeposit = WebSocketChannel.connect(wsUrl);

      await _channelDeposit?.ready;

      _channelDeposit?.stream.listen((message) {
        print('--------WalletSocketDepositMessageEvent Success');
        add(WalletSocketDepositMessageEvent(messageData: message));
      }, onError: (e) {
        print('--------DepositSocketEvent--onError--------- ERR: $e');
      });
    } catch (e) {
      // depositCount--;
      // if (depositCount > 0) {
      //   print('-----ReconnectConnectDeposit-----Catch');
      //   add(WalletDepositEvent(amount: 0));
      // }
      print('------DepositSocketEvent---Catch---$e---');
    }
  }

  Future<void> _closeWalletDepositSocket(
    WalletCloseDepositSocketEvent event,
    Emitter<WalletState> emit,
  ) async {
    if (_channelDeposit != null) {
      _channelDeposit?.sink.close(status.goingAway);
    }
  }

  Future<void> _newMessageSocket(
    WalletSocketMessageEvent event,
    Emitter<WalletState> emit,
  ) async {
    final data = jsonDecode(event.messageData);
    final wallet = WalletModel.fromJson(data);
    _wallet = wallet;
    emit(WalletFindingSuccessState());
  }

  Future<void> _newMessageDepositSocket(
    WalletSocketDepositMessageEvent event,
    Emitter<WalletState> emit,
  ) async {
    final data = jsonDecode(event.messageData);
    print(data);
    if (data['code'] == '00') {
      emit(WalletDepositSuccessState());
      add(WalletDetailEvent());
      add(WalletCloseDepositSocketEvent());
    }
  }

  Future<void> _detailWallet(
    WalletDetailEvent event,
    Emitter<WalletState> emit,
  ) async {
    final res = await _walletRepository.detailWallet();
    if (res.code != 200) {
      emit(WalletFindingFailedState(messageErr: res.message));
      return;
    }
    _wallet = res.data;
    emit(WalletFindingSuccessState());
    if (_channel == null) {
      add(WalletConnectSocketEvent());
    }
  }

  Future<void> _getUrlDepositWallet(
    WalletDepositEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletDepositUrlLoadingState());
    final res = await _walletRepository.urlDepositWallet(amount: event.amount);
    if (res.code == 200) {
      emit(
        WalletDepositUrlSuccessState(
          data: res.data!,
          listDeeplinks: res.extra as List<DeepLinkBankModel>,
        ),
      );
      add(
        WalletConnectDepositSocketEvent(paymentLinkId: res.data!.paymentLinkId),
      );
    } else {
      emit(
        WalletDepositUrlErrState(
          err: res.message ?? 'Lỗi tạo link thanh toán',
        ),
      );
    }
  }

  Future<void> _selectedDeeplinkBankHandle(
    SelectedDeeplinkBankEvent event,
    Emitter<WalletState> emit,
  ) async {
    final Uri uri = Uri.parse(event.dl.deeplink);
    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch ${event.dl.deeplink}');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Future<List<TransactionModel>> listTransaction(int page) async {
    final res = await _walletRepository.walletTransaction(
      page: page + 1,
      limit: 20,
    );
    return res.data ?? [];
  }

  Future<List<DebebtTransactionModel>> listDebt(int page) async {
    final res = await _walletRepository.listDebt(
      page: page + 1,
      limit: 20,
    );
    return res.data ?? [];
  }
}
