class UserZaloModel {
  String? phone;
  String? userId;
  String? zaloImg;
  LastMessage? lastMessage;
  String? lastAttachment;

  UserZaloModel(
      {this.phone,
      this.userId,
      this.zaloImg,
      this.lastMessage,
      this.lastAttachment});

  UserZaloModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    userId = json['user_id'];
    zaloImg = json['zalo_img'];
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
    lastAttachment = json['last_attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['user_id'] = this.userId;
    data['zalo_img'] = this.zaloImg;
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    data['last_attachment'] = this.lastAttachment;
    return data;
  }
}

class LastMessage {
  int? sendBy;
  String? timestamp;
  bool? read;
  String? message;

  LastMessage({this.sendBy, this.timestamp, this.read, this.message});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sendBy = json['send_by'];
    timestamp = json['timestamp'];
    read = json['read'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['send_by'] = this.sendBy;
    data['timestamp'] = this.timestamp;
    data['read'] = this.read;
    data['message'] = this.message;
    return data;
  }
}
