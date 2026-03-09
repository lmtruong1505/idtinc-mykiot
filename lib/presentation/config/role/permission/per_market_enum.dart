part of 'index.dart';

enum PerMarketEnum {
  LIST('Xem danh sách sản phẩm', 'MARKET-LIST'),
  ADD_CART('Thêm vào giỏ hàng sản phẩm', 'MARKET-ADD-CART');

  final String title;
  final String code;
  const PerMarketEnum(this.title, this.code);
}
