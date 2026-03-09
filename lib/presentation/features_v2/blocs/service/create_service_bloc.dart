part of 'bloc_index.dart';

class CreateServiceV2Bloc extends Cubit<CubitState> {
  CreateServiceV2Bloc() : super(CubitState());
  final baseKey = GlobalKey<FormState>();
  final priceKey = GlobalKey<FormState>();

  final _repo = ServiceV2Repository();
  List<ServiceTypeV2Model> groupPrice = [];

  List<MapEntry<int, XFile>> _images = [];
  List<MapEntry<int, XFile>> get images => _images;
  List<int> indexRemove = [];
  set images(List<MapEntry<int, XFile>> value) {
    _images = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<ProductV2Model> _products = [];
  List<ProductV2Model> get products => _products;
  set products(List<ProductV2Model> value) {
    _products = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  List<PriceServiceModel> _prices = [];
  List<PriceServiceModel> get prices => _prices;
  set prices(List<PriceServiceModel> value) {
    _prices = value;

    emit(state.copyWith(status: BlocStatus.success));
  }

  final baseService = BaseSeviceModel(title: '');

  final additional = ExtraServiceModel();

  bool get isActive {
    final mapData = _prices.map((e) => e.isDefault ?? false).toList();

    final priceOk = mapData.contains(true);
    return priceOk && baseService.title?.isEmptyOrNull == false;
  }

  setTitle(String value) {
    baseService.title = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<void> create(BuildContext context) async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tải...',
    );
    //emit(state.copyWith(status: BlocStatus.loading));
    final prdIds = _products.map((e) => e.id ?? -1).toList();
    prdIds.removeWhere((element) => element == -1);

    final param = CreateServiceV2Model(
      baseService: baseService,
      prices: prices,
      products: prdIds,
      images: _images,
      additional: additional,
    );
    final res = await _repo.create(param);
    if (!context.mounted) return;
    context.pop();

    if (res.code == 200) {
      context.router
          .popUntil((route) => route.settings.name == ServiceV2Route.name);
      getIt<ListServiceBloc>().getList();
      ToastCustom.show(
        context,
        title: 'Thành công',
        msg: 'Tạo dịch vụ thành công',
        svgIcon: Assets.svgSuccess,
        color: AppColors.ultility_positive_60,
        route: res.data is int
            ? DetailServiceV2Route(
                id: res.data,
                types: context.read<ServiceTypeBloc>().list,
              )
            : null,
      );
    } else {
      ToastCustom.show(
        context,
        title: 'Lỗi',
        msg: res.message ?? 'Tạo dịch vụ không thành công',
        svgIcon: Assets.svgError,
        color: AppColors.ultility_negative_60,
      );
    }
  }

  Future<void> update(BuildContext context, int id) async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tải...',
    );

    final prdIds = _products.map((e) => e.id ?? -1).toList();
    prdIds.removeWhere((element) => element == -1);
    final imgs = _images
        .where(
          (element) => !element.value.path.startsWith('http'),
        )
        .toList();
    final param = CreateServiceV2Model(
      baseService: baseService,
      prices: prices,
      products: prdIds,
      images: imgs,
      additional: additional,
      indexRemove: indexRemove,
    );
    final res = await _repo.update(id, param);
    if (!context.mounted) return;
    context.pop();
    if (res.code == 200) {
      context.router
          .popUntil((route) => route.settings.name == ServiceV2Route.name);
      getIt<ListServiceBloc>().getList();
      ToastCustom.show(
        context,
        title: 'Thành công',
        msg: 'Cập nhật dịch vụ thành công',
        svgIcon: Assets.svgSuccess,
        color: AppColors.ultility_positive_60,
        route: res.data is int
            ? DetailServiceV2Route(
                id: res.data,
                types: context.read<ServiceTypeBloc>().list,
              )
            : null,
      );
    } else {
      ToastCustom.show(
        context,
        title: 'Lỗi',
        msg: res.message ?? 'Cập nhật dịch vụ không thành công',
        svgIcon: Assets.svgError,
        color: AppColors.ultility_negative_60,
      );
    }
  }

  setData(
    DetailServiceV2Model service,
    List<ServiceTypeV2Model> types,
  ) {
    print(service.vat);
    final typesData = types
        .map(
          (e) => e.copyWith(prices: []),
        )
        .toList();
    _images = service.images
            ?.map(
              (e) => MapEntry<int, XFile>(e.order!, XFile(e.image ?? 'http')),
            )
            .toList() ??
        [];
    _products = service.products ?? [];
    groupPrice =
        ServiceTypeV2Model.mapListPrice(typesData, service.prices ?? []);

    _prices = service.prices ?? [];
    print(groupPrice.map((e) => e.prices));

    // Thông tin chung
    baseService.title = service.title;
    baseService.description = service.description;
    baseService.code = service.code;
    baseService.vat = service.vat;
    baseService.active = service.active;

    // Thông tin bổ sung

    additional.chiDinh = service.chiDinh;
    additional.chongChiDinh = service.chongChiDinh;
    additional.congDung = service.congDung;
    additional.luuY = service.luuY;
    additional.tacDungPhu = service.tacDungPhu;

    emit(state.copyWith(status: BlocStatus.success));
  }
}
