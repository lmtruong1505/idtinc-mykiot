import '../../../authentication/data/models/account_model.dart';

class WalletModel {
  final int? id;
  final String? walletUid;
  final int? balance;
  final AccountModel? owner;

  WalletModel({
    this.id,
    this.walletUid,
    this.balance,
    this.owner,
  });

  WalletModel copyWith({
    int? id,
    String? walletUid,
    int? balance,
    AccountModel? owner,
  }) =>
      WalletModel(
        id: id ?? this.id,
        walletUid: walletUid ?? this.walletUid,
        balance: balance ?? this.balance,
        owner: owner ?? this.owner,
      );

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      balance: json['balance'],
      owner: AccountModel.fromJson(json['owner']),
      walletUid: json['wallet_uid'],
    );
  }
}
