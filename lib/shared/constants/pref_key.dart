class PrefKeys {
  // ignore: constant_identifier_names
  static const String GMSToken = 'AIzaSyBxNc7ESSs1Re-UiJO2AmAPlI2eyDdHHHg';
  static const String token = 'TOKEN';
  static const String biometrics = 'BIOMETRICS';
  static const String store = 'STORE';
  static const String username = 'USERNAME';
  static const String password = 'PASSWORD';
  static const String rememberPassword = 'REMEMBER_PASSWORD';
  static const String tokenRefresh = 'TOKEN_REFRESH';
  static const String cart = 'CART';
  static const String firebaseToken = 'FIREBASE_TOKEN';
  static const String countryCode = 'COUNTRY_CODE';
  static const String languageCode = 'LANGUAGE_CODE';
  static const String user = 'USER';
  static const String userFullName = 'USERFULLNAME';
  static const String avatar = 'avatar';
  static const String companyType = 'company_type';
  static const String isWorkspace = 'is_workspace';
  static const String parentId = 'parent_id_ws';
  static const String parentName = 'parent_name';
  static const String parentType = 'parent_type';

  static const String isWelcome = 'IS_WELCOME';
  static const String accountId = 'accountId';

  static const String codeAdmin = 'ADMIN';
  static const String codeEmployee = 'EMPLOYEE';

  //branch create back data
  static const String branchCreateType = 'branchCreateType';
  static const String branchIsCreate = 'branchIsCreate';

  static const String userId = 'userId';
  static const String oaId = '3256529726109435943';

  static const int maxPrice = 999999999999999;

  /// ADMIN: account admin
  ///
  /// CHTH: account trinh duoc vien
  static const String userCode = 'USER_CODE';
  static const String key = 'AD';
  static const String priceList = 'PRICE_LIST';
  static const String dataCHTH = 'DATACHTH';
  static const String company = 'COMPANY';
  static const String companyName = 'COMPANY_NAME';
  static const String companyCode = 'COMPANY_CODE';

  static const String card = 'CARD';
  static const String warehouseId = 'WAREHOUSEID';
  static const String mode = 'MODE';

  /// This key use to get data from Local
  ///
  /// Type data saved is jsonEncode(List[OrderDetailEntity].toJson())
  ///
  /// Before use please to [jsonDecode] data
  static const String orderDrafExport = 'ORDER_DRAF_EXPORT';
  static const String orderDrafImport = 'ORDER_DRAF_IMPORT';
  static const int idOrderDrafStatus = 888;

  static const String imgProductDefault =
      'https://static.vecteezy.com/system/resources/previews/011/537/711/original/box-empty-state-single-isolated-icon-with-outline-style-free-vector.jpg';

  static const String avatarDefault =
      'https://cdn-icons-png.flaticon.com/512/3607/3607444.png';

  static const String cardDefault =
      'https://cdn-icons-png.flaticon.com/512/3607/3607444.png';

  static const String keyTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'";

  static const String addressCompany = 'ADDRESS_COMPANY';

  static const String serialNumber = 'serial';
}
