import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class LocalModel extends Equatable {
  int? id;
  String? name;
  String? title;
  Color? color;
  double? value;

  LocalModel({
    this.id,
    this.name,
    this.title,
    this.color,
    this.value,
  });

  factory LocalModel.fromJson(Map<String, dynamic> map) {
    return LocalModel(
      id: int.tryParse(map['id'].toString()),
      name: map['name'],
      title: map['title'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
      ];
}
