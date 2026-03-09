class DeepLinkBankModel {
  final String appId;
  final String appLogo;
  final String appName;
  final String bankName;
  final int monthlyInstall;
  final String deeplink;
  final int autofill;

  DeepLinkBankModel({
    required this.appId,
    required this.appLogo,
    required this.appName,
    required this.bankName,
    required this.monthlyInstall,
    required this.deeplink,
    required this.autofill,
  });

  // Create a DeepLinkBankModel from JSON
  factory DeepLinkBankModel.fromJson(Map<String, dynamic> json) {
    return DeepLinkBankModel(
      appId: json['appId'],
      appLogo: json['appLogo'],
      appName: json['appName'],
      bankName: json['bankName'],
      monthlyInstall: json['monthlyInstall'],
      deeplink: json['deeplink'],
      autofill: json['autofill'],
    );
  }

  // Convert DeepLinkBankModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'appLogo': appLogo,
      'appName': appName,
      'bankName': bankName,
      'monthlyInstall': monthlyInstall,
      'deeplink': deeplink,
      'autofill': autofill,
    };
  }

  // Create a copy of DeepLinkBankModel with some fields replaced
  DeepLinkBankModel copyWith({
    String? appId,
    String? appLogo,
    String? appName,
    String? bankName,
    int? monthlyInstall,
    String? deeplink,
    int? autofill,
  }) {
    return DeepLinkBankModel(
      appId: appId ?? this.appId,
      appLogo: appLogo ?? this.appLogo,
      appName: appName ?? this.appName,
      bankName: bankName ?? this.bankName,
      monthlyInstall: monthlyInstall ?? this.monthlyInstall,
      deeplink: deeplink ?? this.deeplink,
      autofill: autofill ?? this.autofill,
    );
  }
}