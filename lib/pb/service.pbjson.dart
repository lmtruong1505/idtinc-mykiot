//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use variantDescriptor instead')
const Variant$json = {
  '1': 'Variant',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'barcode', '3': 4, '4': 1, '5': 9, '10': 'barcode'},
    {'1': 'decision_number', '3': 5, '4': 1, '5': 9, '10': 'decisionNumber'},
    {'1': 'register_number', '3': 6, '4': 1, '5': 9, '10': 'registerNumber'},
    {'1': 'longevity', '3': 7, '4': 1, '5': 9, '10': 'longevity'},
    {'1': 'vat', '3': 8, '4': 1, '5': 2, '10': 'vat'},
    {'1': 'product', '3': 9, '4': 1, '5': 5, '10': 'product'},
    {'1': 'media', '3': 10, '4': 1, '5': 9, '10': 'media'},
    {'1': 'quantity_in_stock', '3': 11, '4': 1, '5': 5, '9': 0, '10': 'quantityInStock', '17': true},
    {'1': 'units', '3': 12, '4': 3, '5': 11, '6': '.pb.Unit', '10': 'units'},
    {'1': 'price_sell', '3': 13, '4': 1, '5': 2, '10': 'priceSell'},
    {'1': 'price_import', '3': 14, '4': 1, '5': 2, '10': 'priceImport'},
    {'1': 'revenue', '3': 15, '4': 1, '5': 2, '9': 1, '10': 'revenue', '17': true},
  ],
  '8': [
    {'1': '_quantity_in_stock'},
    {'1': '_revenue'},
  ],
};

/// Descriptor for `Variant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List variantDescriptor = $convert.base64Decode(
    'CgdWYXJpYW50Eg4KAmlkGAEgASgFUgJpZBISCgRjb2RlGAIgASgJUgRjb2RlEhIKBG5hbWUYAy'
    'ABKAlSBG5hbWUSGAoHYmFyY29kZRgEIAEoCVIHYmFyY29kZRInCg9kZWNpc2lvbl9udW1iZXIY'
    'BSABKAlSDmRlY2lzaW9uTnVtYmVyEicKD3JlZ2lzdGVyX251bWJlchgGIAEoCVIOcmVnaXN0ZX'
    'JOdW1iZXISHAoJbG9uZ2V2aXR5GAcgASgJUglsb25nZXZpdHkSEAoDdmF0GAggASgCUgN2YXQS'
    'GAoHcHJvZHVjdBgJIAEoBVIHcHJvZHVjdBIUCgVtZWRpYRgKIAEoCVIFbWVkaWESLwoRcXVhbn'
    'RpdHlfaW5fc3RvY2sYCyABKAVIAFIPcXVhbnRpdHlJblN0b2NriAEBEh4KBXVuaXRzGAwgAygL'
    'MggucGIuVW5pdFIFdW5pdHMSHQoKcHJpY2Vfc2VsbBgNIAEoAlIJcHJpY2VTZWxsEiEKDHByaW'
    'NlX2ltcG9ydBgOIAEoAlILcHJpY2VJbXBvcnQSHQoHcmV2ZW51ZRgPIAEoAkgBUgdyZXZlbnVl'
    'iAEBQhQKEl9xdWFudGl0eV9pbl9zdG9ja0IKCghfcmV2ZW51ZQ==');

@$core.Deprecated('Use unitDescriptor instead')
const Unit$json = {
  '1': 'Unit',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 3, '4': 1, '5': 5, '10': 'value'},
    {'1': 'sell_price', '3': 4, '4': 1, '5': 2, '10': 'sellPrice'},
    {'1': 'import_price', '3': 5, '4': 1, '5': 2, '10': 'importPrice'},
    {'1': 'weight', '3': 6, '4': 1, '5': 2, '10': 'weight'},
    {'1': 'weight_unit', '3': 7, '4': 1, '5': 9, '10': 'weightUnit'},
    {'1': 'default', '3': 8, '4': 1, '5': 8, '10': 'default'},
  ],
};

/// Descriptor for `Unit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unitDescriptor = $convert.base64Decode(
    'CgRVbml0Eg4KAmlkGAEgASgFUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBXZhbHVlGAMgAS'
    'gFUgV2YWx1ZRIdCgpzZWxsX3ByaWNlGAQgASgCUglzZWxsUHJpY2USIQoMaW1wb3J0X3ByaWNl'
    'GAUgASgCUgtpbXBvcnRQcmljZRIWCgZ3ZWlnaHQYBiABKAJSBndlaWdodBIfCgt3ZWlnaHRfdW'
    '5pdBgHIAEoCVIKd2VpZ2h0VW5pdBIYCgdkZWZhdWx0GAggASgIUgdkZWZhdWx0');

@$core.Deprecated('Use variantScanRequestDescriptor instead')
const VariantScanRequest$json = {
  '1': 'VariantScanRequest',
  '2': [
    {'1': 'company', '3': 1, '4': 1, '5': 5, '10': 'company'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `VariantScanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List variantScanRequestDescriptor = $convert.base64Decode(
    'ChJWYXJpYW50U2NhblJlcXVlc3QSGAoHY29tcGFueRgBIAEoBVIHY29tcGFueRISCgRjb2RlGA'
    'IgASgJUgRjb2Rl');

@$core.Deprecated('Use variantScanResponseDescriptor instead')
const VariantScanResponse$json = {
  '1': 'VariantScanResponse',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'details', '3': 3, '4': 1, '5': 11, '6': '.pb.Variant', '9': 0, '10': 'details', '17': true},
  ],
  '8': [
    {'1': '_details'},
  ],
};

/// Descriptor for `VariantScanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List variantScanResponseDescriptor = $convert.base64Decode(
    'ChNWYXJpYW50U2NhblJlc3BvbnNlEhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIA'
    'EoCVIHbWVzc2FnZRIqCgdkZXRhaWxzGAMgASgLMgsucGIuVmFyaWFudEgAUgdkZXRhaWxziAEB'
    'QgoKCF9kZXRhaWxz');

