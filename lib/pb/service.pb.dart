//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Variant extends $pb.GeneratedMessage {
  factory Variant({
    $core.int? id,
    $core.String? code,
    $core.String? name,
    $core.String? barcode,
    $core.String? decisionNumber,
    $core.String? registerNumber,
    $core.String? longevity,
    $core.double? vat,
    $core.int? product,
    $core.String? media,
    $core.int? quantityInStock,
    $core.Iterable<Unit>? units,
    $core.double? priceSell,
    $core.double? priceImport,
    $core.double? revenue,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (code != null) {
      $result.code = code;
    }
    if (name != null) {
      $result.name = name;
    }
    if (barcode != null) {
      $result.barcode = barcode;
    }
    if (decisionNumber != null) {
      $result.decisionNumber = decisionNumber;
    }
    if (registerNumber != null) {
      $result.registerNumber = registerNumber;
    }
    if (longevity != null) {
      $result.longevity = longevity;
    }
    if (vat != null) {
      $result.vat = vat;
    }
    if (product != null) {
      $result.product = product;
    }
    if (media != null) {
      $result.media = media;
    }
    if (quantityInStock != null) {
      $result.quantityInStock = quantityInStock;
    }
    if (units != null) {
      $result.units.addAll(units);
    }
    if (priceSell != null) {
      $result.priceSell = priceSell;
    }
    if (priceImport != null) {
      $result.priceImport = priceImport;
    }
    if (revenue != null) {
      $result.revenue = revenue;
    }
    return $result;
  }
  Variant._() : super();
  factory Variant.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Variant.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Variant', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'barcode')
    ..aOS(5, _omitFieldNames ? '' : 'decisionNumber')
    ..aOS(6, _omitFieldNames ? '' : 'registerNumber')
    ..aOS(7, _omitFieldNames ? '' : 'longevity')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'vat', $pb.PbFieldType.OF)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'product', $pb.PbFieldType.O3)
    ..aOS(10, _omitFieldNames ? '' : 'media')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'quantityInStock', $pb.PbFieldType.O3)
    ..pc<Unit>(12, _omitFieldNames ? '' : 'units', $pb.PbFieldType.PM, subBuilder: Unit.create)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'priceSell', $pb.PbFieldType.OF)
    ..a<$core.double>(14, _omitFieldNames ? '' : 'priceImport', $pb.PbFieldType.OF)
    ..a<$core.double>(15, _omitFieldNames ? '' : 'revenue', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Variant clone() => Variant()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Variant copyWith(void Function(Variant) updates) => super.copyWith((message) => updates(message as Variant)) as Variant;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Variant create() => Variant._();
  Variant createEmptyInstance() => create();
  static $pb.PbList<Variant> createRepeated() => $pb.PbList<Variant>();
  @$core.pragma('dart2js:noInline')
  static Variant getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Variant>(create);
  static Variant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get barcode => $_getSZ(3);
  @$pb.TagNumber(4)
  set barcode($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBarcode() => $_has(3);
  @$pb.TagNumber(4)
  void clearBarcode() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get decisionNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set decisionNumber($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDecisionNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecisionNumber() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get registerNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set registerNumber($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRegisterNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearRegisterNumber() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get longevity => $_getSZ(6);
  @$pb.TagNumber(7)
  set longevity($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLongevity() => $_has(6);
  @$pb.TagNumber(7)
  void clearLongevity() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get vat => $_getN(7);
  @$pb.TagNumber(8)
  set vat($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasVat() => $_has(7);
  @$pb.TagNumber(8)
  void clearVat() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get product => $_getIZ(8);
  @$pb.TagNumber(9)
  set product($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasProduct() => $_has(8);
  @$pb.TagNumber(9)
  void clearProduct() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get media => $_getSZ(9);
  @$pb.TagNumber(10)
  set media($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMedia() => $_has(9);
  @$pb.TagNumber(10)
  void clearMedia() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get quantityInStock => $_getIZ(10);
  @$pb.TagNumber(11)
  set quantityInStock($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasQuantityInStock() => $_has(10);
  @$pb.TagNumber(11)
  void clearQuantityInStock() => clearField(11);

  @$pb.TagNumber(12)
  $core.List<Unit> get units => $_getList(11);

  @$pb.TagNumber(13)
  $core.double get priceSell => $_getN(12);
  @$pb.TagNumber(13)
  set priceSell($core.double v) { $_setFloat(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasPriceSell() => $_has(12);
  @$pb.TagNumber(13)
  void clearPriceSell() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get priceImport => $_getN(13);
  @$pb.TagNumber(14)
  set priceImport($core.double v) { $_setFloat(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasPriceImport() => $_has(13);
  @$pb.TagNumber(14)
  void clearPriceImport() => clearField(14);

  @$pb.TagNumber(15)
  $core.double get revenue => $_getN(14);
  @$pb.TagNumber(15)
  set revenue($core.double v) { $_setFloat(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasRevenue() => $_has(14);
  @$pb.TagNumber(15)
  void clearRevenue() => clearField(15);
}

class Unit extends $pb.GeneratedMessage {
  factory Unit({
    $core.int? id,
    $core.String? name,
    $core.int? value,
    $core.double? sellPrice,
    $core.double? importPrice,
    $core.double? weight,
    $core.String? weightUnit,
    $core.bool? default_8,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (value != null) {
      $result.value = value;
    }
    if (sellPrice != null) {
      $result.sellPrice = sellPrice;
    }
    if (importPrice != null) {
      $result.importPrice = importPrice;
    }
    if (weight != null) {
      $result.weight = weight;
    }
    if (weightUnit != null) {
      $result.weightUnit = weightUnit;
    }
    if (default_8 != null) {
      $result.default_8 = default_8;
    }
    return $result;
  }
  Unit._() : super();
  factory Unit.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Unit.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Unit', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'value', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'sellPrice', $pb.PbFieldType.OF)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'importPrice', $pb.PbFieldType.OF)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'weight', $pb.PbFieldType.OF)
    ..aOS(7, _omitFieldNames ? '' : 'weightUnit')
    ..aOB(8, _omitFieldNames ? '' : 'default')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Unit clone() => Unit()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Unit copyWith(void Function(Unit) updates) => super.copyWith((message) => updates(message as Unit)) as Unit;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Unit create() => Unit._();
  Unit createEmptyInstance() => create();
  static $pb.PbList<Unit> createRepeated() => $pb.PbList<Unit>();
  @$core.pragma('dart2js:noInline')
  static Unit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Unit>(create);
  static Unit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get value => $_getIZ(2);
  @$pb.TagNumber(3)
  set value($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get sellPrice => $_getN(3);
  @$pb.TagNumber(4)
  set sellPrice($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSellPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearSellPrice() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get importPrice => $_getN(4);
  @$pb.TagNumber(5)
  set importPrice($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImportPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearImportPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get weight => $_getN(5);
  @$pb.TagNumber(6)
  set weight($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearWeight() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get weightUnit => $_getSZ(6);
  @$pb.TagNumber(7)
  set weightUnit($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasWeightUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearWeightUnit() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get default_8 => $_getBF(7);
  @$pb.TagNumber(8)
  set default_8($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDefault_8() => $_has(7);
  @$pb.TagNumber(8)
  void clearDefault_8() => clearField(8);
}

class VariantScanRequest extends $pb.GeneratedMessage {
  factory VariantScanRequest({
    $core.int? company,
    $core.String? code,
  }) {
    final $result = create();
    if (company != null) {
      $result.company = company;
    }
    if (code != null) {
      $result.code = code;
    }
    return $result;
  }
  VariantScanRequest._() : super();
  factory VariantScanRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VariantScanRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VariantScanRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'company', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VariantScanRequest clone() => VariantScanRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VariantScanRequest copyWith(void Function(VariantScanRequest) updates) => super.copyWith((message) => updates(message as VariantScanRequest)) as VariantScanRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VariantScanRequest create() => VariantScanRequest._();
  VariantScanRequest createEmptyInstance() => create();
  static $pb.PbList<VariantScanRequest> createRepeated() => $pb.PbList<VariantScanRequest>();
  @$core.pragma('dart2js:noInline')
  static VariantScanRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VariantScanRequest>(create);
  static VariantScanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get company => $_getIZ(0);
  @$pb.TagNumber(1)
  set company($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCompany() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompany() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);
}

class VariantScanResponse extends $pb.GeneratedMessage {
  factory VariantScanResponse({
    $core.int? code,
    $core.String? message,
    Variant? details,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (details != null) {
      $result.details = details;
    }
    return $result;
  }
  VariantScanResponse._() : super();
  factory VariantScanResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VariantScanResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VariantScanResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<Variant>(3, _omitFieldNames ? '' : 'details', subBuilder: Variant.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VariantScanResponse clone() => VariantScanResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VariantScanResponse copyWith(void Function(VariantScanResponse) updates) => super.copyWith((message) => updates(message as VariantScanResponse)) as VariantScanResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VariantScanResponse create() => VariantScanResponse._();
  VariantScanResponse createEmptyInstance() => create();
  static $pb.PbList<VariantScanResponse> createRepeated() => $pb.PbList<VariantScanResponse>();
  @$core.pragma('dart2js:noInline')
  static VariantScanResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VariantScanResponse>(create);
  static VariantScanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  Variant get details => $_getN(2);
  @$pb.TagNumber(3)
  set details(Variant v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDetails() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetails() => clearField(3);
  @$pb.TagNumber(3)
  Variant ensureDetails() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
