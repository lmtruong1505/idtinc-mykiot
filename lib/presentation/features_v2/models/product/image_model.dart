class ImageModel {
  String? url;
  bool? isMain;
  String? fileName;

  ImageModel({this.url, this.isMain, this.fileName});

  ImageModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    isMain = json['is_main'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['is_main'] = isMain;
    data['file_name'] = fileName;
    return data;
  }

}