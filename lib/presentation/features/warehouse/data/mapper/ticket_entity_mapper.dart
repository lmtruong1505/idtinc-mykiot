

import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/features/product/data/mapper/basic_entity_mapper.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/ticket_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/ticket_entity.dart';

@injectable
class TicketEntityMapper extends BaseDataMapper<TicketModel, TicketEntity> {
  TicketEntityMapper(this._basicEntityMapper);
  final BasicEntityMapper _basicEntityMapper;
  
  @override
  TicketEntity mapToEntity(TicketModel? data) {
    return TicketEntity(
      id: data?.id,
      code: data?.code,
      type: _basicEntityMapper.mapToEntity(data?.type),
      status: _basicEntityMapper.mapToEntity(data?.status),
      note: data?.note,
      qr: data?.qr,
      totalPrice: data?.totalPrice,
      warehouseName: data?.warehouseName,
      userCreated: data?.userCreated,
      createdAt: data?.createdAt,
      totalItems: data?.totalItems,
    );
  }

}