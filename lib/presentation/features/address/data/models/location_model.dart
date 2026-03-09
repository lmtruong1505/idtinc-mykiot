import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class LocationModel extends  Equatable {
  int? id;
  String? title;
  String? code;
  String? title2;

  LocationModel({this.id, this.title, this.code, this.title2});

  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['code'] = this.code;
    return data;
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
