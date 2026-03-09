//
//  Generated code. Do not modify.
//  source: service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'service.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('pb.Pharmago')
class PharmagoClient extends $grpc.Client {
  static final _$scanVariant = $grpc.ClientMethod<$0.VariantScanRequest, $0.VariantScanResponse>(
      '/pb.Pharmago/ScanVariant',
      ($0.VariantScanRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.VariantScanResponse.fromBuffer(value));

  PharmagoClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.VariantScanResponse> scanVariant($async.Stream<$0.VariantScanRequest> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$scanVariant, request, options: options);
  }
}

@$pb.GrpcServiceName('pb.Pharmago')
abstract class PharmagoServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.Pharmago';

  PharmagoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.VariantScanRequest, $0.VariantScanResponse>(
        'ScanVariant',
        scanVariant,
        true,
        true,
        ($core.List<$core.int> value) => $0.VariantScanRequest.fromBuffer(value),
        ($0.VariantScanResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.VariantScanResponse> scanVariant($grpc.ServiceCall call, $async.Stream<$0.VariantScanRequest> request);
}
