import 'package:injectable/injectable.dart';

import '../../env/env_config.dart';

@injectable
class Api {
  static String urlGMS = 'https://maps.googleapis.com/maps/api';
  static String checkversion = 'v1/auth/version';
  // dashboard

  static String dashboardOrder = 'v1/dashboard/order';
  static String dashboardCustomer = 'v1/dashboard/customer';
  static String dashboardEmployee = 'v1/dashboard/employee';
  static String dashboardProduct = 'v1/dashboard/product';
  static String dashboardBrand = 'v1/dashboard/brand';

  //account
  static String login = 'v1/auth/login';
  static String register = 'v1/auth/register';
  static String accountDetail = 'v1/auth/detail';
  static String verify = 'v1/auth/verify';
  static String refreshToken = 'v1/auth/refresh';
  static String accountInactive = 'v1/auth/inactive';
  static String checktoken = 'v1/auth/token';
  static String auth = 'auth/v1';
  static String sendCode = 'v1/auth/send-code';
  static String accountList = 'v1/company/employees';
  static String employees = 'v1/company/employees-branch';
  static String deleteAccount = 'v2/auth/accounts/details';

  static String address = 'v1/location';
  static String company = 'v1/company';
  static String authWs = 'v1/company/auth-key';
  static String authWsVerify = 'v1/company/verify-authentication';
  static String workspaceMenu = 'v1/company/workspace-switch?workspace=';
  static String workspaceTypes = 'v1/company/workspace-types';
  static String product = 'v1/product';
  static String service = 'v1/services';
  static String serviceDetail = 'v1/services/detail';
  static String createService = 'v1/services/create';
  static String serviceList = 'v1/services/list';
  static String serviceTypes = 'v1/services/service-types';

  static String brand = 'v1/product/brands';
  static String category = 'v1/product/categories';
  static String order = 'v1/order';
  static String account = 'v1/auth';

  static String resetPass = 'v1/auth/require-reset-password';
  static String verifyOtpResetPass = 'v1/auth/verify-otp-password';
  static String newPass = 'v1/auth/set-password';

  //staff
  static String staff = 'v1/company/employees';
  static String removeStaff = 'v1/company/employees';
  static String employeeRole = 'v1/company/employees-roles';

  // Product
  static String unit = 'product/api/unit/';
  static String packaging = 'product/api/packaging/';

  // Price
  static String priceList = 'price_list/v1/list';
  static String priceUpdate = 'price_list/v1/update';

  // Report
  static String reportHome = 'report/v1/home';
  static String reportRevenue = 'report/v1/revenue';
  static String reportOrder = 'report/v1/order';
  static String reportCustomer = 'report/v1/customer';
  static String reportCustomerRevenue = 'report/v1/customer-revenue';

  // Medical Record
  static String medicalRecord = 'medical_record/v1';
  static String getMedicalRecord = 'v1/customers/medical_record';
  static String medicalRecordsCustomer = 'v1/customers/medical-records-customer';

  // Warehouse
  static String warehouse = 'warehouse/v1';
  static String inventoryVoucher = 'warehouse/api/inventory_voucher/';
  static String warehouseCreate = 'warehouse/v1/ticket/create';
  static String variantList = 'product/v1/variant/list';
  static String warehouseList = 'v1/product/warehouse-manage';
  static String warehouseV3 = 'v1/warehouse/';
  static String warehouseAssociate = 'v1/company/workspace-associate';
  static String warehouseListV2 = 'v1/warehouse';
  static String inventoryListV2 = 'v1/warehouse/report-warehouse-pharma';
  static String inventoryList = 'warehouse/v1/consignment/list';
  static String ticketList = 'warehouse/v1/ticket';
  static String ticketStatus = 'warehouse/v1/ticket/update_status';
  static String ticketDetail = 'warehouse/v1/ticket/';
  static String importReceipts = 'v1/warehouse/importreceipt';
  static String importReceiptDetail = 'v1/warehouse/shipmentinimportreceipt';
  static String importReceiptInfor = 'v1/warehouse/importreceipt';
  static String createImportReceipt = 'v1/warehouse/import-receipt-pharma';
  static String createImportReceiptV2 = 'v1/warehouse/import-receipt-pharma-v2';
  static String updateImportReceiptV2 = 'v1/warehouse/update-import-receipt-v2';
  static String invoiceAiExtract = 'https://pharmago-invoice-ai.too.onl/api/v1/extract';
  static String listShipmentByProduct = 'v1/warehouse/list-shipment-by-product';
  static String scanShipmentDetail = 'v1/warehouse/scan-shipment-detail';
  static String exportReceipt = 'v1/warehouse/exportreceipt';
  static String inforexportshipment = 'v1/warehouse/inforexportshipment';
  static String listShipment = 'v1/warehouse/list-shipment-view';
  static String listUserWarehouse = 'v2/auth/accounts/warehouse-management';
  static String prdShipments = 'v1/product/shipment-product-detail';
  static String prdsFromAI = 'v1/extract';

  // variant
  static String variant = 'variant/v1';
  static String variantWarehouse = 'warehouse/api/variant_warehouse/';
  static String productType = 'v1/product/types';
  static String classify = 'classify/v1';
  static String companyPharma = 'v1/product/pharma';
  static String preparationType = 'preparation_type/v1';
  static String productionStandard = 'production_standard/v1';

  // supplier
  static String supplierList = 'supplier/v1/list';
  static String supplierDetail = 'supplier/v1/supplier/';
  static String supplierCreate = 'supplier/v1/create';

  // customer
  static String customerList = 'v1/customers/list';
  static String customerDetail = 'v1/customers/detail/';
  static String customerPoint = 'v1/customers/customer-point';
  static String customerCreate = 'v1/customers/create';
  static String customerGroupList = 'customer-group/v1/list';
  static String customerGroupDetail = 'customer-group/v1/detail/';
  static String customerGroupCreate = 'customer-group/v1/create';
  static String customerGroupUpdate = 'customer-group/v1/update/';
  static String customerUploadFile = 'v1/customers/medical_record';

  // production standard
  static String productionStandardList = 'production_standard/v1/list';
  static String productionStandardDetail = 'production_standard/v1/detail/';
  static String productionStandardCreate = 'production_standard/v1/create';

  // prepare
  static String prepareList = 'preparation_type/v1/list';
  static String prepareDetail = 'preparation_type/v1/detail/';
  static String prepareCreate = 'preparation_type/v1/create';

  // company
  static String companyList = 'company_pharma/v1/list';
  static String companyDetail = 'company_pharma/v1/detail/';
  static String companyCreate = 'company_pharma/v1/create';
  static String companyUpdate = '/company_pharma/v1/update/';
  static String companyDelete = 'company_pharma/v1/delete/';

  // role
  static String roleMasterList = 'v1/company/permissions';
  static String roleList = 'v1/company/roles';
  static String roleDetail = 'v1/company/roles/detail/';
  static String roleCreate = 'v1/company/roles';
  static String permissionWorkspace =
      'v1/company/permission-workspace?workspace=';

  // debt note
  static String debtNote = 'debt-note/v1';
  static String debtRepayment = 'debt-repayment/v1';

  // conversation
  static String conversationList = 'conversation/v1/';
  static String messageList = 'message/v1/';
  static String chat = 'v1/customers/chat/';
  static String uploadImageChat = 'v1/customers/chat/media';

  // notification
  static String notification = 'v1/noti';

  //event
  static String createEvent = 'v1/appointments/create';
  static String createSchedule = 'v1/appointments/create-v2';
  static String updateConclusion = 'v1/conclusion-appointment';
  static String createPrescription = 'v1/prescription/create-v2';
  static String detailPrescription = 'v1/prescription/detail-v2';
  static String diagnosis = 'v1/diagnosis-conclusion';
  static String serviceConclusion = 'v1/medical-bill/create-v2';
  static String listEvent = 'v1/appointments/list';
  static String calendarEvent = 'v1/appointments-in-month';

  static String serviceCustomer = 'service/v1/customer';
  static String productCustomer = 'product/v1/variant/customer';
  static String detailEvent = 'v1/appointments/detail/';
  static String detailEventV2 = 'v1/appointments/detail-v2/';
  static String cancelEvent = 'v1/appointments/cancel/';
  static String updateStatus = 'v1/appointments/update-status/';
  static String reminderZalo = 'v1/appointments-reminder/';
  static String reSendEventZalo = 'v1/appointments-send/';

  //phieu kham
  static String createPhieuKham = 'v1/medical-bill/create';
  static String detailPhieuKham = 'v1/medical-bill/detail/';
  static String listPhieuKham = 'v1/medical-bill/list';
  static String orderPhieuKham = 'order/v1/medical_bill/';
  //đơn thuốc
  // static String createPrescription = 'v1/prescription/create';
  // static String detailPrescription = 'v1/prescription/detail/';

  //kafa
  static String kafaOrder = 'v1/kafa/orders';

  // ========== WeZolo ===========
  static String baseWeZolo = EnvironmentConfig.URL_WEZOLO;

  // conversation
  static String chatList = '$baseWeZolo/v1/conversations/';
  static String chatUuid = '$baseWeZolo/v1/get-uuid-conversation/';
  static String chatMessages = '$baseWeZolo/v1/conversations-message/';
  static String chatMessagesNew = '$baseWeZolo/v1/new-conversations/';
  static String contact = '$baseWeZolo/v1/auth/profile-other-user/';
  //wss://core.wezolo.com/socket/?oa_id=${this.$route.query.oa_id}
  static String urlSocket = 'wss://core.wezolo.com/socket/';

  // ========== Kafa ===========
  static String baseKafa = EnvironmentConfig.URL_KAFA;
  // variant
  static String variantWm = '$baseKafa/product/api/variantsystem/';
  static String variantDetailWm = '$baseKafa/product/api/variant/';
  static String variantPromotionWm =
      '$baseKafa/product/api/variantwithpromotion/';
  // promotion
  static String promotionType = '$baseKafa/promotion/api/typediscount/';
  static String promotions = '$baseKafa/promotion/api/promotionsystem/';
  // order
  static String orderWm = '$baseKafa/order/api/ordercompanysystem/';
  static String orderCountFilter =
      '$baseKafa/order/api/countordercompanysystem/';

  // kafa
  static String variantKafa = 'v1/kafa/variants';
  static String variantPromotionKafa = 'v1/kafa/promotions';
  static String orderKafa = 'v1/kafa/orders';
  static String banners = 'v1/product/banner';
  static String carts = 'v1/order/cart';
  static String vouchers = 'v1/kafa/promotions';
  static String updateProduct = 'v1/order/update-quantity-item-cart';
  static String addProductToCart = 'v1/order/cart';
  static String deleteCartPrds = 'v1/order/delete-item-cart';
  static String drugFilter = 'v1/kafa/infor-category-brand-group';

  // profile
  static String profile = 'v1/auth/profile';
  static String changePass = 'v1/auth/profile-change-password';
  static String changeAvatar = 'v1/auth/profile-change-avatar';
  static String profileAction = 'v2/auth/accounts/change-active';

  // Employee v2
  static String emp = 'v1/company/employees';
  static String empService = 'v1/appointments/employee-list';
  static String empByCodePharma = 'v1/auth/user';
  static String empTerminated = 'v1/company/employees-terminated';

  // Role v2
  static String position = 'v1/company/positions';
  static String permission = 'v1/company/permissions';
  static String detachEmp = 'v1/company/detach-employee';

  // Product v2
  static String productList = 'v1/product/list';
  static String productKafaList = 'v1/product/clone-data-product';
  static String productDetail = 'v1/product/detail/';

  // Order v2
  static String orderList = 'v1/order/list';
  static String orderCreate = 'v1/order/create';

  // Phieu kham v2
  static String pathologies = 'v1/company/pathologies';
  static String medicalBill = 'v1/medical-bill';
  static String prescription = 'v1/prescription';

  // Ví
  static String wallet = 'v1/wallet';

  // Electric Invoice
  static String getInfor = 'api/get_info';
  static String checkInfor = 'api/check_info';
  static String createOriganization = 'api/create_origanization';
  static String exportElectricInvoice = 'v1/order/red-invoice';
  static String getSerials = 'v1/company/api/invoice-attributes';
  static String createSerial = 'v1/company/api/invoice-attributes/';
  static String createViettelAccount = 'v1/company/api/create-viettel-account';
  static String invoiceAttributes = 'v1/company/api/invoice-attributes/';
  static String pdfRedInvoice = 'v1/order/pdf-red-invoice';
  static String viettelLogin = 'https://api-vinvoice.viettel.vn/auth/login';
}

class SocketUrl {
  static String domain = 'wss://api.pharmago.asia/ws';
  static String invoiceStatus = '$domain/invoice-status/workspace';
}
