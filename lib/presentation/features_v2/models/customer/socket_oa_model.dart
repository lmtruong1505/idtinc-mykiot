import 'message_zalo_model.dart';

class SocketOAModel {
  String? message;
  String? userId;
  String? oaId;
  String? sendBy;
  List<Attachments>? attachments;
  String? trackingId;
  String? messageId;
  String? timestamp;

  SocketOAModel({
    this.message,
    this.userId,
    this.oaId,
    this.sendBy,
    this.attachments,
    this.trackingId,
    this.messageId,
    this.timestamp,
  });

  SocketOAModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['user_id'];
    oaId = json['oa_id'];
    sendBy = json['send_by'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    trackingId = json['tracking_id'];
    messageId = json['message_id'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['user_id'] = userId;
    data['oa_id'] = oaId;
    data['send_by'] = sendBy;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['tracking_id'] = trackingId;
    data['message_id'] = messageId;
    data['timestamp'] = timestamp;
    return data;
  }
}
