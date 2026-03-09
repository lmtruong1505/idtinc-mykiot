import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/employee/employee/data/mapper/employee_entity_mapper.dart';
import 'package:pharmago/presentation/features/product/data/models/service_model.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';

@injectable
class ServiceEntityMapper extends BaseDataMapper<ServiceModel, ServiceEntity>{
  ServiceEntityMapper(this._employeeMapper);
  final EmployeeMapper _employeeMapper;

  @override
  ServiceEntity mapToEntity(ServiceModel? data) {
    return ServiceEntity(
     id : data?.id,
     //image : data?.image,
     code : data?.code,
     title : data?.title,
     entity : data?.entity,
     staff : _employeeMapper.mapToEntity(data?.staff),
     frequency : data?.frequency,
     unit : data?.unit,
     price : data?.price,
     description : data?.description,
     company : data?.company,
    //  variants : data?.variants?.map((e) => _variantEntityMapper.mapToEntity(e)).toList(),
     userCreated : null,
     userUpdated : null,
     createdAt : null,
     updatedAt : null,
     active: data?.active,
     reminderTime: data?.reminderTime,
     congTyDk: data?.congTyDk,
      soQuyetDinh: data?.soQuyetDinh,
      soDangKy: data?.soDangKy,
      brand: data?.brand,
      type: data?.type,
      actionTime: data?.actionTime,
      chiDinh: data?.chiDinh,
      chongChiDinh: data?.chongChiDinh,
      congDung: data?.congDung,
      tacDungPhu: data?.tacDungPhu,
      luuY: data?.luuY,
      hinhThuc: data?.hinhThuc,
      message: data?.message,
     images: data?.images
   );
  }
}