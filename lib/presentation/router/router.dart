import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'router.gr.dart';

@injectable
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        // ========== Authentication ===========
        AutoRoute(page: WelcomeRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: VerifyAccountRoute.page),
        AutoRoute(page: TypeAccountRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: VerifyCodeRoute.page),
        AutoRoute(
          page: ChangePasswordRoute.page,
        ),
        AutoRoute(page: LoginSuccessRoute.page),
        AutoRoute(page: VerifyAccountV2Route.page),

        // ========== Account
        AutoRoute(page: AccountInfoRoute.page),
        AutoRoute(page: AccountInfoEditRoute.page),
        AutoRoute(page: ChangePassRoute.page),

        // ========== Company
        AutoRoute(page: CreateCompanyRoute.page),
        AutoRoute(page: WorkSpaceRoute.page),
        AutoRoute(page: DashboardV2Route.page),
        AutoRoute(page: SettingPointRoute.page),
        AutoRoute(page: PointExchangePackageCreateRoute.page),
        AutoRoute(page: HomeRoute.page),

        // =========== Product ===========
        AutoRoute(page: ProductCreateRoute.page),
        AutoRoute(page: ProductListRoute.page),
        AutoRoute(page: BrandRoute.page),
        AutoRoute(page: BrandCreateRoute.page),
        AutoRoute(page: BrandDetailRoute.page),
        AutoRoute(page: BrandUpdateRoute.page),
        AutoRoute(page: CategoryListRoute.page),
        AutoRoute(page: CategoryCreateRoute.page),
        AutoRoute(page: ProductDetailRoute.page),

        AutoRoute(page: VariantWmListRoute.page),

        // =========== Order ===========
        AutoRoute(page: OrderCreateRoute.page),
        AutoRoute(page: OrderManagerRoute.page),
        //AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: OrderListRoute.page),
        AutoRoute(page: OrderScanRoute.page),
        AutoRoute(page: OrderCreateSuccessRoute.page),
        AutoRoute(page: OrderCreateV2Route.page),
        AutoRoute(page: OrderConfirmRoute.page),
        //   AutoRoute(page: OrderDetailV2Route.page),
        AutoRoute(page: OrderCreateProdRoute.page),
        AutoRoute(page: OrderCreateServiceRoute.page),

        AutoRoute(page: ListWholesaleMadicineRoute.page),
        AutoRoute(page: OrderWmDetailRoute.page),
        AutoRoute(page: OrderWmCreateRoute.page),
        AutoRoute(page: OrderWmCreatePreviewRoute.page),
        AutoRoute(page: PromotionSelectRoute.page),

        // =========== Warehouse ===========
        AutoRoute(page: InventoryNavigatorRoute.page),
        AutoRoute(page: InventoryListRoute.page),
        AutoRoute(page: WarehouseListRoute.page),
        AutoRoute(page: CreateTicketImportRoute.page),
        AutoRoute(page: ProductsRoute.page),
        AutoRoute(page: WarehouseCreateRoute.page),
        AutoRoute(page: WarehouseDetailRoute.page),
        AutoRoute(page: WarehouseEditRoute.page),
        AutoRoute(page: BatchCreateRoute.page),
        AutoRoute(page: TicketListRoute.page),
        AutoRoute(page: TicketDetailRoute.page),
        AutoRoute(page: TicketCreatePreviewRoute.page),
        AutoRoute(page: SelectVariantRoute.page),

        // =========== Price ===========
        AutoRoute(page: PriceUpdateRoute.page),
        AutoRoute(page: PriceListRoute.page),

        // =========== Customer ===========
        AutoRoute(page: CustomerNavigatorRoute.page),
        AutoRoute(page: CustomerListRoute.page),
        AutoRoute(page: CustomerGroupRoute.page),
        AutoRoute(page: CustomerDetailRoute.page),
        AutoRoute(page: CustomerUpdateRoute.page),
        AutoRoute(page: CustomerGroupDetailRoute.page),
        AutoRoute(page: CustomerGroupCreateRoute.page),
        AutoRoute(page: SelectionCustomerRoute.page),

        // =========== debt ===========
        AutoRoute(page: DebtRoute.page),
        AutoRoute(page: DebtListRoute.page),
        AutoRoute(page: DebtCreateRoute.page),
        AutoRoute(page: DebtDetailRoute.page),

        // =========== report ===========
        AutoRoute(page: ReportRoute.page),

        // =========== Supplier ===========
        AutoRoute(page: SupplierNavigatorRoute.page),
        AutoRoute(page: SupplierListRoute.page),
        AutoRoute(page: SupplierGroupRoute.page),
        AutoRoute(page: SupplierDetailRoute.page),
        AutoRoute(page: SupplierUpdateRoute.page),

        // =========== ProductStandard ===========
        AutoRoute(page: ProductStandardListRoute.page),
        AutoRoute(page: ProductStandardDetailRoute.page),
        AutoRoute(page: ProductStandardUpdateRoute.page),

        // =========== Prepare ===========
        AutoRoute(page: PrepareListRoute.page),
        AutoRoute(page: PrepareDetailRoute.page),
        AutoRoute(page: PrepareUpdateRoute.page),

        // =========== Product Company ===========
        AutoRoute(page: ProductCompanyListRoute.page),
        AutoRoute(page: ProductCompanyDetailRoute.page),
        AutoRoute(page: ProductCompanyUpdateRoute.page),

        // =========== Company Pharma ===========
        AutoRoute(page: RegisterCompanyListRoute.page),
        AutoRoute(page: RegisterCompanyDetailRoute.page),
        AutoRoute(page: RegisterCompanyUpdateRoute.page),

        // =========== Employee ===========
        AutoRoute(page: EmployeeNavigatorRoute.page),
        AutoRoute(page: EmployeeListRoute.page),
        AutoRoute(page: EmployeeDetailRoute.page),
        AutoRoute(page: EmployeeUpdateRoute.page),
        AutoRoute(page: EmployeeChangePassRoute.page),

        // =========== Role ===========
        AutoRoute(page: RoleListRoute.page),
        AutoRoute(page: RoleDetailRoute.page),
        AutoRoute(page: RoleUpdateRoute.page),

        // =========== Conversation ===========
        AutoRoute(page: ConversationRoute.page),
        AutoRoute(page: ConversationListRoute.page),

        // =========== Service ===========
        AutoRoute(page: ServiceListRoute.page),
        AutoRoute(page: ServiceCreateRoute.page),
        AutoRoute(page: ServiceSelectionProductRoute.page),
        AutoRoute(page: ServiceDetailRoute.page),
        AutoRoute(page: ServiceUpdateRoute.page),
        AutoRoute(page: ServiceCreateV2Route.page),

        // =========== Medical Record ===========
        AutoRoute(page: MedicalRecordListRoute.page),
        AutoRoute(page: MedicalRecordCreateRoute.page),

        // =========== Notification ===========
        AutoRoute(page: NotificationListRoute.page),
        AutoRoute(page: NotificationDetailRoute.page),

        // customer v2
        AutoRoute(page: RouteCustomerDetail.page),
        AutoRoute(page: CustomerManagerV2Route.page),
        AutoRoute(page: CustomerActionRoute.page),

        AutoRoute(page: CustomerV2Route.page),
        AutoRoute(page: DetailCustomerV2Route.page),
        AutoRoute(page: CreateCustomerV2Route.page),

        //calendar
        AutoRoute(page: BookCalendarRoute.page),
        AutoRoute(page: BookCalendarDetailRoute.page),
        AutoRoute(page: CreateEventRoute.page),
        AutoRoute(page: DetailEventRoute.page),

        AutoRoute(page: ListEventRoute.page),
        AutoRoute(page: DetailEventV2Route.page),
        AutoRoute(page: CreateEventV2Route.page),
        AutoRoute(page: MedicalScheduleEditorRoute.page),
        AutoRoute(page: MedicalScheduleDetailRoute.page),

        //chat
        AutoRoute(page: ListChatRoute.page),
        AutoRoute(page: RouteChatRoom.page),

        //Phiếu khám
        AutoRoute(page: PhieuKhamRoute.page),
        AutoRoute(page: DetailPhieuKhamRoute.page),
        AutoRoute(page: DetailPrescriptionRoute.page),

        // Branch
        AutoRoute(page: BranchManagementRoute.page),
        AutoRoute(page: BranchCreateRoute.page),
        AutoRoute(page: BranchDetailRoute.page),
        AutoRoute(page: CreatePrescriptionRoute.page),

        //Staff
        AutoRoute(page: StaffManagerRoute.page),
        AutoRoute(page: DetailStaffRoute.page),
        AutoRoute(page: CreateOrUpdateStaffRoute.page),
        AutoRoute(page: ChangePassStaffRoute.page),

        //role
        AutoRoute(page: RoleManagerRoute.page),
        AutoRoute(page: DetailRoleRoute.page),
        AutoRoute(page: CreateRoleRoute.page),

        //kafa
        AutoRoute(page: WholesaleDrugMarketRoute.page),
        AutoRoute(page: ListImportOrderRoute.page),
        AutoRoute(page: VariantKafaDetailRoute.page),
        AutoRoute(page: ShoppingCartRoute.page),
        AutoRoute(page: DrugCartRoute.page),
        AutoRoute(page: ConfirmKafaOrderRoute.page),
        AutoRoute(page: ConfirmKafaOrderV2Route.page),
        AutoRoute(page: WholesaleDrugMarketV2Route.page),
        AutoRoute(page: CartVouchersRoute.page),
        AutoRoute(page: KafaCloneProductRoute.page),

        AutoRoute(page: KafaOrderDetailRoute.page),

        AutoRoute(page: UpdateAppRoute.page),
        AutoRoute(page: SplashRoute.page),
        //reset password
        AutoRoute(page: NewPassRoute.page),
        AutoRoute(page: OtpResetPassRoute.page),
        AutoRoute(page: SuccessPassRoute.page),
        AutoRoute(page: VerifyOtpRoute.page),

        //address v2
        AutoRoute(page: AddressRoute.page),
        //workspace v2
        AutoRoute(page: ListWorkspaceRoute.page),
        AutoRoute(page: CreateWorkspaceRoute.page),
        AutoRoute(page: DetailWpV2Route.page),

        // Profile V2
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: ProfileChangePasswordRoute.page),
        AutoRoute(page: ProfileEditRoute.page),

        // Branch V2
        AutoRoute(page: AddStaffBranchV2Route.page),
        AutoRoute(page: DetailBranchV2Route.page),
        AutoRoute(page: ListBranchV2Route.page),

        // Personal Management
        AutoRoute(page: PersonalManagementRoute.page),

        // Emp v2
        AutoRoute(page: EmpManagementRoute.page),
        AutoRoute(page: AssignEmployeeRoute.page),
        AutoRoute(page: AddWorkToEmpRoute.page),
        AutoRoute(page: EmpInformationRoute.page),
        AutoRoute(page: EditEmpRoute.page),

        // Service v2

        AutoRoute(page: CreateServiceV2Route.page),
        AutoRoute(page: DetailServiceV2Route.page),
        AutoRoute(page: ServiceV2Route.page),
        AutoRoute(page: AddPrdServiceV2Route.page),

        // Role v2
        AutoRoute(page: RoleManagerV2Route.page),
        AutoRoute(page: CreateRoleV2Route.page),
        AutoRoute(page: DetailRoleV2Route.page),

        // Product V2
        AutoRoute(page: ProductManagerV2Route.page),
        AutoRoute(page: ProductCreateV2Route.page),
        AutoRoute(page: ProductDetailV2Route.page),
        AutoRoute(page: WarehouseImportRoute.page),

        // Order V2
        AutoRoute(page: OrderManagerV2Route.page),
        AutoRoute(page: CreateOrderRoute.page),
        AutoRoute(page: ConfirmOrderRoute.page),
        AutoRoute(page: OrderHubActionRoute.page),

        AutoRoute(page: OrderDetailProdV2Route.page),
        AutoRoute(page: OrderBillRoute.page),

        // Phieu kham v2
        AutoRoute(page: PhieuKhamV2Route.page),
        AutoRoute(page: DetailPkV2Route.page),
        AutoRoute(page: PrintMedicalBillRoute.page),

        AutoRoute(page: UnderDevelopmentRoute.page),

        //print
        AutoRoute(page: PrintOrderWifiRoute.page),
        AutoRoute(page: PrintMedicalBillRoute.page),

        // Wallet
        AutoRoute(page: WalletRoute.page),
        AutoRoute(page: WalletDepositRoute.page),
        AutoRoute(page: WarehouseListRouteV2.page),
        AutoRoute(page: ManagerWarehouseImportRoute.page),
        AutoRoute(page: ReceiptExportListRoute.page),
        AutoRoute(page: ReceiptExportCreateRoute.page),
        AutoRoute(page: ReceiptImportCreateRoute.page),
        AutoRoute(page: ReceiptExportDetailRoute.page),
        AutoRoute(page: ShipmentListRoute.page),
        AutoRoute(page: ShipmentDetailRoute.page),
        AutoRoute(page: ReceiptImportDetailRoute.page),
        AutoRoute(page: PreviewPrintCodeTemRoute.page),
        AutoRoute(page: CreateWarehouseReceiptRoute.page),

        //electric invoice
        AutoRoute(page: SetupElectricInvoiceRoute.page),
        AutoRoute(page: SetupViettelInvoiceRoute.page),
        AutoRoute(page: PrintBarcodeRoute.page),
        AutoRoute(page: SelectPrintRoute.page),
        AutoRoute(page: PrintInvoiceV2Route.page),
        AutoRoute(page: OrderHubActionV2Route.page),

        //scan image
        AutoRoute(page: ImagePickerRoute.page),
      ];
}
