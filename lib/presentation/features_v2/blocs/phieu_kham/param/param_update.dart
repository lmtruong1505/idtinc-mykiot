import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';

class ParamUpdatedPk {
  
  String? diagnostic;
  String? symptoms;
  bool? isDone;
  TypeFileCustomer? type;
  List<Map<String, String>>? files;
  ParamUpdatedPk({
    this.diagnostic,
    this.symptoms,
    this.isDone,
    this.files,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'diagnostic': diagnostic,
      'symptoms': symptoms,
      'type': type?.code,
      'isDone': isDone,
      'files': files,
    };
  }
}
