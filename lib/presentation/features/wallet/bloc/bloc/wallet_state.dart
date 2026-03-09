import '../../data/models/deep_link_bank_model.dart';
import '../../data/models/wallet_deposit_response.dart';

abstract class WalletState {}

class WalletInitState extends WalletState {}

class WalletFindingState extends WalletState {}

class WalletFindingSuccessState extends WalletState {}

class WalletFindingFailedState extends WalletState {
  final String? messageErr;
  WalletFindingFailedState({this.messageErr});
}

class WalletConnectingSocketState extends WalletState {}

class WalletConnectingDepositSocketState extends WalletState {}

class WalletDepositUrlLoadingState extends WalletState {}

class WalletDepositUrlSuccessState extends WalletState {
  final WalletDepositRes data;
  final List<DeepLinkBankModel> listDeeplinks;
  WalletDepositUrlSuccessState({
    required this.data,
    required this.listDeeplinks,
  });
}

class WalletDepositUrlErrState extends WalletState {
  final String err;
  WalletDepositUrlErrState({required this.err});
}

class WalletDepositSuccessState extends WalletState {}
