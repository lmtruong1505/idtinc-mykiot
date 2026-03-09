class ReminderEventModel {
  int? id;
  int? quantity;
  String? unit;
  String? message;
  String? status;
  String? reminderTime;
  bool? isSend;
  bool? isError;

  ReminderEventModel({
    this.id,
    this.quantity,
    this.unit,
    this.message,
    this.status,
    this.reminderTime,
  });

  ReminderEventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    unit = json['unit'];
    message = json['message'];
    status = json['status'];
    isSend = json['status'] == 'SENT';
    isError = json['status'] == 'ERROR';
    reminderTime = json['reminder_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['message'] = message;
    data['status'] = status;
    data['reminder_time'] = reminderTime;
    return data;
  }
}
