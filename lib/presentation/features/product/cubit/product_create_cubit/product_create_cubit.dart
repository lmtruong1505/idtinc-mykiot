import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/brand_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/category_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/company_pharma_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/ingredient_payload_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_detail_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_type_entity.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_create_use_case.dart';
import 'package:pharmago/presentation/features/product/domain/usecase/product_update_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import '../../domain/entities/unit_payload_entity.dart';
import '../../domain/entities/variant_payload_entity.dart';
import 'product_create_state.dart';

@injectable
class ProductCreateCubit extends Cubit<ProductCreateState> {
  ProductCreateCubit(
    this._productCreateUseCase,
    this._productUpdateUseCase,
  ) : super(const ProductCreateState());

  final ProductCreateUseCase _productCreateUseCase;
  final ProductUpdateUseCase _productUpdateUseCase;

  void init(ProductDetailEntity? prod) {
    if(prod == null){
      return;
    }
    emit(
      state.copyWith(
        productPayload: state.productPayload.copyWith(
          code: prod.product?.code ?? '',
          name: prod.product?.name,
          taDuoc: prod.product?.taDuoc,
          nongDo: prod.product?.nongDo,
          lieuDung: prod.product?.lieuDung,
          chiDinh: prod.product?.chiDinh,
          chongChiDinh: prod.product?.chongChiDinh,
          congDung: prod.product?.congDung,
          tacDungPhu: prod.product?.tacDungPhu,
          thanTrong: prod.product?.thanTrong,
          tuongTac: prod.product?.tuongTac,
          baoQuan: prod.product?.baoQuan,
          dongGoi: prod.product?.dongGoi,
          noiSx: prod.product?.noiSx,
          moTa: prod.product?.moTa,
          active: prod.product?.active ?? false,
        ),
        unitsPayload: state.unitsPayload.copyWith(
          name: prod.units.first.name,
          sellPrice: prod.units.first.sellPrice,
          importPrice: prod.units.first.importPrice,
          weight: prod.units.first.weight,
          weightUnit: prod.units.first.weightUnit,
        ),
        ingredientPayload: prod.ingredients.map((e) {
          return IngredientPayloadEntity(
            name: e.name,
            weight: e.weight,
            unit: e.unit,
          );
        }).toList(),
        unitChangesPayload: List.generate(prod.units.length - 1, (index) {
          return UnitChangePayloadEntity(
            name: prod.units[index + 1].name,
            value: prod.units[index + 1].value,
            sellPrice: prod.units[index + 1].sellPrice,
          );
        }),
        variantsPayload: prod.variants.map((e) {
          return VariantPayloadEntity(
            name: e.name,
            barcode: e.barcode,
            registerNumber: e.registerNumber,
            decisionNumber: e.decisionNumber,
            longevity: e.longevity,
            initialInventory: e.initialInventory,
          );
        }).toList(),
        isUpdate: true,
      ),
    );
  }

  void addUnitChange() {
    final list = List<UnitChangePayloadEntity>.from(state.unitChangesPayload);
    list.add(const UnitChangePayloadEntity());
    emit(state.copyWith(unitChangesPayload: list));
  }
  void removeImageProduct(int index) {
    final list = List<File>.from(state.imagesProduct);
    list.removeAt(index);
    emit(state.copyWith(imagesProduct: list));
  }

  void removeUnitChange(int index) {
    final list = List<UnitChangePayloadEntity>.from(state.unitChangesPayload);
    list.removeAt(index);
    emit(state.copyWith(unitChangesPayload: list));
  }

  void addIngredient() {
    final list = List<IngredientPayloadEntity>.from(state.ingredientPayload);
    list.add(const IngredientPayloadEntity());
    emit(state.copyWith(ingredientPayload: list));
  }

  void removeingredient(int index) {
    final list = List<IngredientPayloadEntity>.from(state.ingredientPayload);
    list.removeAt(index);
    emit(state.copyWith(ingredientPayload: list));
  }

  void ingredientFormChange({
    required int index,
    String? name,
    String? weight,
    String? unit,
  }) {
    final list = List<IngredientPayloadEntity>.from(state.ingredientPayload);
    list[index] = list[index].copyWith(
      name: name ?? list[index].name,
      weight: weight != null ? double.tryParse(weight) : list[index].weight,
      unit: unit ?? list[index].unit,
    );
    emit(state.copyWith(ingredientPayload: list));
  }

  void infoFormChange({
    String? code,
    String? name,
    String? taDuoc,
    String? nongDo,
    String? lieuDung,
    String? chiDinh,
    String? chongChiDinh,
    String? congDung,
    String? hinhThuc,
    String? tacDungPhu,
    String? thanTrong,
    String? tuongTac,
    String? baoQuan,
    String? dongGoi,
    String? noiSx,
    String? moTa,
    bool? active,
  }) {
    if (name != null || code != null) {
      final listVariants =
          List<VariantPayloadEntity>.from(state.variantsPayload);
      listVariants[0] = listVariants[0].copyWith(
        name: name ?? listVariants[0].name,
        code: code ?? listVariants[0].code,
      );
      emit(state.copyWith(variantsPayload: listVariants));
    }
    final info = state.productPayload.copyWith(
      code: code ?? state.productPayload.code,
      name: name ?? state.productPayload.name,
      taDuoc: taDuoc ?? state.productPayload.taDuoc,
      nongDo: nongDo ?? state.productPayload.nongDo,
      lieuDung: lieuDung ?? state.productPayload.lieuDung,
      chiDinh: chiDinh ?? state.productPayload.chiDinh,
      chongChiDinh: chongChiDinh ?? state.productPayload.chongChiDinh,
      congDung: congDung ?? state.productPayload.congDung,
      hinhThuc: hinhThuc ?? state.productPayload.hinhThuc,
      tacDungPhu: tacDungPhu ?? state.productPayload.tacDungPhu,
      thanTrong: thanTrong ?? state.productPayload.thanTrong,
      tuongTac: tuongTac ?? state.productPayload.tuongTac,
      baoQuan: baoQuan ?? state.productPayload.baoQuan,
      dongGoi: dongGoi ?? state.productPayload.dongGoi,
      noiSx: noiSx ?? state.productPayload.noiSx,
      active: active ?? state.productPayload.active,
      moTa: moTa ?? state.productPayload.moTa,
    );
    emit(state.copyWith(productPayload: info));
  }

  void unitFormChange({
    String? name,
    double? sellPrice,
    double? importPrice,
    double? weight,
    String? weightUnit,
  }) {

    final info = state.unitsPayload.copyWith(
      name: name ?? state.unitsPayload.name,
      sellPrice: sellPrice ?? state.unitsPayload.sellPrice,
      importPrice: importPrice ?? state.unitsPayload.importPrice,
      weight: weight ?? state.unitsPayload.weight,
      weightUnit: weightUnit ?? state.unitsPayload.weightUnit,
    );
    emit(state.copyWith(unitsPayload: info));
  }

  void unitChangeFormChange({
    required int index,
    String? name,
    int? value,
    String? priceSell,
  }) {
    final list = List<UnitChangePayloadEntity>.from(state.unitChangesPayload);
    list[index] = list[index].copyWith(
      name: name ?? list[index].name,
      value: value ?? list[index].value,
      sellPrice: double.tryParse(priceSell ?? '${list[index].value}'),
    );
    emit(state.copyWith(unitChangesPayload: list));
  }

  void variantFormChange({
    required int index,
    String? barcode,
    String? registerNumber,
    String? decisionNumber,
    String? longevity,
    String? image,
    int? initialInventory,
  }) {
    final list = List<VariantPayloadEntity>.from(state.variantsPayload);
    if(barcode != null){
      print('===> barcode: $barcode');
    }
    list[index] = list[index].copyWith(
      barcode: barcode ?? list[index].barcode,
      registerNumber: registerNumber ?? list[index].registerNumber,
      decisionNumber: decisionNumber ?? list[index].decisionNumber,
      longevity: longevity ?? list[index].longevity,
      image: image ?? list[index].image,
      initialInventory: initialInventory ?? list[index].initialInventory,
    );
    emit(state.copyWith(variantsPayload: list));
  }

  void imageProductChange(List<XFile> images) {
    if (images.isNotEmpty) {
      variantFormChange(
        index: 0,
        image: images[0].path,
      );
    }
    final files = images.map((e) => File(e.path)).toList();
    final filesByte = images
        .map((e) => base64Encode(File(e.path).readAsBytesSync()))
        .toList();
    final productInfo = state.productPayload.copyWith(image: filesByte);
    emit(
      state.copyWith(
        imagesProduct: files,
        productPayload: productInfo,
      ),
    );
  }

  void selectBrand(BrandEntity? value) {
    emit(state.copyWith(brandSelected: value));
  }

  void selectCategory(CategoryEntity? value) {
    emit(state.copyWith(categorySelected: value));
  }

  void selectProductType(ProductTypeEntity? value) {
    emit(state.copyWith(productTypeEntity: value));
  }

  void selectMasterData({
    BasicEntity? classify,
    BasicEntity? preparationType,
    BasicEntity? productionStandard,
    CompanyPharmaEntity? congTyDk,
    CompanyPharmaEntity? congTySx,
  }) {
    emit(
      state.copyWith(
        classify: classify ?? state.classify,
        preparationType: preparationType ?? state.preparationType,
        productionStandard: productionStandard ?? state.productionStandard,
        congTyDk: congTyDk ?? state.congTyDk,
        congTySx: congTySx ?? state.congTySx,
      ),
    );
  }

  Future<BaseResponseModel> createProduct() async {
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final payload = state.productPayload.copyWith(company: company);

    final variants = state.variantsPayload.map((e) {
      final item = e.copyWith(
        image: e.image != null
            ? base64Encode(File(e.image!).readAsBytesSync())
            : null,
      );
      return item;
    }).toList();

    final input = ProductCreateInput(
      payload: payload.copyWith(
        congTyDk: state.congTyDk?.id,
        congTySx: state.congTySx?.id,
        phanLoai: state.classify?.code,
        dangBaoChe: state.preparationType?.code,
        tieuChuanSx: state.productionStandard?.code,
        brand: state.brandSelected?.id,
        category: state.categorySelected?.id,
        type: state.productTypeEntity?.id,
      ),
      unitPayloadEntity: state.unitsPayload,
      unitChangePayloadEntity: state.unitChangesPayload,
      variantsPayload: variants,
      ingredientPayload: state.ingredientPayload,
    );
    final res = await _productCreateUseCase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel> updateProduct(int id) async {
    final company =
    AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final payload = state.productPayload.copyWith(company: company);

    final variants = state.variantsPayload.map((e) {
      final item = e.copyWith(
        image: e.image != null
            ? base64Encode(File(e.image!).readAsBytesSync())
            : null,
      );
      return item;
    }).toList();

    final input = ProductUpdateInput(
      id: id,
      payload: payload.copyWith(
        congTyDk: state.congTyDk?.id,
        congTySx: state.congTySx?.id,
        phanLoai: state.classify?.code,
        dangBaoChe: state.preparationType?.code,
        tieuChuanSx: state.productionStandard?.code,
        brand: state.brandSelected?.id,
        category: state.categorySelected?.id,
        type: state.productTypeEntity?.id,
      ),
      unitPayloadEntity: state.unitsPayload,
      unitChangePayloadEntity: state.unitChangesPayload,
      variantsPayload: variants,
      ingredientPayload: state.ingredientPayload,
    );
    final res = await _productUpdateUseCase.execute(input);
    return res.response;
  }
}
