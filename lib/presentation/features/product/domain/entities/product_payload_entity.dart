import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_payload_entity.freezed.dart';
part 'product_payload_entity.g.dart';

@freezed
class ProductPayloadEntity with _$ProductPayloadEntity {
  const ProductPayloadEntity._();

  const factory ProductPayloadEntity({
    final String? name,
    final String? code,
    final int? company,
    final String? taDuoc,
    final String? nongDo,
    final String? lieuDung,
    final String? chiDinh,
    final String? chongChiDinh,
    final String? congDung,
    final String? hinhThuc,
    final String? tacDungPhu,
    final String? thanTrong,
    final String? tuongTac,
    final String? baoQuan,
    final String? dongGoi,
    final String? noiSx,
    final int? congTySx,
    final int? congTyDk,
    final String? phanLoai,
    final String? tieuChuanSx,
    final String? dangBaoChe,
    final int? category,
    final int? type,
    final String? moTa,
    final int? brand,
    @Default(false) bool active,
    @Default([]) List<String> image,
  }) = _ProductPayloadEntity;

  factory ProductPayloadEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductPayloadEntityFromJson(json);
}
