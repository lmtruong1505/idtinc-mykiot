// payment_model.dart

class WalletDepositRes {
  final String bin;
  final String accountNumber;
  final String accountName;
  final int amount;
  final String description;
  final int orderCode;
  final String currency;
  final String paymentLinkId;
  final String status;
  final String? expiredAt;
  final String checkoutUrl;
  final String qrData;

  WalletDepositRes({
    required this.bin,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.description,
    required this.orderCode,
    required this.currency,
    required this.paymentLinkId,
    required this.status,
    this.expiredAt,
    required this.checkoutUrl,
    required this.qrData,
  });

  factory WalletDepositRes.fromJson(Map<String, dynamic> json) {
    return WalletDepositRes(
      bin: json['bin'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
      amount: json['amount'],
      description: json['description'],
      orderCode: json['orderCode'],
      currency: json['currency'],
      paymentLinkId: json['paymentLinkId'],
      status: json['status'],
      expiredAt: json['expiredAt'],
      checkoutUrl: json['checkoutUrl'],
      qrData: json['qrCode'],
    );
  }
}