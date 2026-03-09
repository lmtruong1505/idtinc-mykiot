class FileModel {
  int? id;
  String? uuid;
  String? type;
  String? title;
  String? url;
  int? customer;
  int? userCreated;
  String? createdAt;

  FileModel(
      {this.id,
      this.uuid,
      this.type,
      this.title,
      this.url,
      this.customer,
      this.userCreated,
      this.createdAt});

  FileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    type = json['type'];
    title = json['title'];
    url = json['url'];
    customer = json['customer'];
    userCreated = json['user_created'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['type'] = this.type;
    data['title'] = this.title;
    data['url'] = this.url;
    data['customer'] = this.customer;
    data['user_created'] = this.userCreated;
    data['created_at'] = this.createdAt;
    return data;
  }
}
