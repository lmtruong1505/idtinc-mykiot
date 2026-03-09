import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';

String formatAddress(AddressEntity? address) {
  if (address == null) return '';
  final data = address.detail ?? '';
  return data;
}