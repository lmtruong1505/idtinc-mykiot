import 'package:flutter/material.dart';

enum StateMessage {
  loading(Icons.access_time_outlined),
  error(Icons.error_outline),
  success(Icons.check);

  final IconData icon;
  const StateMessage(this.icon);
}

class MessageZaloModel {
  int? id;
  String? messageText;
  String? timestamp;
  DateTime? createAt;
  bool? read;
  bool? isMe;
  String? messageId;
  List<Attachments>? attachments;
  String? sendBy;
  String? oaName;
  String? oaImage;
  String? zaloName;
  String? zaloImg;
  StateMessage? state;

  MessageZaloModel({
    this.id,
    this.messageText,
    this.timestamp,
    this.read,
    this.messageId,
    this.attachments,
    this.sendBy,
    this.oaName,
    this.oaImage,
    this.zaloName,
    this.isMe,
    this.zaloImg,
    this.createAt,
    this.state,
  });

  MessageZaloModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageText = json['message_text'];
    timestamp = json['timestamp'];
    read = json['read'];
    messageId = json['message_id'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    isMe = json['send_by'] == 'OA';
    sendBy = json['send_by'];
    oaName = json['oa_name'];
    oaImage = json['oa_image'];
    zaloName = json['zalo_name'];
    zaloImg = json['zalo_img'];
    final int? timestampNumber = int.tryParse(timestamp ?? '');
    if (timestampNumber != null) {
      createAt = DateTime.fromMillisecondsSinceEpoch(timestampNumber);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message_text'] = messageText;
    data['timestamp'] = timestamp;
    data['read'] = read;
    data['message_id'] = messageId;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['send_by'] = sendBy;
    data['oa_name'] = oaName;
    data['oa_image'] = oaImage;
    data['zalo_name'] = zaloName;
    data['zalo_img'] = zaloImg;
    return data;
  }
}

class Attachments {
  String? url;
  String? thumbnail;
  String? type;
  bool? isFile;

  Attachments({
    this.url,
    this.thumbnail,
    this.type,
    this.isFile,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnail = json['thumbnail'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['type'] = type;
    return data;
  }
}
