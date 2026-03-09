class TransactionModel {
  final String uid;
  final int amount;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String type;

  TransactionModel({
    required this.uid,
    required this.amount,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      uid: json['uid'],
      amount: json['amount'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'amount': amount,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'type': type,
    };
  }

  // Helper method to create a copy with some properties changed
  TransactionModel copyWith({
    String? uid,
    int? amount,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
  }) {
    return TransactionModel(
      uid: uid ?? this.uid,
      amount: amount ?? this.amount,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
    );
  }
}

class DebebtTransactionModel {
  int? id;
  num? amount;
  Map<String, dynamic>? metaData;
  String? createdAt;
  String? type;

  DebebtTransactionModel({
    this.id,
    this.amount,
    this.metaData,
    this.createdAt,
    this.type,
  });

  DebebtTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    metaData = json['meta_data'];
    createdAt = json['created_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;

    data['created_at'] = createdAt;
    data['type'] = type;
    return data;
  }
}
