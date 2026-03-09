import '../../data/models/deep_link_bank_model.dart';

abstract class WalletEvent {}

class WalletDetailEvent extends WalletEvent {}

class WalletConnectSocketEvent extends WalletEvent {}

class WalletCloseSocketEvent extends WalletEvent {}

class WalletConnectDepositSocketEvent extends WalletEvent {
  final String paymentLinkId;
  WalletConnectDepositSocketEvent({required this.paymentLinkId});
}

class WalletCloseDepositSocketEvent extends WalletEvent {}

class WalletDepositEvent extends WalletEvent {
  final int amount;
  WalletDepositEvent({required this.amount});
}

class WalletSocketMessageEvent extends WalletEvent {
  final dynamic messageData;
  WalletSocketMessageEvent({required this.messageData});
}

class WalletSocketDepositMessageEvent extends WalletEvent {
  final dynamic messageData;
  WalletSocketDepositMessageEvent({required this.messageData});
}

class SelectedDeeplinkBankEvent extends WalletEvent {
  final DeepLinkBankModel dl;
  SelectedDeeplinkBankEvent({required this.dl});
}